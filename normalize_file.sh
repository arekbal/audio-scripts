#!/bin/bash

INPUT=$1
OUTPUT=$2
USE_LIMITER=$3
 if [ "$USE_LIMITER" == '-limiter' ] ; then
LIMITER="-af alimiter=limit=0.83"
else
LIMITER=""
fi
ffmpeg -i "$INPUT" -af volumedetect -f null -y nul &> original.txt
grep "max_volume" original.txt > original.tmp
sed -i 's|: -|=|' original.tmp
if [ $? = 0 ]
 then
 sed -i 's| |\r\n|' original.tmp
 sed -i 's| |\r\n|' original.tmp
 sed -i 's| |\r\n|' original.tmp
 sed -i 's| |\r\n|' original.tmp
 grep "max_volume" original.tmp > original2.tmp
 sed -i 's|max_volume=||' original2.tmp
 GAIN_LEVEL=$(cat "./original2.tmp")
 if [ "$GAIN_LEVEL" == "0" ] ; then
    GAIN_LEVEL="0"
 fi
 gain="$GAIN_LEVEL"dB
 rm "$OUTPUT"
 ffmpeg -i "$INPUT" -af "volume=$gain" $LIMITER -af silenceremove=0:0:0:-1:5:-92dB -metadata comment="" -codec:a libmp3lame -b:a 320k "$OUTPUT"
 
 ffmpeg -i "$OUTPUT" -af volumedetect -f null -y nul &> result.txt
fi
