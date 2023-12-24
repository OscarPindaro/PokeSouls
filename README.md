# Pokesouls

## Repo Setup
In order to setup the repository you should run
```
./setup.sh
```

### Old Setup
if you dont have the sprites, clone it from git

git clone https://github.com/OscarPindaro/SpriteCollab.git

or
```bash
git clone git@github.com:OscarPindaro/SpriteCollab.git
```

Then, you need to convert the files AnimData.xml i think
```bash
python Scripts/python/ConvertAnimData.py
```
Lastly, you need a file that gives the corrispondesce between pokemon and numbers

## Pokemon Sprites
The base class is pokemon sprites, that allows to load a pokemon in a given animation (such as idle, walk, and so on).
A PokemonSpriteCollection is a collection of these scenes, and is able to handle mulitple instances of these sprites and change the relevant animation
For next times, maybe remove the pokemon scene and do everyyhing in the pokemon spirte collection, so it will be easieri to do everything

## Known Issues
WHen changing pokemon, if the animation is not "Walk", it will give for 3 times an error like ("Animation not found: Idle/DOWN "). Right now i solved this by just putting the default to walk. Maybe some weird change of animations when changing the pokeomn name and then getting to the original value may help, but it's super dirty.
