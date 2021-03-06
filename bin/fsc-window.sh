#!/bin/sh

####################################
# 奇数を偶数に変換する処理
####################################
function even_round {
    if [ `expr $1 % 2` == 0 ]; then
        echo $1
    else
        echo $(($1 - 1))
    fi
}

if [ $# -eq 1 ]; then
    echo "録画対象Windowをカーソルで選択してください。"
    VFILE=$1
    INFO=$(xwininfo -frame)
else
    VFILE=$1
    INFO=$(xwininfo -id $2 -all | grep -oEe "Parent window id: [0-9|a-z]+" | cut -d " " -f 4 | xargs xwininfo -id)
fi

WIN_GEO=$(echo $INFO | grep -oEe 'geometry [0-9]+x[0-9]+' | grep -oEe '[0-9]+x[0-9]+')
WIN_XY=$(echo $INFO | grep -oEe 'Corners:\s+\+[0-9]+\+[0-9]+' | grep -oEe '[0-9]+\+[0-9]+' | sed -e 's/\+/,/' )

# Windowsの横サイズと縦サイズを偶数にする
WIN_GEO_X=$(echo $WIN_GEO | cut -d 'x' -f 1)
WIN_GEO_Y=$(echo $WIN_GEO | cut -d 'x' -f 2)

WIN_GEO="$(even_round $WIN_GEO_X)x$(even_round $WIN_GEO_Y)"

echo "画面サイズ：$WIN_GEO"
echo "画面位置  ：$WIN_XY"

# 録画開始
ffmpeg -show_region 1 -f x11grab -framerate 25 -video_size $WIN_GEO -i :0.0+$WIN_XY \
       -dcodec copy -pix_fmt yuv420p -c:v libx264 -preset veryfast -qscale 1 -y $VFILE
