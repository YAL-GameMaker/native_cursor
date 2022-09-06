@echo off
set dllPath=%~1
set solutionDir=%~2
set projectDir=%~3
set arch=%~4
set config=%~5

echo Running post-build for %config%

set extName=native_cursor
set dllName=native_cursor
set gmlDir14=%solutionDir%native_cursor.gmx
set gmlDir22=%solutionDir%native_cursor_yy
set gmlDir23=%solutionDir%native_cursor_23
set ext14=%gmlDir14%\extensions\%extName%
set ext22=%gmlDir22%\extensions\%extName%
set ext23=%gmlDir23%\extensions\%extName%
set dllRel=%dllName%.dll
set cppRel=%dllName%.cpp
set cppPath=%ext23%\%cppRel%
set gmlPath=%ext23%\*.gml
set docName=%extName%.html
set docPath=%solutionDir%export\%docName%

set extNameComp=native_cursor_v1_compat
set ext14Comp=%gmlDir14%\extensions\%extNameComp%
set ext22Comp=%gmlDir22%\extensions\%extNameComp%
set ext23Comp=%gmlDir23%\extensions\%extNameComp%
set gmlPathComp=%ext23Comp%\*.gml

echo Copying documentation...
copy /Y %docPath% %gmlDir23%\datafiles\%docName%
copy /Y %docPath% %gmlDir22%\datafiles\%docName%
copy /Y %docPath% %gmlDir14%\datafiles\%docName%

where /q gmxgen
if %ERRORLEVEL% EQU 0 (
	
	echo Combining the source files...
	type "%projectDir%*.h" "%projectDir%*.cpp" >"%cppPath%" 2>nul
	
	echo Running GmxGen...
	
	gmxgen "%ext23%\%extName%.yy" ^
	--copy "%dllPath%" "%dllRel%:%arch%"

	gmxgen "%ext22%\%extName%.yy" ^
	--copy "%dllPath%" "%dllRel%:%arch%" ^
	--copy "%cppPath%" "%cppRel%" ^
	--copy "%gmlPath%" "*.gml"
	
	gmxgen "%ext14%.extension.gmx" ^
	--copy "%dllPath%" "%dllRel%:%arch%" ^
	--copy "%cppPath%" "%cppRel%" ^
	--copy "%gmlPath%" "*.gml"

	:: comp
	gmxgen "%ext23Comp%\%extNameComp%.yy"
	gmxgen "%ext22Comp%\%extNameComp%.yy" --copy "%gmlPathComp%" "*.gml"
	gmxgen "%ext14Comp%.extension.gmx" --copy "%gmlPathComp%" "*.gml"

) else (

	echo Copying DLLs...
	if "%arch%" EQU "x64" (
		copy /Y "%dllPath%" "%ext23%\%dllName%_x64.dll"
	) else (
		copy /Y "%dllPath%" "%ext22%\%dllRel%"
		copy /Y "%dllPath%" "%ext23%\%dllRel%"
		copy /Y "%dllPath%" "%ext14%\%dllRel%"
	)
	
	echo Copying GML files...
	robocopy %ext23% %ext22% *.gml /L >nul
	robocopy %ext23% %ext14% *.gml /L >nul

	echo postBuild.bat: Warning N/A: Could not find GmxGen - extensions will not be updated automatically. See https://github.com/YAL-GameMaker-Tools/GmxGen for setup.
)