DIR=$1
USE_LIMITER=$2 # got to be '-limiter' if used. "normalize_file.sh" expects it
OUTPUT_DIR="$DIR"/processed

DIR_LENGTH=${#DIR}

mkdir "$OUTPUT_DIR"

for entry in "$DIR"/*.wav
do
  ENTRY_LENGTH=${#entry}
  ENTRY_LENGTH=$(expr $ENTRY_LENGTH - $DIR_LENGTH - 4)
  echo "$entry" 
  echo "$OUTPUT_DIR${entry:$DIR_LENGTH:$ENTRY_LENGTH}.mp3"  
  . ./normalize_file.sh "$entry" "$OUTPUT_DIR${entry:$DIR_LENGTH:$ENTRY_LENGTH}.mp3" $USE_LIMITER
done

$SHELL