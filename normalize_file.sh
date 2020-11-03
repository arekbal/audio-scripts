#!/bin/bash

INPUT=$1
OUTPUT=$2
USE_LIMITER=$3
 if [ "$USE_LIMITER" == '-limiter' ] ; then
LIMITER=", alimiter=limit=0.93"
else
LIMITER=""
fi
ffmpeg -hide_banner -i "$INPUT" -af volumedetect -f null -y nul &> original.txt
grep "max_volume" original.txt > original.tmp
sed -i 's|: -|=|;s|: 0.0|=0.0|' original.tmp
if [ $? = 0 ] ; then
 sed -i 's| |\r\n|;s| |\r\n|;s| |\r\n|;s| |\r\n|' original.tmp
 grep "max_volume" original.tmp > original2.tmp
 sed -i 's|max_volume=||' original2.tmp
 GAIN_LEVEL=$(cat "./original2.tmp")
 if [ "$GAIN_LEVEL" == "0" ] ; then
    GAIN_LEVEL="0"
 fi
 gain="$GAIN_LEVEL"dB
 echo $gain
fi

rm "$OUTPUT"
# -af "alimiter=limit=0.83,silenceremove=0:0:0:-1:5:-92dB"
ffmpeg -hide_banner -i "$INPUT" -filter_complex "volume=$gain$LIMITER" -metadata comment="" -acodec pcm_f32le  "$INPUT".tmp-limited.wav

ffmpeg -hide_banner -i "$INPUT".tmp-limited.wav -af volumedetect  -f null -y nul &> limitation_phase.txt 

grep "max_volume" limitation_phase.txt > limitation_phase.tmp
sed -i 's|: -|=|;s|: 0.0|=0.0|' limitation_phase.tmp

if [ $? = 0 ] ; then
 sed -i 's| |\r\n|;s| |\r\n|;s| |\r\n|;s| |\r\n|' limitation_phase.tmp
 grep "max_volume" limitation_phase.tmp > limitation_phase2.tmp
 sed -i 's|max_volume=||' limitation_phase2.tmp
 GAIN_LEVEL=$(cat "./limitation_phase2.tmp")
 if [ "$GAIN_LEVEL" == "0" ] ; then
    GAIN_LEVEL="0"
 fi
 gain="$GAIN_LEVEL"dB
 echo $gain
 
 ffmpeg -hide_banner -i "$INPUT".tmp-limited.wav -filter_complex "volume=$gain, silenceremove=0:0:0:-1:5:-85dB" -metadata comment="" -codec:a libmp3lame -b:a 320k "$OUTPUT" 
 
 rm "$INPUT".tmp-limited.wav
 
 ffmpeg -hide_banner -i "$OUTPUT" -af volumedetect  -f null -y nul &> result.txt
fi
