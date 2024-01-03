# %%
import json
from tqdm import tqdm, trange

import argparse

def parse_arguments():
    # Default values
    default_pokedex_path = "pokemon.json/pokedex.json"
    default_result = "Images/PokemonSprites/poke-numbers.json"

    parser = argparse.ArgumentParser(description="Command line arguments parser")

    # Adding arguments
    parser.add_argument('-p', '--pokedex', type=str, default=default_pokedex_path,
                        help='Path to the pokedex file ("pokemon.json/pokedex.json")')
    parser.add_argument('-r', '--result', type=str, default=default_result,
                        help='Path to the result file (default: Images/SpriteCollab/poke-numbers.json)')

    return parser.parse_args()

# Example usage:
if __name__ == "__main__":
    args = parse_arguments()

    # Accessing the parsed arguments
    pokedex_path = args.pokedex
    result = args.result

    print(f"Pokedex path: {pokedex_path}")
    print(f"Result path: {result}")

    # %%
    with open(pokedex_path, "r") as f:
        pokedex = json.load(f)

    # %%

    poke_dict = {pokemon["name"]["english"]:f"{pokemon['id']:04d}" for pokemon in pokedex}

    # %%
    with open(result, "w") as g:
        json.dump(poke_dict, g)


