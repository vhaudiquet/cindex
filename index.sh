#!/bin/sh

gcc_dumpmachine=$(gcc -dumpmachine)
gcc_version=$(gcc -dumpversion)

gcc_program_output=/tmp/a.out

# Check for --local-system option
if [ "$1" == "--local-system" ]; then
	local_system=1

	# Check for local system name
	if [ -z "$2" ]; then
		echo "Error: local system name not specified"
		echo "Usage: ./index.sh [--local-system <name> <./lib,./include path>]"
		return 1 2>/dev/null || exit 1
	fi
	local_system_name=$2

	# Check for local system path
	if [ -z "$3" ]; then
		echo "Error: local system path not specified"
		echo "Usage: ./index.sh [--local-system <name> <./lib,./include path>]"
		return 1 2>/dev/null || exit 1
	fi
	local_system_path=$3
else
	local_system=0
fi

# LIBC
libc_names=("glibc" "musl" "uClibc-ng" "dietlibc")

# Present/Absent markers (colors)
p="\e[32m"
pe="\e[0m"
n="\e[31m"
ne="\e[0m"

# Warning markers (colors)
w="\e[33m"
we="\e[0m"

# C Standards
cstd=("c89" "c99" "c11" "c2x")

# SuS standards
sus=("susv2" "susv3" "susv4")

# Headers
sus_headers=("aio" "arpa/inet" "assert" "complex" "cpio" "ctype" "dirent" "dlfcn" "errno" "fcntl" "fenv" "float" "fmtmsg" "fnmatch" "ftw" "glob" "grp" "iconv" "inttypes" "iso646" "langinfo" "libgen" "limits" "locale" "math" "monetary" "mqueue" "ndbm" "net/if" "netdb" "netinet/in" "netinet/tcp" "nl_types" "poll" "pthread" "pwd" "regex" "sched" "search" "semaphore" "setjmp" "signal" "spawn" "stdarg" "stdbool" "stddef" "stdint" "stdio" "stdlib" "string" "strings" "stropts" "sys/ipc" "sys/mman" "sys/msg" "sys/resource" "sys/select" "sys/sem" "sys/shm" "sys/socket" "sys/stat" "sys/statvfs" "sys/time" "sys/times" "sys/types" "sys/uio" "sys/un" "sys/utsname" "sys/wait" "syslog" "tar" "termios" "tgmath" "time" "trace" "ulimit" "unistd" "utime" "utmpx" "wchar" "wctype" "wordexp")
c89=("assert" "ctype" "errno" "float" "limits" "locale" "math" "setjmp" "signal" "stdarg" "stddef" "stdio" "stdlib" "string" "time")
c99=(${c89[@]} "complex" "fenv" "inttypes" "iso646" "stdbool" "stdint" "tgmath" "wchar" "wctype")
c11=(${c99[@]} "stdalign" "stdatomic" "stdnoreturn" "threads")
c2x=(${c11[@]} "stdbit" "stdckdint")

# Headers list
combined=("${sus_headers[@]}" "${c2x[@]}")
headers=($(printf '%s\n' ${combined[@]} | sort -u))

# Import functions
source ./stdh.sh

check_std_c() {
	for std in ${cstd[@]}; do
		json+="\"${std}\":"

		# Check if header is included in current standard
		std_headers=($(eval 'echo ${'$std'[@]}'))
		printf '%s\0' "${std_headers[@]}" | grep -Fxqz -- $header_name
		if [ ! $? -eq 0 ]; then
			json+="false,"
			echo -e -n $n$std$ne" "
			continue
		fi

		# Compile a program doing `if(function)`
		echo -e "#include <${header_name}.h>\nint main()\n{\n\tif("$f") return 0; else return 1;\n}\n" | gcc -std=$std -xc - -o ${gcc_program_output} >/dev/null 2>&1

		# Check gcc output
		if [ $? -eq 0 ]; then
			${gcc_program_output}
			if [ $? -eq 0 ]; then
				json+="true"
				echo -e -n $p$std$pe" "
			else
				json+="false"
				echo -e -n $n$std$ne" "
			fi
		else
			# Check if function is in fact a macro
			echo -e "#include <${header_name}.h>\nint main()\n{\n\t#ifdef ${f}\n\treturn 0;\n\t#else\n\treturn 1;\n\t#endif\n}\n" | gcc -std=$std -xc - -o ${gcc_program_output} >/dev/null 2>&1
			if [ ! $? -eq 0 ]; then
				# This should never fail unless header is broken
				echo -e "\nFatal: ${f}() in ${header_name} resolution as macro made gcc fail"
				echo "		 This should never happen, please report this bug"
				return 1 2>/dev/null || exit 1
			fi
			${gcc_program_output}
			if [ $? -eq 0 ]; then
				json+="true"
				echo -e -n $p$std$pe" "
			else
				json+="false"
				echo -e -n $n$std$ne" "
			fi
		fi
		json+=","
	done
}

