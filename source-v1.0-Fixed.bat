@Echo Off

:Start
set count=0
for /f %%f in ('dir "C:\Users\echox\OneDrive\Pictures" /b') do set /a count+=1
set /a randN=%random% %% %count% +1
set listN=0

for /f "tokens=1* delims=:" %%I in ('dir "%directory%" /b /s^| findstr /n /r . ^| findstr /b "%randN%"') do set filename=%%J

:Found
echo %filename%

pause