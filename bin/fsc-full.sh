#!/bin/sh

WIN_GEO=$(xwininfo -root | grep 'geometry' | awk '{print $2;}' | cut -d '+' -f 1)

# 録画開始
ffmpeg -show_region 1 -f x11grab -framerate 25 -video_size $WIN_GEO -i :0.0 -dcodec copy -pix_fmt yuv420p -c:v libx264 -preset veryfast -qscale 1 -y $1
