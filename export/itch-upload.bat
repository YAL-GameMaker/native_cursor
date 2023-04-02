@echo off
set /p ver="Version?: "
echo Uploading %ver%...
set user=yellowafterlife
set ext=gamemaker-native-cursors
::cmd /C itchio-butler push native_cursor-for-GMS1.gmez %user%/%ext%:gms1 --userversion=%ver%
::cmd /C itchio-butler push native_cursor-for-GMS2.yymp %user%/%ext%:gms2 --userversion=%ver%
cmd /C itchio-butler push native_cursor-for-GM2022+.yymps %user%/%ext%:gm2022 --userversion=%ver%

pause