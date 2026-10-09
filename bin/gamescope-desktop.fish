#!/usr/bin/fish

set screenjs $(kscreen-doctor -j)
set SCREEN_ID $(echo $screenjs | jq ".screen.id")
set NAME $(echo $screenjs | jq ".outputs.[$SCREEN_ID].name" | string replace --all '"' '')
set CSCALE $(echo $screenjs | jq ".outputs.[$SCREEN_ID].scale")
set CWIDTH $(echo $screenjs | jq ".outputs.[$SCREEN_ID].size.width")
set CHEIGHT $(echo $screenjs | jq ".outputs.[$SCREEN_ID].size.height")
set CREFRESH 60
# set SCREEN_WIDTH $(kscreen-doctor -j | jq ".outputs.[$SCREEN_ID].size | .width,.height")

set SCALE $CSCALE
set WIDTH $CWIDTH
set HEIGHT $CHEIGHT
set REFRESH $CREFRESH

set CKSCREENDRLINE $(printf "kscreen-doctor output.%s.mode.%sx%s@%s output.%s.scale.%s\n" $NAME $WIDTH $HEIGHT $REFRESH $NAME $SCALE)
echo $CKSCREENDRLINE

# TODO set desired mode based on the game:

set SCALE $CSCALE
set WIDTH $CWIDTH
set HEIGHT $CHEIGHT
set REFRESH $CREFRESH

set KSCREENDRLINE $(printf "kscreen-doctor output.%s.mode.%sx%s@%s output.%s.scale.%s\n" $NAME $WIDTH $HEIGHT $REFRESH $NAME $SCALE)

# TODO if CKSCREENDRLINE != KSCREENDRLINE then run KSCREENDRLINE to change modes

# Setting mode and scale
# kscreen-doctor output.eDP-1.mode.1920x1200@60 output.eDP-1.scale.1.5
# kscreen-doctor output.eDP-1.mode.2560x1600@60 output.eDP-1.scale.2

printf "-W %s -H %s\n" $SCREEN_WIDTH $SCREEN_HEIGHT
