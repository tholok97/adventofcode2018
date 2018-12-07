#!/bin/bash

# Hello I am a change to trigger a travis build

# Inspiration for $sed_pairs: https://unix.stackexchange.com/a/340080
# NOTES: 
#   - tr -d '[[:space:]]' is used to remove whitespace. Worth noting that tr -d '\n' 
#     works fine on my Ubuntu 18.04, but the OSX testing machine requires [[:space:]] 
#     because sed prints extra leading for some reason
#   - PART 2 could probably be sped up a whole lot by figuring out a way to 
#     call sed only once. Give it one line per removed character for example?

# PART 1

input=$(</dev/stdin)
sed_pairs="$(echo {a..z} | sed 's/\(\b\w\b\)\s*/\1\u\1|\u\1\1|/g;s/|$//')"
echo $sed_pairs
part_1_solution=$(echo "$input" | sed -E ":a s/$sed_pairs//g;ta;s/\s//g" | tr -d '\n' | wc -c)
echo "$part_1_solution"

# PART 2

min_length=$part_1_solution
for char in {a..z}; do

    # remove all instances of $char
    completely_reacted=${input//$char/}

    # remove all instances of the uppercased $char
    upperchar=${char^^}
    completely_reacted=${completely_reacted//$upperchar/}

    length=$(echo "$completely_reacted" | sed -E ":a s/$sed_pairs//g;ta;s/\s//g" | tr -d '\n' | wc -c)
    if [[ $length -lt $min_length ]]; then
        min_length=$length
    fi
done

echo "$min_length"
