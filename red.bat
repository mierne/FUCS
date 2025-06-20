@echo off  && setlocal enabledelayedexpansion
title Free Utility for Cloning Saves

set script_path=%~dp0
set backup_folder=%script_path%
set overwrite_toggle=0
set robocopy_options=/e /tee /log:robocopy.log
set settings_path=%USERPROFILE%\AppData\Local\FUCS
set masterlist_path=%settings_path%\masterlist.txt
set open_when_finished=0

:initialize
if exist "%settings_path%" (
    if exist "%settings_path%\settings.txt" (
        (
            set /p backup_folder=
            set /p overwrite_toggle=
            set /p robocopy_options=
            set /p open_when_finished=
        )<"%settings_path%\settings.txt"
        goto :main
    ) else (
        goto :setup
    )
) else (
    mkdir "%settings_path%"
    goto :setup
)

:setup
cls
echo.
echo Free Utility for Cloning Saves requires a folder to store data.
echo You may set one now:
set /p backup_folder="> "
echo Is this correct?: %backup_folder%
set /p ch="Y/N "
if /i "%ch%" == "Y" goto :save_data
if /i "%ch%" == "N" goto :setup
goto :setup

:save_data
(
echo %backup_folder%
echo %overwrite_toggle%
echo %robocopy_options%
echo %open_when_finished%
)>"%settings_path%\settings.txt"
goto :main

:main
cls
echo.
echo [1 / ADD ENTRIES TO MASTERLIST ]
echo [2 / REMOVE ENTRIES FROM MASTERLIST]
echo [3 / VIEW MASTERLIST ]
echo [E / PERFORM BACKUP ]
echo [S / SETTINGS ]
echo [Q / QUIT ]
set /p ch="> "
if /i "%ch%" == "1" goto :masterlist_add_entry
if /i "%ch%" == "2" goto :masterlist_remove_entry
if /i "%ch%" == "3" goto :masterlist_view
if /i "%ch%" == "E" goto :backup_masterlist_check
if /i "%ch%" == "S" goto :change_settings
if /i "%ch%" == "Q" goto :eof
goto :main

:backup_masterlist_check
if exist "%masterlist_path%" (
    set masterlist_size=0
    for %%a in ("%masterlist_path%") do if %%~za equ 0 (
        echo Warning: The masterlist.txt file contains no entries.
        pause & goto :main
    ) else (
        goto :backup_begin
    )
) else (
    echo Warning: FUCS could not find the masterlist file.
    echo Attempting to add an entry should create the file if it does not exist.
    pause & goto :main
)

:backup_begin
rem This is still broken and I'm still tinkering.
rem Whichever entry in masterlist.txt is last will overwrite any previous created folders.
for /f "tokens=*" %%i in (%masterlist_path%) do (
    for /f "tokens=*" %%g in (%masterlist_path%) do set src=%%g && (
        if exist "%backup_folder%\%date%\%%~nxi" (
            echo this already exists
            pause
        ) else (
            rem do nothing..?
        )
    )
    echo %%g
    robocopy %src% %backup_folder%\%date%\%%~nxi /MIR
)
rem original method - does not create individual folders
rem for /f "tokens=*" %%g in (%masterlist_path%) do robocopy %%g %backup_folder%\%date% %robocopy_options%
echo Robocopy has finished the operation. Read robocopy.log for more details.
pause & goto :main

:masterlist_add_entry
cls
echo.
echo Specify the path to the folder you wish to backup.
set /p ch="Path to folder: "
echo %ch% >> "%masterlist_path%"
echo %ch% has been added to the masterlist.
pause & goto :main

:masterlist_remove_entry
cls
echo.
echo Specify the path to the folder you wish to remove from the masterlist.
SET /P ch="Path to the folder: "
echo %ch% has been removed from the masterlist.
type %masterlist_path% | findstr /v "%ch%" >"%settings_path%\~temp.txt"
del %masterlist_path% && ren "%settings_path%\~temp.txt" masterlist.txt
goto :main

:masterlist_view
cls
echo Current masterlist entries:
echo.
for /f "tokens=*" %%g in (%masterlist_path%) do echo %%g
echo [Q / QUIT ]
set /p ch="> "
if /i "%ch%" == "Q" goto :main

:change_settings
cls
echo.
echo Change or view settings.
echo.
echo Backup Folder: %backup_folder%
echo Open When Finished?: %open_when_finished% ^| 1=True 0=False
echo Overwrite Toggle: %overwrite_toggle% ^| 1=True 0=False
echo [1 / TOGGLE OVERWRITE SWITCH ]
echo [2 / CHANGE BACKUP FOLDER ]
echo [3 / TOGGLE OPEN WHEN FINISHED ]
echo [Q / QUIT ]
set /p ch="> "
if /i "%ch%" == "1" goto :toggle_overwrite_switch
if /i "%ch%" == "2" goto :backup_folder_change
if /i "%ch%" == "3" goto :toggle_open_when_finished
if /i "%ch%" == "Q" goto :main
goto :change_settings

:toggle_overwrite_switch
if %overwrite_toggle% equ 0 (
    set robocopy_options=/e /is /it /tee /log:robocopy.log
    set overwrite_toggle=1
    goto :save_data
) else (
    set robocopy_options=/e /tee /log:robocopy.log
    set overwrite_toggle=0
    goto :save_data
)

:backup_folder_change
cls
echo.
echo Enter the path to a new folder to store backups:
set /p backup_folder="> "
echo Is this correct?: %backup_folder%
set /p ch="Y/N "
if /i "%ch%" == "Y" goto :save_data
if /i "%ch%" == "N" goto :main
GOTO :SETTINGS

:toggle_open_when_finished
if %open_when_finished% equ 1 (
    set open_when_finished=0
    goto :save_data
) else (
    set open_when_finished=1
    goto :save_data
)