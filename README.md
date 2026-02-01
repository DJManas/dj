DJ Overlay
==========

For VCMI to work correctly, please enable GURU repository using commands:
```
sudo eselect repository enable guru
sudo emaint sync -r guru
```

It contains package onnxruntime that is needed for VCMI to compile correctly. Because of the things I will be mentioning futher, I will try to maintain only the needed, without need for duplicating other people's work.

BAD news everyone. You might see, that this repo is almost dead. It has been pleasure to give something back to Gentoo community, but my time is limited and I had moved to different [distribution](https://nixos.org/) for my daily use now. But I don't want to abandon this repository completely so I will try to maintain fewer paackages, mostly the ones I have special place in my heart.

Mostly the packages will be related to RetroGaming (VCMI, OpenFodder, TheForceEngine, etc.) and Brave web browser, which has changed a lot in the last half a year and I have to rewrite the ebuild files.

Thanks for understanding.

Good news everyone, I was added between Gentoo repositories, so all you need to do is:
```sh
sudo eselect repository enable djs_overlay
sudo emaint sync -r djs_overlay
```

Some packages which I am using and ebuild didn't existed at that time. Feel free to use it and report bugs.

I must say, that I am still beginner doing these, so the quality will not be any good, but since I am using them it should work.

- **Cinnamon** - I wanted to try new version of Cinnamon so I just coppied all old ebuild with new version, it worked, somehow, but needed some other dependencies. Some are version bumps, others I had to borrow from [pg_overlay](https://github.com/gentoo-mirror/pg_overlay), [Miezhiko](https://github.com/gentoo-mirror/Miezhiko). I hope authors will not get mad (still have to find how this is solved properly, I had added them to be in the same repository, otherwise you would have to add both of them as well but all credits for them are **theirs**, not mine). My changes can make your Gnome unstable so if you want the correct version of Gnome, please go to Miezhiko overlay, add it in into Gentoo by eselect repository and then install Cinnamon from my.

And one more thing I had raised a ticket to be added into eselect repository list, I will add this information how to add me properly using Gentoo's default tools.

## Packages

### acct-group
- **[keyd](https://github.com/rvaiya/keyd)** - Group for keyd daemon,

### app-emulation
- [crossover-bin](https://www.codeweavers.com/products/crossover-linux) - Crossover wine implementation,
- **[dreamm](https://aarongiles.com/dreamm/)** - I like this simple emulator for old Lucas Arts games. For most of them there is [ScummVM](https://scummvm.org/), which is allready in official Gentoo repository, but some games, e.g. Yoda Storries, Indiana Jones storries which are not so good are playable throught this,

### app-office
- **[drawio-bin](https://github.com/jgraph/drawio-desktop)** - Flowchart creation software

### app-misc
- **[keyd](https://github.com/rvaiya/keyd)** - Daemon, which is able to remap keys. I am using it on MacBook to map CMD as CTRL as in Mac OS you use CMD most (as on Linux/Windows CTRL key does). The main reason I like this daemon is, that its system wide so regardless of DE or plain CLI interface, keyboard behaves the same,

### dev-libs
- **fuzzylite** - It seems, that this package is not needed in VCMI compilation, GIT version downloads it, for normal version it needs to be downloaded, but I will keep it here, if someone uses it,
- **[hyprgraphics](https://github.com/hyprwm/hyprgraphics)** - Hyprland graphics / resource utilities,
- **[hyprland-protocols](https://github.com/hyprwm/hyprland-protocols)** - Wayland protocol extensions for Hyprland,
- **[hyprlang](https://github.com/hyprwm/hyprlang)** - Official implementation library for the hypr config language,

### games-engines
- **[OpenFodder](https://github.com/OpenFodder/openfodder)** - Open source port of Cannon Fodder
- **[TheForceEngine](https://github.com/luciusDXL/TheForceEngine)** - The force engine which is able to run [Dark Forces (1995)](https://www.gog.com/en/game/star_wars_dark_forces), and [Outlaws (1997)](https://www.gog.com/en/game/outlaws_a_handful_of_missions). You need original game to use this engine. Also DREAMM is able to run these games, but this is engine recreation, which might have some additional options (e.g. like OpenTTD, I haven't tried it yet)

### games-strategy
  - **[vcmi](https://github.com/vcmi/vcmi)** - HOMAM3 game engine. Well, I made my efford just to find, version 1.6.0 was released, so I deleted patches and copied the same ebuild and it seems to compile and VCMI is not segfaulting

### media-video
- **[bcwc_pcie](https://github.com/wackywendell/bcwc_pcie)** - Prerequisity for Macbook's facetime camera to work,
- **[facetimehd-firmware](https://github.com/patjak/facetimehd)** - Firmware for Macbook's facetime camera to work,

### net-wireless
- **broadcom-wl** - Taken from 4nykey overlay, but had to create patch for 6.12 kernel, seems some includes had changed and it would not compile

### www-client
- **[brave-bin](https://github.com/brave/brave-browser)** - [Brave](https://brave.com/) browser

### x11-libs
- **[pango](https://gitlab.gnome.org/GNOME/pango)** - Dependency for GTK 4.17.3, version bump from Gentoo overlay **IF SYSTEM IS GARBLED, missing fonts / boxes, etc. run: fc-cache -f -v**
