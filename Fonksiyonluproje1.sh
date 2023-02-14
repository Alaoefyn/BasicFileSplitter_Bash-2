#!/usr/bin/bash

splitFile() {
    local filename
    filename=$(basename -- "$1")
    local extension="${filename##*.}"
    filename="${filename%.*}"

    local numberOfFiles="$2"
    local numberOfLines="$3"

    local remainder=$(($3 % $2))
    local linesToSplit=$(($3 / $2))

    local currentPart

    for (( i=1; i<=numberOfFiles; i++ )); do
        if [ $remainder -gt 0 ]; then
            currentPart=$((linesToSplit + 1))
            ((remainder--))
        else
            currentPart=${linesToSplit}
        fi
        
        tail -n $(( numberOfLines - ((i-1) * currentPart) )) "$1" | head -n $currentPart > "$filename-$i.$extension"
    done

}

main() {
    local -r numberOfLines=$(wc -l "$1" | cut -d " " -f 1)

    # check if argumants are only 2 
    if [ $# -ne 2 ]; then
        echo "Usage: $0 <arg1> <arg2>"
        exit 1
    # check if arg1 is a file
    elif [ ! -f "$1" ]; then
        echo "Error: $1 is not a file"
        exit 1
    # check if arg2 is positive integer
    elif [ "$2" -le 0 ]; then
        echo "Error: $2 is not a positive integer"
        exit 1
    # check if arg2 is smaller than arg1 number of lines
    elif [ "$2" -gt "$numberOfLines" ]; then
        echo "Error: $2 is larger than $1 number of lines"
        exit 1
    # if all checks are passed, run main function
    else
        splitFile "$1" "$2" "$numberOfLines"
    fi
}

main "$@"