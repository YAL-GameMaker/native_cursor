@echo off

if not exist "native_cursor-for-GMS1" mkdir "native_cursor-for-GMS1"
cmd /C copyre ..\native_cursor.gmx\extensions\native_cursor.extension.gmx native_cursor-for-GMS1\native_cursor.extension.gmx
cmd /C copyre ..\native_cursor.gmx\extensions\native_cursor native_cursor-for-GMS1\native_cursor
cmd /C copyre ..\native_cursor.gmx\datafiles\native_cursor.html native_cursor-for-GMS1\native_cursor\Assets\datafiles\native_cursor.html
cd native_cursor-for-GMS1
cmd /C 7z a native_cursor-for-GMS1.7z *
move /Y native_cursor-for-GMS1.7z ../native_cursor-for-GMS1.gmez
cd ..

if not exist "native_cursor-for-GMS2\extensions" mkdir "native_cursor-for-GMS2\extensions"
if not exist "native_cursor-for-GMS2\datafiles" mkdir "native_cursor-for-GMS2\datafiles"
if not exist "native_cursor-for-GMS2\datafiles_yy" mkdir "native_cursor-for-GMS2\datafiles_yy"
cmd /C copyre ..\native_cursor_yy\extensions\native_cursor native_cursor-for-GMS2\extensions\native_cursor
cmd /C copyre ..\native_cursor_yy\datafiles\native_cursor.html native_cursor-for-GMS2\datafiles\native_cursor.html
cmd /C copyre ..\native_cursor_yy\datafiles_yy\native_cursor.html.yy native_cursor-for-GMS2\datafiles_yy\native_cursor.html.yy
cd native_cursor-for-GMS2
cmd /C 7z a native_cursor-for-GMS2.zip *
move /Y native_cursor-for-GMS2.zip ../native_cursor-for-GMS2.yymp
cd ..

if not exist "native_cursor-for-GMS2.3+\extensions" mkdir "native_cursor-for-GMS2.3+\extensions"
if not exist "native_cursor-for-GMS2.3+\datafiles" mkdir "native_cursor-for-GMS2.3+\datafiles"
cmd /C copyre ..\native_cursor_23\extensions\native_cursor native_cursor-for-GMS2.3+\extensions\native_cursor
cmd /C copyre ..\native_cursor_23\datafiles\native_cursor.html native_cursor-for-GMS2.3+\datafiles\native_cursor.html
cd native_cursor-for-GMS2.3+
cmd /C 7z a native_cursor-for-GMS2.3+.zip *
move /Y native_cursor-for-GMS2.3+.zip ../native_cursor-for-GM2022+.yymps
cd ..

del /Q native_cursor_demo-for-GM2022+.yyz
cd ..\native_cursor_23
cmd /C 7z a ..\export\native_cursor_demo.zip *
cd ..\export
move /Y native_cursor_demo.zip native_cursor_demo-for-GM2022+.yyz

pause