@ECHO OFF

ECHO This script will release a new version of the firmware, e.g. 1.0.0
SET /P new_version=Please enter the new version number: %=%

SET home_dir=%~dp0
SET release_folder=releases\%new_version%

IF NOT EXIST %release_folder% (
	MKDIR %release_folder%

	:: Throttle version
    CD src\controller
    CALL compile.bat THROTTLE=1 || GOTO :error
	CD %home_dir%
	COPY .\src\controller\main.ihx %release_folder%\TSDZ2-throttle-v%new_version%.hex
    
	:: Non throttle version
	CD src\controller
	CALL compile.bat THROTTLE=0 || GOTO :error	
	CD %home_dir%
	COPY .\src\controller\main.ihx %release_folder%\TSDZ2-v%new_version%.hex

    CD src\display\KT-LCD3
    CALL compile.bat || GOTO :error
    CD %home_dir%
    COPY .\src\display\KT-LCD3\main.ihx %release_folder%\KT-LCD3-v%new_version%.hex

    ECHO:
    ECHO Release %new_version% has been created in %home_dir%%release_folder%
    ECHO:

    GOTO :EOF
) ELSE (
    ECHO:
    ECHO Release %new_version% already exists!
    ECHO:
)

:error
ECHO:
ECHO Failed with error code %errorlevel%.
ECHO:
EXIT /b %errorlevel%

@ECHO ON