check_for_libc() {
	lib_name=$1
	lib_dir=$2
	lib_path=$2/lib/libc.a

	# Check for symbol in libc
	json+="\""$lib_name"\":"
	objdump -t $lib_path | grep -w $f"$" >/dev/null
	if [ $? -eq 0 ]; then
		json+="true"
		echo -e -n $p$lib_name$pe" "
	else
		# Function not found in libc : check in other libraries in the same directory
		found=false
		other_libs=($(find ${lib_dir}/lib -maxdepth 1 -name "*.a" '!' -name "libc.a"))

		# If header is math.h/complex.h, begin searching in math library
		if [ $header_name = "math" ] || [ $header_name = "complex" ] || [ $header_name = "fenv" ]; then
			other_libs+=($other_libs)
			other_libs[0]="${lib_dir}/lib/libm.a"
		fi

		# If header is threads.h/pthread.h, begin searching in libpthread
		if [ $header_name = "threads" ] || [ $header_name = "pthread" ]; then
			other_libs+=($other_libs)
			other_libs[0]="${lib_dir}/lib/libpthread.a"
		fi

		# If header is aio.h, begin searching in librt
		if [ $header_name = "aio" ]; then
			other_libs+=($other_libs)
			other_libs[0]="${lib_dir}/lib/librt.a"
		fi

		for lib in ${other_libs[@]}; do
			objdump -t $lib 2>/dev/null | grep -w $f"$" >/dev/null 2>&1
			if [ $? -eq 0 ]; then
				# Obtain library name, and remove extension
				olib_name=$(basename $lib)
				olib_name=${olib_name%.*}
				olib_name=${olib_name%-*}

				found=true
				json+="true"
				echo -e -n $p$lib_name"(${olib_name})"$pe" "
				break
			fi
		done

		if [ $found = false ]; then
			# Function not found in any library ; check in headers
			# Check if header is present
			if [ -f "${lib_dir}/include/${header_name}.h" ]; then
				if [ $local_system -eq 0 ]; then
					link_entry=""
					# Check for crt1.o, crti.o and crtn.o
					if [ -f "${lib_dir}/lib/crt1.o" ]; then
						link_entry+="-l:crt1.o "
					fi
					if [ -f "${lib_dir}/lib/crti.o" ]; then
						link_entry+="-l:crti.o "
					fi
					if [ -f "${lib_dir}/lib/crtn.o" ]; then
						link_entry+="-l:crtn.o "
					fi

					# Check for start.o
					if [ -f "${lib_dir}/lib/start.o" ]; then
						link_entry+="-l:start.o "
					fi

					echo -e "#include <${header_name}.h>\nint main()\n{\n\t#ifdef ${f}\n\t\treturn 0;\n\t#else\n\t\treturn 1;\n\t#endif\n}" | gcc -o ${gcc_program_output} -ffreestanding -nostdlib -xc -I${lib_dir}/include/ -I/usr/lib/gcc/${gcc_dumpmachine}/${gcc_version}/include - -L${lib_dir}/lib/ ${link_entry} -lc -lgcc -lgcc_eh -static >/dev/null 2>&1
				else
					echo -e "#include <${header_name}.h>\nint main()\n{\n\t#ifdef ${f}\n\t\treturn 0;\n\t#else\n\t\treturn 1;\n\t#endif\n}" | gcc -o ${gcc_program_output} -xc - >/dev/null 2>&1
				fi

				if [ $? -eq 0 ]; then
					${gcc_program_output}
					if [ $? -eq 0 ]; then
						json+="true"
						echo -e -n $p$lib_name"(macro)"$pe" "
					else
						json+="false"
						echo -e -n $n$lib_name$ne" "
					fi
				else
					json+="false"
					echo -e -n $n$lib_name$ne$w"(?)"$we" "
				fi
			else
				json+="false"
				echo -e -n $n$lib_name$ne" "
			fi
		fi
	fi
	json+=","
}

check_for_sus() {
	# Check for function file in ./susvx/functions/$f
	for s in ${sus[@]}; do
		json+="\""$s"\":"
		if [ -f "./$s/functions/$f.html" ] || [ -f "./$s/xsh/$f.html" ] || [ -f "./$s/xns/$f.html" ]; then
			json+="true"
			echo -e -n $p$s$pe" "
		else
			json+="false"
			echo -e -n $n$s$ne" "
		fi
		json+=","
	done
}

for i in ${!headers[@]}; do
	header_name=${headers[$i]}
	echo "header file "$header_name".h:"
	json="["
	header_name_clean=$(echo $header_name | sed 's/\//_/g')
	header_fns=($(eval 'echo ${'$header_name_clean'[@]}'))
	for f in ${header_fns[@]}; do
		json+="{\"name\":\""$f"\",\"type\":\"function\","

		echo -n "checking for "$f"()... "

		# Check for symbol in libc
		if [ $local_system -eq 0 ]; then
			for i in ${!libc_names[@]}; do
				lib_name=${libc_names[$i]}
				lib_dir="./libs/${lib_name}"

				check_for_libc $lib_name $lib_dir
			done
		else
			check_for_libc $local_system_name $local_system_path
		fi

		# Check for standards
		if [ $local_system -eq 0 ]; then
			check_std_c
			check_for_sus
		fi

		json+="\"header\":\"${header_name}\"},"
		echo ""
	done

	# Output JSON
	json+="{}"
	json+=" ]"
	o="output/${header_name}.json"
	mkdir -p "${o%/*}"
	echo -e $json >output/$header_name.json
done

# Cleanup
rm -f ${gcc_program_output}
