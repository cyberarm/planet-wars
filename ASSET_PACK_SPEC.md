# Planet Wars
## Asset Pack Specification
### Directory Structure
``` text
  root: /assets/#{asset_pack_name}/
  /root/asteroids
  /root/backgrounds (deprecated, unused)
  /root/bullets
  /root/data
  /root/fonts
  /root/music
  /root/particles
  /root/planets
              /habitable
              /uninhabitable
  /root/portal
  /root/ships
  /root/sounds
```

### Assets
* All sprites are expected to be PNGs
* All music and sounds should be transcoded to OGG for cross platform compatibility
#### Asteroids
* Must contain an image, name doesn't matter
* If multiple images are present a random one will be selected
* Asteroids should be circular in nature
* Size: 512x512 pixels
#### Backgrounds (deprecated, unused)
* Backgrounds should be rectangular
* Size: 1920x1080 pixels or 3000x3000 pixels
#### Bullets
* Must contain an image called `bullet.png`
* Asteroids should be circular in nature
* Size: 16x16 pixels
#### Data
* Here your credits.yml and theme.yml live.
*see setting your theme and using credits*
#### Enemies
* Must contain an image called `enemy.png`
* Enemies should be circular in nature
* Size: 128x128 pixels
#### Fonts
* Fonts should be TrueType for cross platform compatibility
#### Music
* Music should be in OGG format for cross platform compatibility
#### Particles
* Size: 15x15 pixels or 16x16 pixels
#### Planets
* Must contain at least two images, one in `/habitable` and one in `/uninhabitable`, name doesn't matter
* A random image will be choosen for the planet's type
* Planets should be circular in nature
* Size: 512x512 pixels
#### Portal
* Must contain an image called `portal.png`
* Portal should be circular in nature
* Size: 512x512 pixels
#### Ships
* Must contain an image called `ship.png`
* Size: 128x128 pixels
#### Sounds
* Music should be in OGG format for cross platform compatibility
* *See Sounds below for required sounds*

### Theme
* A `theme.yml` file is required in the `/data` folder

#### Sample Theme
``` yaml
---
text: {
  font: "Alfphabet-IV.ttf",         # Default font for text
  font_size: 13,                    # Default font size
  color: "white"                    # Default font color
  }

hud: {
  health_bar: {
    full: "lime",                   #Full health color
    half: "yellow",                 # Half health color
    low: "red"                      # Low health color
    },
  boost_bar: "blue",                # Boost color
  minimap: {
    background: "#222",             # Minimap background color
    planet_habitable: "blue",       # Minimap habitable planet color
    planet_uninhabitable: "yellow", # Minimap uninhabitable planet color
    planet_based: "cyan",           # Minimap planet with base color
    ship: "lime",                   # Minimap player ship color
    enemy: "red",                   # Minimap enemy ship color
    asteroid: "white"               # Minimap asteroid color
    },
  planets: {
    habitable: "white",             # Planet label habitable color
    unhabitable: "orange",          # Planet label uninhabitable color
    base: "lime"                    # Planet label base color
    }
  }

gameui: {
  font: "Alfphabet-IV.ttf",         # GameUI default font
  font_size: 32,                    # GameUI default font size
  tooltip_font_size: 20,            # GameUI default tooltip font size
  title_font_size: 36,              # GameUI default title font size
  color: "white",                   # GameUI default font color
  tooltip_color: "white",           # GameUI tooltip color
  title_color: "white",             # GameUI title color
  background: "black",              # GameUI background color
  button: {
    background: "#005ab3",          # GameUI button background color
    active_background: "#0080ff"    # GameUI button active background color
    }
  }
```

### Credits
* A `credits.yml` file is required in the `/data` folder

#### Sample credits
``` yaml
---
credits:
  people: [
    {name: name_of_person, job: job_title}
  ]

  sprites: [
    {sprite: name_of_sprite, name: sprite_artist, license: sprite_license}
  ]

  music: [
    {name: name_of_song, composer: name__of_composer, license: license_of_song}
  ]

  fonts: [
    {font: name_of_font, license: license_of_font}
  ]

  libraries: [
  ]
```

### Sounds
#### achievement_unlocked.ogg
* Used when an achievement is unlocked.
* Required
* Should be short, less than 1 second.
#### explosion.ogg
* Used when a Ship, Enemy, or Asteroid dies.
* Required
* Should be short, less than 2 second.
#### hit.ogg
* Used when a Bullet hits something.
* Required
* Should be short, less than 1 second.
#### incoming_asteroids.ogg
* Used when a Asteroids spawn.
* Required
* Should be short, less than 3 second.
#### laser.ogg
* Used when a Bullet is created.
* Required
* Should be short, less than 1 second.
#### ui/action.ogg
* Used when a menu item is activated.
* Required
* Should be short, less than 1 second.
#### ui/error.ogg
* Used when when something can't be done.
* Required
* Should be short, less than 1 second.
