# Pokesouls

## Repo Setup
In order to setup the repository you should run
```
./setup.sh
```

## Known issues

- [x] For some pokemon, different animations are centered in different way, therefore when, from example, changing from idle to walk there is a weird vertical or horizontal instant translation. With venusaur/bulbasaur this doesnt happen, while with charmander or blastoise it does. SOLVED: setter are a bitch with tools, i just was returning if some sprites where null before init

