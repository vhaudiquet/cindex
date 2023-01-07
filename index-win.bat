# Index functions of libc (Windows)

# Obtain local MSVC version
$msvc_version=Get-Content 'C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\Microsoft.VCToolsVersion.default.txt'
echo "MSVC version: ${msvc_version}"

# Make sure the MSVC command line tools are installed and in the path
$msvc_path="C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Tools\MSVC\${msvc_version}\bin\Hostx64\x64\cl.exe"
$msvc=&$msvc_path
if (-not $?)
{
    # cl.exe not found...
    echo "Could not find the MSVC compiler (cl.exe) ; searched: "
    echo $msvc_path
    exit 1
}
$dumpbin_path="C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Tools\MSVC\${msvc_version}\bin\Hostx64\x64\dumpbin.exe"

# Use dumpbin to index functions of libc
&$dumpbin_path /exports C:\Windows\SysWOW64\msvcrt.dll 
