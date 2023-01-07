#!/bin/sh

# Create libs folder
local_path=$(realpath .)
lib_path=$local_path/libs
mkdir -p $lib_path
cd $lib_path

# Prepare build environment
mkdir -p build
cd build

# Obtain the GNU C Library (glibc)
glibc_version="2.36"
if [ ! -f "glibc-${glibc_version}.tar.xz" ]; then
    wget "https://ftp.gnu.org/gnu/libc/glibc-${glibc_version}.tar.xz"
fi
if [ ! -d "glibc-${glibc_version}" ]; then
    tar -xf glibc-${glibc_version}.tar.xz
fi
cd glibc-${glibc_version}
mkdir build
cd build
../configure --prefix=$lib_path/glibc
if [ $? -ne 0 ]; then
    echo "Error: glibc configure failed"
    return 1 2>/dev/null || exit 1
fi
make -j7
if [ $? -ne 0 ]; then
    echo "Error: glibc make failed"
    return 1 2>/dev/null || exit 1
fi
make install
if [ $? -ne 0 ]; then
    echo "Error: glibc make install failed"
    return 1 2>/dev/null || exit 1
fi
cd ../..

# Obtain musl
musl_version="1.2.3"
if [ ! -f "musl-${musl_version}.tar.gz" ]; then
    wget "https://musl.libc.org/releases/musl-${musl_version}.tar.gz"
fi
if [ ! -d "musl-${musl_version}" ]; then
    tar -xf musl-${musl_version}.tar.gz
fi
cd musl-${musl_version}
mkdir build
cd build
../configure --prefix=$lib_path/musl
if [ $? -ne 0 ]; then
    echo "Error: musl configure failed"
    return 1 2>/dev/null || exit 1
fi
make -j7
if [ $? -ne 0 ]; then
    echo "Error: musl make failed"
    return 1 2>/dev/null || exit 1
fi
make install
if [ $? -ne 0 ]; then
    echo "Error: musl make install failed"
    return 1 2>/dev/null || exit 1
fi
cd ../..

# NOTE : newlib cannot be built for x86_64-linux, as it targets embedded systems
# Only i686-linux is supported, and they do not plan to support x86_64-linux, it seems...
# # Obtain newlib
# newlib_version="4.2.0.20211231"
# if [ ! -f "newlib-${newlib_version}.tar.gz" ]
# then
#     wget "ftp://sourceware.org/pub/newlib/newlib-${newlib_version}.tar.gz"
# fi
# if [ ! -d "newlib-${newlib_version}" ]
# then
#     tar -xf newlib-${newlib_version}.tar.gz
# fi
# cd newlib-${newlib_version}/newlib
# mkdir build
# cd build
# ../configure --with-newlib --prefix=$lib_path/newlib --disable-multilib
# if [ $? -ne 0 ]; then
#     echo "Error: newlib configure failed"
#     return 1 2>/dev/null || exit 1
# fi
# make -j7
# if [ $? -ne 0 ]; then
#     echo "Error: newlib make failed"
#     return 1 2>/dev/null || exit 1
# fi
# make install
# if [ $? -ne 0 ]; then
#     echo "Error: newlib make install failed"
#     return 1 2>/dev/null || exit 1
# fi
# cd ../../..

# Obtain uClibc-ng
uClibc_ng_version="1.0.42"
if [ ! -f "uClibc-ng-${uClibc_ng_version}.tar.gz" ]; then
    wget "https://downloads.uclibc-ng.org/releases/${uClibc_ng_version}/uClibc-ng-${uClibc_ng_version}.tar.gz"
fi
if [ ! -d "uClibc-ng-${uClibc_ng_version}" ]; then
    tar -xf uClibc-ng-${uClibc_ng_version}.tar.gz
fi
cd "uClibc-ng-${uClibc_ng_version}"
make defconfig
if [ $? -ne 0 ]; then
    echo "Error: uClibc-ng make defconfig failed"
    return 1 2>/dev/null || exit 1
fi
#prefix=$lib_path/uClibc-ng
#escaped_prefix=$(printf '%s\n' "$prefix" | sed -e 's/[\/&]/\\&/g')
#sed -i -e "/RUNTIME_PREFIX=/ s/=.*/=\"${escaped_prefix}\"/" .config
sed -i -e "/HAVE_SHARED=/ s/=.*/=n/" .config
# Enable math support
# Replace "# DO_C99_MATH is not set" with "DO_C99_MATH=y"
sed -i 's/# DO_C99_MATH is not set/DO_C99_MATH=y/' .config
# Replace "# DO_XSI_MATH is not set" with "DO_XSI_MATH=y"
sed -i 's/# DO_XSI_MATH is not set/DO_XSI_MATH=y/' .config
# Add the following lines to the end of the file
echo "UCLIBC_HAS_LONG_DOUBLE_MATH=y" >>.config
# Make sure the kernel headers are set to the correct path
sed -i -e '/KERNEL\_HEADERS=/ s/=.*/=\"\/usr\/include\/\"/' .config
make -j7
if [ $? -ne 0 ]; then
    echo "Error: uClibc-ng make failed"
    echo "Maybe make sure you have the kernel headers installed at /usr/include/, or change the KERNEL_HEADERS variable in .config to the correct path ?"
    return 1 2>/dev/null || exit 1
fi
make DESTDIR=$lib_path/uClibc-ng PREFIX=$lib_path/uClibc-ng install
if [ $? -ne 0 ]; then
    echo "Error: uClibc-ng make install failed"
    return 1 2>/dev/null || exit 1
fi
mv $lib_path/uClibc-ng/usr/x86_64-linux-uclibc/usr/* $lib_path/uClibc-ng/
rm -rf $lib_path/uClibc-ng/usr
cd ..

# Obtain dietlibc
dietlibc_version="0.34"
if [ ! -f "dietlibc-${dietlibc_version}.tar.xz" ]; then
    wget "https://www.fefe.de/dietlibc/dietlibc-${dietlibc_version}.tar.xz"
fi
if [ ! -d "dietlibc-${dietlibc_version}" ]; then
    tar -xf dietlibc-${dietlibc_version}.tar.xz
fi
cd dietlibc-${dietlibc_version}
make -j7 DESTDIR=$lib_path/dietlibc
if [ $? -ne 0 ]; then
    echo "Error: dietlibc make failed"
    return 1 2>/dev/null || exit 1
fi
make install DESTDIR=$lib_path/dietlibc
if [ $? -ne 0 ]; then
    echo "Error: dietlibc make install failed"
    return 1 2>/dev/null || exit 1
fi
mv $lib_path/dietlibc/opt/diet/* $lib_path/dietlibc/
rmdir $lib_path/dietlibc/opt/diet
rmdir $lib_path/dietlibc/opt
mv $lib_path/dietlibc/lib-x86_64 $lib_path/dietlibc/lib
cd ..
