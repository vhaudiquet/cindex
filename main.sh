#!/bin/sh

# Check if gcc is installed
if ! [ -x "$(command -v gcc)" ]; then
    echo "Error: gcc is not installed"
    return 1 2>/dev/null || exit 1
fi

# Check host architecture
host_triple=$(gcc -dumpmachine)
if [ $? -ne 0 ]; then
    echo "Error: gcc dumpmachine failed"
    return 1 2>/dev/null || exit 1
fi
if [ $host_triple != "x86_64-pc-linux-gnu" ]; then
    echo "Error: host architecture is not x86_64-linux-gnu"
    return 1 2>/dev/null || exit 1
fi

# Check if libs are installed
if [ ! -d "libs" ]; then
    echo "Installing libs"
    ./getlib.sh
    if [ $? -ne 0 ]; then
        echo "Error: getlib failed"
        return 1 2>/dev/null || exit 1
    fi
fi

# Check if susvx are installed
sus=("susv2" "susv3" "susv4")
for s in ${sus[@]}; do
    if [ ! -d "$s" ]; then
        echo "Error: Please obtain the '$s' directory from the Open Group"
        return 1 2>/dev/null || exit 1
    fi
done

# Index libraries
./index.sh

# Move output
mv output/ output-index/

# Ask the user to run on multiple systems
echo "The script will ssh run on other systems (MacOS, FreeBSD, ...) and merge the results"
#echo "Usage: ./index.sh --local-system <system name> <system /lib,/include path>"
#echo "To merge multiple results : ./merge.sh <output> <input1> <input2>"

echo "------------------------------------------------------------"
echo "FreeBSD : bash index.sh --local-system freebsd-libc /usr/"
scp index.sh freebsd:/home/$USER/index.sh
scp stdh.sh freebsd:/home/$USER/stdh.sh
ssh freebsd "bash index.sh --local-system freebsd-libc /usr/"
scp -r freebsd:/home/$USER/output ./output-freebsd
echo "------------------------------------------------------------"
echo "OpenBSD : bash index.sh --local-system openbsd-libc /usr/"
scp index.sh openbsd:/home/$USER/index.sh
scp stdh.sh openbsd:/home/$USER/stdh.sh
ssh openbsd "bash index.sh --local-system openbsd-libc /usr/"
scp -r openbsd:/home/$USER/output ./output-openbsd
echo "------------------------------------------------------------"
echo "NetBSD : bash index.sh --local-system netbsd-libc /usr/"
scp index.sh netbsd:/home/$USER/index.sh
scp stdh.sh netbsd:/home/$USER/stdh.sh
ssh netbsd "bash index.sh --local-system netbsd-libc /usr/"
scp -r netbsd:/home/$USER/output ./output-netbsd
echo "------------------------------------------------------------"
echo "DragonFlyBSD : bash index.sh --local-system dragonflybsd-libc /usr/"
scp index.sh dragonflybsd:/home/$USER/index.sh
scp stdh.sh dragonflybsd:/home/$USER/stdh.sh
ssh dragonflybsd "bash index.sh --local-system dragonflybsd-libc /usr/"
scp -r dragonflybsd:/home/$USER/output ./output-dragonflybsd
echo "------------------------------------------------------------"
echo "MacOS : ./index-macos.sh"
read -p "Press enter to continue"
echo "------------------------------------------------------------"
echo "Windows : ./index-win.bat"
read -p "Press enter to continue"
echo "------------------------------------------------------------"
echo "Now merge the results : ./merge.sh <output> <input1> <input2>"
./merge.sh output-f output-index output-freebsd
./merge.sh output-ff output-f output-openbsd
./merge.sh output-fff output-ff output-netbsd
./merge.sh output-ffff output-fff output-dragonflybsd
rm -rf output-f output-ff output-fff
mv output-ffff output-f
./merge-bigjson.sh output.json output-f
echo "------------------------------------------------------------"
echo "Everything is done"
