import xmltodict, json, os
import argparse
parser = argparse.ArgumentParser(description='Convert animation data from XML to JSON.')
parser.add_argument('--sprite_path', type=str, default='Images/PokemonSprites', help='Path to the sprite directory')
args = parser.parse_args()

BASE_PATH = "."
sprite_path = os.path.join(BASE_PATH, args.sprite_path)
dirs = os.listdir(sprite_path)
for name in dirs:
    if name.startswith("."):
        pass
    else:
        anim_data_path = os.path.join(sprite_path, name, "AnimData.xml")
        anim_data_path_json = os.path.join(sprite_path, name, "AnimData.json")
        if os.path.isdir(anim_data_path):
            with open(anim_data_path, "r") as f:
                dict_anim_data = xmltodict.parse(f.read())
                with open(anim_data_path_json, "w") as g:
                    json.dump(dict_anim_data, g, indent=2)
        
        # with open(anim_data_path, "r") as f:
        #     dict_anim_data = xmltodict.parse(f.read())
        #     with open(anim_data_path_json, "w") as g:
        #         json.dump(dict_anim_data, g, indent=2)



