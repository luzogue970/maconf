#!/bin/bash

current=$(setxkbmap -query | grep layout | awk '{print $2}')

if [ "$current" = "fr" ]; then
    setxkbmap us
else
    setxkbmap fr
fi
