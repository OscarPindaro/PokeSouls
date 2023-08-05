import xmltodict, json, os

BASE_PATH = "."
# where the sprites are
sprite_path = os.path.join(BASE_PATH, "Images", "SpriteCollab", "sprite")
# content of sprite directory
dirs = os.listdir(sprite_path)
for name in dirs:
    # ignore hidden files
    if name.startswith("."):
        pass
    else:
        anim_data_path = os.path.join(sprite_path, name, "AnimData.xml")
        anim_data_path_json = os.path.join(sprite_path, name, "AnimData.json")
        with open(anim_data_path, "r") as f:
            dict_anim_data = xmltodict.parse(f.read())
            with open(anim_data_path_json, "w") as g:
                json.dump(dict_anim_data, g, indent=2)




