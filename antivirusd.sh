#!/bin/bash

for file in dir/*; do # '=' is equals normal, '==' is pattern matching
    if grep -Ei 'virus|trojan|malware|worm|ransomware' $file || 
    [[ $file == *.exe || $file == *.bat || $file == *.vbs || $file == *.scr || $file == *.ps1 ]]; then
        echo $file is malicious and it is DELETED
        cp "$file" malicious_dir
        rm "$file"
    fi
done

ls -l dir > directory-info.last

while true
do
    sleep 2
    ls -l dir > directory-info.new

    #return 0 if successful (files identical), returns 1 if files differ (as most things in linux return 0 when success and 1 when fail)
    if diff directory-info.last directory-info.new > /dev/null
    then
        echo No change
    else
        echo dir changed

        for file in dir/*; do # '=' is equals normal, '==' is pattern matching
            if grep -Ei 'virus|trojan|malware|worm|ransomware' $file || #-E enable the | in the expression, -i makes search case insensitive
            [[ $file == *.exe || $file == *.bat || $file == *.vbs || $file == *.scr || $file == *.ps1 ]]
            then
                echo $file is malicious and it is DELETED
                cp "$file" malicious_dir
                rm "$file"
            fi
        done

        ls -l dir > directory-info.last
    fi
done