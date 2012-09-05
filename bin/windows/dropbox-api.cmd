@echo off
setlocal
set DROPBOX_CONF=D:\ProgramData\toolkit\dropbox-api-command\.dropbox-api-config
perl D:\ProgramData\toolkit\dropbox-api-command\dropbox-api %*
endlocal
