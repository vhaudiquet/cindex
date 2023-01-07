# Generate multiple function arrays from man2 and man3 entries

ls /usr/share/man/man2 | sed 's/\.2.*//' | while read F; do
    I=$(man 2 $F | grep '#include' | head -1 | sed 's/>.*$/>/')
    if [ -z "$I" ]; then
        continue
    fi

    i_name=$(echo $I | sed 's/.*<//;s/>.*//')
    i_name_clean=$(echo $i_name | sed 's/\//_/g' | sed 's/\.h//')

    # Add $f to $i_name_clean array
    eval "${i_name_clean}+=(\"${F}\")"
    echo "${i_name_clean}+=(\"${F}\")"
done

echo "Example output:"
echo "unistd=(${unistd[@]})"
echo "sys_uio=(${sys_uio[@]})"
