#!/bin/bash

# 1-> dir, 2-> malicious_dir


while true
do
    shopt -s nullglob
    file_array=(${2}/*)

    if [[ ${#file_array[@]} -eq 0 ]]; then
        echo No malicious files to review
        break
    fi


    echo Choose Number of File to Interact with
    i=1
    for file in ${2}/*
    do
        echo "$i) $file"
        ((i++))
    done
    read file_number

    ((file_number--))

    echo Perform Action On ${file_array[$file_number]}
    echo 1. Restore ${file_array[$file_number]} to dir
    echo "2. Permanently Delete ${file_array[$file_number]}"
    echo "3. Leave ${file_array[$file_number]} as it is and Go Back to the File List"

    read input

    case $input in
        1)
            cp ${file_array[$file_number]} ${1}
            rm ${file_array[$file_number]}
            echo Restored ${file_array[$file_number]} to dir
            break
            ;;
        2)
            rm ${file_array[$file_number]}
            ${file_array[$file_number]} Permanently Deleted
            break
            ;;
        *)
            continue
            ;;
    esac
done
    

