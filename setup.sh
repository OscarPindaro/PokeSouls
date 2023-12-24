#!/bin/bash

# commands for download_pokemons.sh
start=0
end_arg=10
jobs=2

# Check if arguments were provided
if [ $# -gt 0 ]; then
    while getopts ":s:e:j:" opt; do
        case $opt in
            s)
                start=$OPTARG
                ;;
            e)
                end_arg=$OPTARG
                ;;
            j)
                jobs=$OPTARG
                ;;
            \?)
                echo "Invalid option: -$OPTARG" >&2
                exit 1
                ;;
        esac
    done
fi

# Your script logic here using the variables $start, $end_arg, and $jobs
# For example, you can use these values in your script commands


# Check if the directory exists
# if [ -d "pokemon.json" ]; then
#     echo "pokemon.json directory already exists."
# else
#     # If directory doesn't exist, clone the repository
#     echo "Cloning pokemon.json repository"
#     git clone https://github.com/fanzeyi/pokemon.json
# fi

echo "Updating submodules"
git submodule update --init --recursive



echo "Downloading pokemon from $start to $end_arg" 
bash scripts/download_pokemons.sh -s $start -e $end_arg -j $jobs

echo "Converting pokedex to PokemonName -> Number association"
python scripts/python/poke_to_num.py