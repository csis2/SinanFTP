echo %time:~0,2%:%time:~3,2%:%time:~6,2% %date:~-10,2%/%date:~-7,2%/%date:~-4,4%-------Renomeando e finalizando arquivo de log. >>c:\sinanftp\log\sinanFTP.log
echo Renomeando log de eventos
cd\
cd c:\sinanftp\log
rename SinanFTP.log SinanFTP_%date:~-10,2%%date:~-7,2%%date:~-4,4%_%time:~0,2%%time:~3,2%%time:~6,2%.log
del /F /Q SinanFTP.log