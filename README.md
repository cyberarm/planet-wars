# Planet Wars
A space shooter-like game

## How to install:
(Assuming you have Ruby 1.9.3 and Bundler installed)

* First, clone or download this repository (and extract the archive)
* Second, enter the downloaded folder, and run `bundle install` to install the games dependacies semi-automatically
* Third, run `ruby planet-wars.rb`
You should now be playing the game, enjoy.

## Gameplay
After selecting your choice of difficultly, your ship is placed in the middle of hostile point in space where enemies constantly spawn.

You can visit planets by pressing enter when on top of a planet, while visiting a planet you can build a base.
Bases act as mines, collecting available resources on the planet, bases also act as a repair station, allowing your ship to be repaired.

After running out of resources its only a matter of time before your overwelled.

See how long you can survive.

## Commandline Arguments
* `--low` runs the game at 3/4 the size of the screen
* `--mute` starts the game with music paused (can be resumed from the settings menu or by pressing 'm')
* `--debug` jumps the game straight to the `Game` game state

## Road map
* Online high scores - Time survived
* Multiplayer - Death match with up to 4 players
* Multiplayer - Co-op with up to 4 players
