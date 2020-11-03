# audio-scripts

Helper scripts to automatically process DJ sets, and other raw recordings. 

It should **normalize**, **limit**(for more headroom), **trim**(usuall property of recordings) and **encode into mp3**.
It is meant to work like hammer so don't expect shiney sprinkles on top.

Requires:
`ffmpeg`, `grep`, `sed`, `cat` available in the `PATH`.

Usage:
`./normalize_dir.sh "MY_DJ_SETS_DIRECTORY_WITH WAVS" -limiter`

`-limiter` option is optional

