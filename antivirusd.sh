#!/bin/bash

# 1-> dir, 2-> malicious_dir, 3-> wait time in sec

for file in ${1}/*; do # '=' is equals normal, '==' is pattern matching

    if grep -Eiq 'virus|trojan|malware|worm|ransomware' $file || 
    [[ $file == *.exe || $file == *.bat || $file == *.vbs || $file == *.scr || $file == *.ps1 ]]; then

#-F->treat filename as literal text,-q to quite output in terminal cuz we only care about its exit status(0(success) or 1(fail))
        if ! grep -Fq $(basename $file) whitelist.txt ; then
            echo $file is malicious and it is DELETED
            cp "$file" ${2}
            rm "$file"
        fi

    fi

done

ls -l ${1} > directory-info.last

while true
do
    sleep ${3}
    ls -l ${1} > directory-info.new

    #return 0 if successful (files identical), returns 1 if files differ (as most things in linux return 0 when success and 1 when fail)
    if diff directory-info.last directory-info.new > /dev/null
    then
        echo No change
    else
        echo dir changed

        for file in ${1}/*; do # '=' is equals normal, '==' is pattern matching

            if grep -Eiq 'virus|trojan|malware|worm|ransomware' $file || #-E enable the | in the expression, -i makes search case insensitive
            [[ $file == *.exe || $file == *.bat || $file == *.vbs || $file == *.scr || $file == *.ps1 ]]
            then

                if ! grep -Fq $(basename $file) whitelist.txt ; then #-F->treat filename as literal text
                    echo $file is malicious and it is DELETED
                    cp "$file" ${2}
                    rm "$file"
                fi

            fi

        done

        ls -l ${1} > directory-info.last
    fi
done