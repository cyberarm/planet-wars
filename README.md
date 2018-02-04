[![Dependency Status](https://gemnasium.com/cyberarm/planet-wars.svg)](https://gemnasium.com/cyberarm/planet-wars) [![Code Climate](https://codeclimate.com/github/cyberarm/planet-wars/badges/gpa.svg)](https://codeclimate.com/github/cyberarm/planet-wars) [![Stories in Ready](https://badge.waffle.io/cyberarm/planet-wars.png?label=ready&title=Ready)](https://waffle.io/cyberarm/planet-wars)
# Planet Wars
A space shooter-like game

## How to install:
(Assuming you have Ruby 2.3.0+ and Bundler installed)

* First, clone or download this repository (and extract the archive)
* Second, enter the downloaded folder, and run `bundle install` to install the games dependencies semi-automatically
* Third, run `ruby planet-wars.rb`
You should now be playing the game, enjoy.

Or, if you have Windows, you can download a fairly recent build of the game  from [here](https://drive.google.com/folderview?id=0B3Q9pldFQoK4NVByUzlHaGRGc3M&usp=sharing).

## Game Play
After selecting your choice of difficultly, your ship is placed in the middle of hostile point in space where enemies constantly spawn.

You can visit planets by pressing enter when on top of a planet, while visiting a planet you can build a base.
Bases act as mines, collecting available resources on the planet, bases also act as a repair station, allowing your ship to be repaired.

See how long you can survive.

## Controls
Note: Controller controls assume an Xbox compatible controller.
### Movement
* `W`, `Up` or `Right Bumper` **Forwards/Brake**
* `S`, `Down`, or `Left Bumper` **Reverse/Brake**
* `A`, `Left`, `Left D-Pad button`, or `Left Stick -X` **Turn Left**
* `D`, `Right`, `Right D-Pad button`, or `Left Stick +X` **Turn Right**

### Weapon
* `Spacebar` or `A Button` **Fire bullet**

### Other
* `U` or `Y Button` **Open Ship upgrades menu**
* `Enter` or `X Button` **Open planet management menu if over top a planet**
* `F1` or `Left Stick Button` **Pause game and show controls**
* `P` or `Start Button` **Pause game**
* `Escape` or `Back Button` **Quit confirmation**

## Commandline Arguments
* `--mute` Starts the game with music paused (can be resumed from the settings menu or by pressing 'm')
* `--debug` Shows debugging information, e.g. collision radius visualization
* `--debug_game` Jumps the game straight to the `Game` game state
* `--quick` Skips intro and jumps to `MainMenu`
* `--no-shadow` Disables text shadow/highlighting
* `--low` Sets the update_interval to 30 frames per second

Note: using `--debug_game` with also trigger `--debug` due to laziness. `ARGV.join.include?(string)`

## Special Keys
In-Game:
* `X` or `Right Stick Button` Toggles debug mode on or off; Only available with `--debug` option
* `C` Prints out data for debugging waves; Only available with `--debug` option
* `V` Runs Planet-to-Planet collision check, used internally to remove overlapping planets; Only available with `--debug` option
* `M` Toggles mute on or off. If sound and/or music is disabled in the menu this will do nothing. Affects `--mute`

## Road map
* Online high scores - Time survived
* Multiplayer - Death match with up to 4 players
* Multiplayer - Co-op with up to 4 players

## Asset Copyright
* All Sprites - Cyberarm - (CC) Attribution-ShareAlike 3.0 Unported License

* All Music - Alexandr Zhelanov - (CC) Attribution 3.0 Unported License


* Font: Alfphabet IV - Pierre Huyghebaert and Ludivine Loiseau - SIL Open Font License
* Font: Hobby Of Night - Fernando Haro - SIL Open Font License


* Sound: Achievement Unlocked - Kastenfrosch* - (CC) Zero
* Sound: Explosion - PSYCHO BOOMER* - (CC) Zero
* Sound: Hit - Keatonmcq* - (CC) Zero
* Sound: Laser - fins* - (CC) Zero

(* FreeSound username)
