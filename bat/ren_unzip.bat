@echo off
echo *************************************************************************
echo * ren_unzip.bat versao 1.0 - 14/02/2018 - CSIS Software                 *
echo * Renomeia e descompacta os arquivos baixados do script "baixaDBFx".    *
echo *************************************************************************
echo

echo %time:~0,2%:%time:~3,2%:%time:~6,2% %date:~-10,2%/%date:~-7,2%/%date:~-4,4%-------Rodando ren_unzip.bat. >>c:\sinanftp\log\sinanFTP.log
echo %time:~0,2%:%time:~3,2%:%time:~6,2% %date:~-10,2%/%date:~-7,2%/%date:~-4,4%-------Lendo arquivo download.ini para rastrear o modo. >>c:\sinanftp\log\sinanFTP.log
echo Le o arquivo "download.ini" e coloca na variavel "val" o valor da chave "modo".
for /f "delims=" %%a in ('call ini.bat c:\SinanFTP\auxx\download.ini DADOS modo') do (set val=%%a)
echo %val%

echo Se o valor da chave "modo" for "anoatual", roda o nivel1, caso contrario, roda o nivel2.
if %val% equ anoatual (call :nivel1) else (call :nivel2)
exit /b %errorlevel%

:nivel1
echo %time:~0,2%:%time:~3,2%:%time:~6,2% %date:~-10,2%/%date:~-7,2%/%date:~-4,4%-------Modo identificado: anoatual. >>c:\sinanftp\log\sinanFTP.log
echo %time:~0,2%:%time:~3,2%:%time:~6,2% %date:~-10,2%/%date:~-7,2%/%date:~-4,4%-------Renomeando arquivo zipado. >>c:\sinanftp\log\sinanFTP.log
echo Renomeia o arquivo zipado...
rename c:\sinanftp\tmp\deng\1\*.zip dengue1DBF.zip
echo %time:~0,2%:%time:~3,2%:%time:~6,2% %date:~-10,2%/%date:~-7,2%/%date:~-4,4%-------Descompactando arquivo importado do SINAN On line. >>c:\sinanftp\log\sinanFTP.log
echo Descompacta o arquivo importado do SINAN On Line...
c:\sinanftp\exe\7za e c:\sinanftp\tmp\deng\1\dengue1DBF.zip -oc:\sinanftp\tmp\deng\1\ -y
echo %time:~0,2%:%time:~3,2%:%time:~6,2% %date:~-10,2%/%date:~-7,2%/%date:~-4,4%-------Renomeando arquivo descompactado. >>c:\sinanftp\log\sinanFTP.log
rename c:\sinanftp\tmp\deng\1\*.dbf dengue1DBF.dbf
echo %time:~0,2%:%time:~3,2%:%time:~6,2% %date:~-10,2%/%date:~-7,2%/%date:~-4,4%-------Finalizando os procedimentos do arquivo ren_unzip.bat. >>c:\sinanftp\log\sinanFTP.log
echo Feito.
exit /B 0

:nivel2
echo Renomeia os arquivos zipados...
echo %time:~0,2%:%time:~3,2%:%time:~6,2% %date:~-10,2%/%date:~-7,2%/%date:~-4,4%-------Modo identificado: anoatual+passado. >>c:\sinanftp\log\sinanFTP.log
echo %time:~0,2%:%time:~3,2%:%time:~6,2% %date:~-10,2%/%date:~-7,2%/%date:~-4,4%-------Renomeando arquivos zipados. >>c:\sinanftp\log\sinanFTP.log
rename c:\sinanftp\tmp\deng\1\*.zip dengue1DBF.zip
rename c:\sinanftp\tmp\deng\2\*.zip dengue2DBF.zip

echo Descompacta os arquivos importados do SINAN On Line...
echo %time:~0,2%:%time:~3,2%:%time:~6,2% %date:~-10,2%/%date:~-7,2%/%date:~-4,4%-------Descompactando arquivos importados do SINAN Online. >>c:\sinanftp\log\sinanFTP.log
c:\sinanftp\exe\7za e c:\sinanftp\tmp\deng\1\dengue1DBF.zip -oc:\sinanftp\tmp\deng\1\ -y
c:\sinanftp\exe\7za e c:\sinanftp\tmp\deng\2\dengue2DBF.zip -oc:\sinanftp\tmp\deng\2\ -y

echo %time:~0,2%:%time:~3,2%:%time:~6,2% %date:~-10,2%/%date:~-7,2%/%date:~-4,4%-------Renomeando os arquivos que foram descompactados. >>c:\sinanftp\log\sinanFTP.log
echo Renomeia os arquivos DBFs que foram descompactados.
rename c:\sinanftp\tmp\deng\1\*.dbf dengue1DBF.dbf
rename c:\sinanftp\tmp\deng\2\*.dbf dengue2DBF.dbf
echo %time:~0,2%:%time:~3,2%:%time:~6,2% %date:~-10,2%/%date:~-7,2%/%date:~-4,4%-------Finalizando os procedimentos do arquivo ren_unzip.bat. >>c:\sinanftp\log\sinanFTP.log
echo Feito.
exit /B 0