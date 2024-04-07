@Echo Off
Title RandomFilePicker - v1.4.1


::####  CONFIG SECTION  ####

::CAN MANUALLY SET DIRECTORY HERE- Comment the other and vice versa
::Set directory="C:\Users\echox\OneDrive\Pictures\All_Wallpapers"
mkdir "%~dp0" > NUL 2>&1
::KEY BINDS - Edit these lists to your liking

set bind_delete=d del delete
set bind_review=v review
set bind_reload=r reload
set bind_randomizer=

::SET YOUR PREFERRED COLOR - List is on the documentation file on home page.
set color_code= 3

::This determines how many times you want the Randomizer to shuffle. Default = 250
Set timeout_max=250

::SET YOUR SEARCH CRITERIA
set search_mode=1
::1 = Images
::2 = Videos
::3 = Music
::4 = Images, Videos, Music
::5 = Every possible file type (CAUTION: Will literally open anything)


::Image file types
set file_type1.1=.png
set file_type1.2=.jpg
set file_type1.3=.jpeg
set file_type1.4=.webp
::Video file types
set file_type2.1=.mp4
set file_type2.2=.mkv
set file_type2.3=.mov
set file_type2.4=.webm
::Music file types
set file_type3.1=.mp3
set file_type3.2=.m4a
set file_type3.3=.wav
set file_type3.4=.wma
::####  END OF CONFIG  ####



::Titles
Echo.
Echo RandomFilePicker - v1.4.1
Echo.
Echo -github/bandito52
Echo.
Goto Start

::Step 1
:Start
Color %color_code%
Echo.
Echo (Step 1/4) - Directory set.
Set count=0
Set timeout=0
Echo.

::Step 2
Echo (Step 2/4) - Checking Directory... Please wait a moment.
For /f %%f in ('dir "%directory%" /b /s') do set /a count+=1

::Step 3
:Randomizer
Color %color_code%
CLS
Echo.
Echo (Step 3/4) - Randomizer shuffling... Please wait a moment.
echo %timeout% | findstr %timeout_max% >nul && (goto Error-TimedOut) || (echo Attempt %timeout%/%timeout_max% till Timeout...)
::timeout /t 1 > nul
Set /a timeout+=1
Set /a randN=%random% %% %count% +1
Set listN=0
For /f "tokens=1* delims=:" %%I in ('dir "%directory%" /b /s^| findstr /n /r . ^| findstr /b "%randN%"') do set filename=%%J
:check1
echo %search_mode% | findstr "1" >nul && (goto Search_Mode1) || (goto check2)
:check2
echo %search_mode% | findstr "2" >nul && (goto Search_Mode2) || (goto check3)
:check3
echo %search_mode% | findstr "3" >nul && (goto Search_Mode3) || (goto check4)
:check4
echo %search_mode% | findstr "4" >nul && (goto Search_Mode4) || (goto check5)
:check5
echo %search_mode% | findstr "5" >nul && (goto Search_Mode5) || (goto Error-IncorrectNum)


:Search_Mode1
echo %filename% | findstr /i /c:%file_type1.1% /c:%file_type1.2% /c:%file_type1.3% /c:%file_type1.4% >nul && (goto Review) || (goto Randomizer)
:Search_Mode2
echo %filename% | findstr /i /c:%file_type2.1% /c:%file_type2.2% /c:%file_type2.3% /c:%file_type2.4% >nul && (goto Review) || (goto Randomizer)
:Search_Mode3
echo %filename% | findstr /i /c:%file_type3.1% /c:%file_type3.2% /c:%file_type3.3% /c:%file_type3.4% >nul && (goto Review) || (goto Randomizer)
:Search_Mode4
echo %filename% | findstr /i /c:%file_type1.1% /c:%file_type1.2% /c:%file_type1.3% /c:%file_type1.4% /c:%file_type2.1% /c:%file_type2.2% /c:%file_type2.3% /c:%file_type2.4% /c:%file_type3.1% /c:%file_type3.2% /c:%file_type3.3% /c:%file_type3.4% >nul && (goto Review) || (goto Randomizer)
:Search_Mode5
goto Review

::Step 4
:Review
For /f %%A in ("%filename%") do set filesize=%%~zA
CLS
Start "" "%filename%"
Echo (Step 4/4) - File selected and presented.

::Info Pane
Echo.
Echo Location: %filename%
Echo.

::Choices
Echo How do you want to continue? Deletion is FINAL and PERMANENT.
Echo.
Echo OPTIONS:
Echo.
Echo %bind_randomizer% = Reroll for new file.
Echo %bind_delete% = Permanently delete.
Echo %bind_reload% = Update directory if you added new files.
Echo %bind_review% = Open file again.
Echo.
Set timeout=0
Set choice=
Set /p choice= Choice:
echo %bind_randomizer% | find /i "%choice%" >nul && goto Randomizer
echo %bind_delete% | find /i "%choice%" >nul && goto Deletion
echo %bind_reload% | find /i "%choice%" >nul && goto Start
echo %bind_review% | find /i "%choice%" >nul && goto Review
goto Randomizer

:Deletion
del "%filename%" | CLS
Color c
Echo.
Echo File permanently deleted.
Echo.
Pause
Goto Randomizer


::Error Codes

:Error-IncorrectNum
CLS
Color C
echo ###  ERROR  ###
echo    Code: 400
echo.
echo Search Criteria is not Mode 1-5. CHECK CONFIG.
echo.
echo Program will close upon continuing
Pause
exit

:Error-TimedOut
CLS
Color C
echo ###  ERROR  ###
echo    Code: 404
echo.
echo Randomizer has timed out after %timeout_max% shuffles. 
echo Either file type does not exist or directory is too large to find it.
echo.
echo Program will close upon continuing
Pause
exit
