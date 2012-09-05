echo off

setlocal

set CYGWIN_HOME=C:\ProgramData\cygwin\bin
set PJ_NAME=IssueManager
set SRC_HOME=d:/java_space
set DEST_HOME=d:/tempscm_tools

set RENAME_TARGET_1=src/main/java
set RENAME_TARGET_2=src/test/java

set ORIGIN_PK_NAME=magicware
set NEW_PK_NAME=aaa/bbb/ccc

set ORIGIN_PK_NAME_S=magicware
set NEW_PK_NAME_S=aaa.bbb.ccc

echo "copy source into temp foldor"
rm -rf "%DEST_HOME%/%PJ_NAME%"
cp -rf "%SRC_HOME%/%PJ_NAME%" "%DEST_HOME%/"

echo "clear git stuff"
rm -rf "%DEST_HOME%/%PJ_NAME%/.git"
rm -rf "%DEST_HOME%/%PJ_NAME%/.gitignore"
rm -rf "%DEST_HOME%/%PJ_NAME%/target"
rm -rf "%DEST_HOME%/%PJ_NAME%/private/package_rename.cmd"

echo "make new package foldor"
"%CYGWIN_HOME%/mkdir" -p %DEST_HOME%/%PJ_NAME%/%RENAME_TARGET_1%/%NEW_PK_NAME%
"%CYGWIN_HOME%/mkdir" -p %DEST_HOME%/%PJ_NAME%/%RENAME_TARGET_2%/%NEW_PK_NAME%

echo "copy module into new package"
cp -rf %DEST_HOME%/%PJ_NAME%/%RENAME_TARGET_1%/%ORIGIN_PK_NAME%/* %DEST_HOME%/%PJ_NAME%/%RENAME_TARGET_1%/%NEW_PK_NAME%/
cp -rf %DEST_HOME%/%PJ_NAME%/%RENAME_TARGET_2%/%ORIGIN_PK_NAME%/* %DEST_HOME%/%PJ_NAME%/%RENAME_TARGET_2%/%NEW_PK_NAME%/

echo "remove old package"
rm -rf %DEST_HOME%/%PJ_NAME%/%RENAME_TARGET_1%/%ORIGIN_PK_NAME%
rm -rf %DEST_HOME%/%PJ_NAME%/%RENAME_TARGET_2%/%ORIGIN_PK_NAME%

echo "replace package name in files"
find %DEST_HOME%/%PJ_NAME% \( -name \*.java -o -name \*.xml \) -print0 | xargs -0 sed -i s/%ORIGIN_PK_NAME_S%/%NEW_PK_NAME_S%/g

endlocal
