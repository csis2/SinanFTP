REM newtask.bat - versão 1.0 - 04/04/2018
REM Cria nova tarefa no agendador do Windows.

@echo off
set settime1=%time:~0,2%
set setminute=%time:~3,2%

set /a numhour=%settime1%
set /a newhour=%numhour%+1
echo %newhour%
if %newhour% equ 24 set /a newhour=0
echo %newhour%

set newhourstring=%newhour%
echo %newhourstring%

if %newhourstring% == 0 set newhourstring=00
if %newhourstring% == 1 set newhourstring=01
if %newhourstring% == 2 set newhourstring=02
if %newhourstring% == 3 set newhourstring=03
if %newhourstring% == 4 set newhourstring=04
if %newhourstring% == 5 set newhourstring=05
if %newhourstring% == 6 set newhourstring=06
if %newhourstring% == 7 set newhourstring=07
if %newhourstring% == 8 set newhourstring=08
if %newhourstring% == 9 set newhourstring=09

echo %newhourstring%
echo %setminute%

schtasks /create /SC DAILY /TN "AutoTask" /TR "c:\SinanFTP\exe\baixaDBFx.bat anoatual+passado" /ST %newhourstring%:%setminute% /RU SRVIMG\Administrador /rp #sinan@123# /F
echo %errorlevel%

if %ERRORLEVEL% == 0 (echo Tarefa criada com sucesso!) else (echo A criacao da tarefa falhou.)

pause
