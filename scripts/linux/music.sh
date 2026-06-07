#!/bin/bash

for f in ~/Music/*.{mp4,mkv,avi,mov,webm,flv}; do
  [[ -f "$f" ]] && ffplay -nodisp -autoexit -loglevel quiet "$f"
done &
