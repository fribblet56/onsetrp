# THIS IS OUTDATED/UNMAINTAINED, NO SUPPORT WILL BE DONE, BE CAUTIOUS

# Onset RP Framework

Roleplay framework for the game [Onset](https://store.steampowered.com/app/1105810/Onset/)

## Host Requirements

- Windows / Linux Host
- MariaDB 10.4+ (database on lower version need to be tweaked)

## Packages requirements

- [soundstreamer](https://github.com/Sheaven/SoundStreamer)
- [i18n](https://github.com/OnfireNetwork/i18n)
- [dialogui](https://github.com/OnfireNetwork/dialogui)
- [cinematicui](https://github.com/rdlh/cinematicui)
- [salsi](https://github.com/Onset-RP/salsi)
- [onsetworld](https://github.com/Onset-RP/onsetworld)
- [Magic_Unstuck](https://github.com/fribblet56/Magic_Unstuck_Onset)

## Example packages setup
```
"packages": [
    "soundstreamer",
    "i18n",
    "dialogui",
    "cinematicui",
    "onsetrp",
    "onsetworld",
    "Magic_Unstuck"
]
```

## How To Install OnsetRP

- Create a MariaDB Server if you don't have one. (You can find a tutorial on the Internet)
- Import the .sql file in your database.
- add dependencies in your server_config.json file (keep the right order).
- remove default in your server_config.json file.
- rename misc/s_database.json.dist to misc/s_database.json
- configure misc/s_database.json with your MariaDB credentials
- update your world.json at the root of your project with the sources in the [onsetrp folder](https://github.com/frederic2ec/onsetrp/blob/master/world.json)
- restart your onset server.
