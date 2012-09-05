@echo off
for /f "usebackq tokens=*" %%a in (`cygpath --dos "%APPDATA%"`) do @set NEW_HOME=%%a
for /f "usebackq tokens=*" %%a in (`cygpath "%NEW_HOME%"`) do @set NEW_HOME=%%a
echo %NEW_HOME%
sh.exe -c "export HOME='%NEW_HOME%';mewest %*"
