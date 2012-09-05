@echo off
setlocal

rem -----------------------------------------------
rem   環境変数の遅延展開が必要です。
rem   実行するときは、次のように入力してください
rem     "cmd /v:on /c コマンド名"
rem -----------------------------------------------

set GNUWIN32=c:\progra~1\gnuwin32
set APACHE_HOME=c:\Program Files\Apache Software Foundation\Apache2.2
set LOG_DIR=%APACHE_HOME%\logs
set ARCHIVE_DIR=%APACHE_HOME%\logs\archive
set ARCHIVE_FILE_NAME=apache_logs.tar
set DRIVER_MARK=c:
set APACHE_SERVICE_NAME=Apache2.2

set NUM_FILES=6
set COUNT=0
set INDEX=6

rem --------------------------
rem  stop apache service
rem --------------------------
net stop "%APACHE_SERVICE_NAME%"

rem --------------------------
rem  archive log files
rem --------------------------
rem change location to correct driver disk
%DRIVER_MARK%
cd "%LOG_DIR%"
"%GNUWIN32%\bin\tar" cvf %ARCHIVE_FILE_NAME% *.log -C "%LOG_DIR%"
"%GNUWIN32%\bin\gzip" -9 -f "%LOG_DIR%\%ARCHIVE_FILE_NAME%"
mkdir "%ARCHIVE_DIR%"
move "%LOG_DIR%\%ARCHIVE_FILE_NAME%.gz" "%ARCHIVE_DIR%\"
if errorlevel 1 (
    echo tar command aborted due to failure, errorlevel=%ERRORLEVEL% 1>&2
    exit /b 1
)

rem --------------------------
rem  remove log files
rem --------------------------
del "%LOG_DIR%\*.log"

rem --------------------------
rem  remove old files
rem --------------------------
for /F %%t in ('dir /o:-d /a:-d /b "%ARCHIVE_DIR%\%ARCHIVE_FILE_NAME%*.gz"') do (
   if !COUNT! GEQ %NUM_FILES% del /f "%ARCHIVE_DIR%\%%t"
   set /A COUNT=!COUNT!+1
)

for /L %%t in (5,-1,1) do (
   set /A INDEX=%%t + 1
   if exist "%ARCHIVE_DIR%\%ARCHIVE_FILE_NAME%.%%t.gz" ren "%ARCHIVE_DIR%\%ARCHIVE_FILE_NAME%.%%t.gz" "%ARCHIVE_FILE_NAME%.!INDEX!.gz"
)

if exist "%ARCHIVE_DIR%\%ARCHIVE_FILE_NAME%.gz" ren "%ARCHIVE_DIR%\%ARCHIVE_FILE_NAME%.gz" "%ARCHIVE_FILE_NAME%.1.gz"

rem --------------------------
rem  start apache service
rem --------------------------
net start "%APACHE_SERVICE_NAME%"

endlocal
