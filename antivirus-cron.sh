#!/bin/bash

# 1-> dir, 2-> malicious_dir

for file in ${1}/*; do # '=' is equals normal, '==' is pattern matching

    if grep -Eiq 'virus|trojan|malware|worm|ransomware' $file || 
    [[ $file == *.exe || $file == *.bat || $file == *.vbs || $file == *.scr || $file == *.ps1 ]]; then


#-F->treat filename as literal text,-q to quite output in terminal cuz we only care about its exit status(0(success) or 1(fail))
        if ! grep -Fq $(basename $file) /home/vboxuser/Desktop/os_labs/lab2/whitelist.txt ; then
            echo $file is malicious and it is DELETED
            cp "$file" ${2}
            rm "$file"
        fi

    fi

done