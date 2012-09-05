@echo off
echo %* | xargs aunpack

rem sed でパスの書換えを行う処理
rem echo %1 | sed -e "s/\://" | sed -e "s/^/\/cygdrive\//" | xargs aunpack

