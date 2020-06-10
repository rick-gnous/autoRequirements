#!/bin/bash
path=${1:-.}

INDEX=0
installedPackage=($(pip3 freeze))
packagePutInReq=()

contains() {
    value=$1
    i=0
    for element in "${installedPackage[@]}"; do
        element=$(cut -d= -f1 <<< $element)
        if [[ "$element" == "$value" ]]; then
            INDEX=$i
            return 0
            break
        fi
        i=$((i+1))
    done
    return 1
}

checkContains() {
    value=$1
    for element in "${packagePutInReq[@]}"; do
        if [[ "$value" == "$element" ]]; then
            return 0
        fi
    done
    return 1
}

for file in $(find $path -iname "*.py"); do
    while read -r line; do
        package=$(cut -d' ' -f2 <<< $line)
        contains $package 
        if [ $? -eq 0 ]; then
            newPackage=${installedPackage[$INDEX]}
            echo $newPackage
            checkContains $newPackage
            if [ $? -eq 1 ]; then
                packagePutInReq+=($newPackage)
            fi
            echo "${packagePutInReq[@]}"
        fi
    done < <(grep '\(^[[:blank:]]*import\)\|\(^[[:blank:]]*from\)' $file)
done

touch 'requirements.txt'
for package in "${packagePutInReq[@]}"; do
    echo $package >> 'requirements.txt'
done
