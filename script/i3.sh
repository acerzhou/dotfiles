#!/bin/zsh


# reference - https://bbs.archlinux.org/viewtopic.php?id=251552 

function show_monitor(){
    xrandr --listmonitors
}

function disable_home_screen(){
    xrandr --output eDP-1 --off
}

function reset_screen() {
    xrandr --auto
}
