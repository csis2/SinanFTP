cls
@echo off
echo *************************************************************************
echo * send2.bat versao 1.1 - 07/03/2018 - CSIS Software                     *
echo * Envia o arquivo dengon.dbf ou chikon.dbf pelo FTP.                    *
echo *************************************************************************
echo

echo Iniciando procedimentos do arquivo send2.bat.
echo %time:~0,2%:%time:~3,2%:%time:~6,2% %date:~-10,2%/%date:~-7,2%/%date:~-4,4%-------Iniciando procedimentos do arquivo send2.bat. >>c:\sinanftp\log\sinanFTP.log

echo Verificando se o argumento do script e valido.
echo %time:~0,2%:%time:~3,2%:%time:~6,2% %date:~-10,2%/%date:~-7,2%/%date:~-4,4%-------Verificando se o script tem argumento válido. >>c:\sinanftp\log\sinanFTP.log

REM Verifica se ha argumentos no script.
if [%1]==[] (goto vazio)
IF not [%1] == [deng] IF not [%1] == [chik] (goto invalido)

if %1 == deng (
echo Argumento escolhido: deng.
echo %time:~0,2%:%time:~3,2%:%time:~6,2% %date:~-10,2%/%date:~-7,2%/%date:~-4,4%-------Argumento escolhido: deng. >>c:\sinanftp\log\sinanFTP.log
)

if %1 == chik (
echo Argumento escolhido: chik.
echo %time:~0,2%:%time:~3,2%:%time:~6,2% %date:~-10,2%/%date:~-7,2%/%date:~-4,4%-------Argumento escolhido: chik. >>c:\sinanftp\log\sinanFTP.log
)

if %1 == deng (
if exist c:\sinanftp\tmp\deng\dengon.dbf (
echo Arquivo dengon.dbf detectado. Continuando o procedimento...
echo %time:~0,2%:%time:~3,2%:%time:~6,2% %date:~-10,2%/%date:~-7,2%/%date:~-4,4%-------Arquivo dengon.dbf detectado. Continuando o procedimento... >>c:\sinanftp\log\sinanFTP.log
) else (
echo Arquivo dengon.dbf nao detectado. Fim do script...
echo %time:~0,2%:%time:~3,2%:%time:~6,2% %date:~-10,2%/%date:~-7,2%/%date:~-4,4%-------Arquivo dengon.dbf nao detectado. Fim do script... >>c:\sinanftp\log\sinanFTP.log
timeout 5
call c:\sinanftp\bat\log_close.bat
timeout 5
exit
)
)

if %1 == chik (
if exist c:\sinanftp\tmp\chik\chikon.dbf (
echo Arquivo chikon.dbf detectado. Continuando o procedimento...
echo %time:~0,2%:%time:~3,2%:%time:~6,2% %date:~-10,2%/%date:~-7,2%/%date:~-4,4%-------Arquivo chikon.dbf detectado. Continuando o procedimento... >>c:\sinanftp\log\sinanFTP.log
) else (
echo Arquivo chikon.dbf nao detectado. Fim do script...
echo %time:~0,2%:%time:~3,2%:%time:~6,2% %date:~-10,2%/%date:~-7,2%/%date:~-4,4%-------Arquivo chikon.dbf nao detectado. Fim do script... >>c:\sinanftp\log\sinanFTP.log
timeout 5
call c:\sinanftp\bat\log_close.bat
timeout 5
exit
)
)

if %1 == deng (
copy c:\sinanFTP\tmp\deng\dengon.dbf c:\sinanFTP\tmp\ftp
timeout 6
rename c:\sinanFTP\tmp\ftp\dengon.dbf dengon1.dbf
timeout 6
)

if %1 == chik (
copy c:\sinanFTP\tmp\chik\chikon.dbf c:\sinanFTP\tmp\ftp
timeout 6
rename c:\sinanFTP\tmp\ftp\chikon.dbf chikon1.dbf
timeout 6
)

if %1 == deng (
echo entrando no argumento deng.
echo Enviando arquivo gerado pelo FTP.
echo %time:~0,2%:%time:~3,2%:%time:~6,2% %date:~-10,2%/%date:~-7,2%/%date:~-4,4%-------Enviando arquivo gerado pelo FTP. >>c:\sinanftp\log\sinanFTP.log
cd\
cd c:\WinSCP\
winscp.com /script="c:\sinanftp\rep\openFTP1.txt"
echo Feito.
)

if %1 == deng (
echo Renomeando o arquivo DENGON.dbf para DENGON+data+hora.dbf...
echo %time:~0,2%:%time:~3,2%:%time:~6,2% %date:~-10,2%/%date:~-7,2%/%date:~-4,4%-------Renomeando o arquivo DENGON.dbf para DENGON+data+hora.dbf... >>c:\sinanftp\log\sinanFTP.log
rename c:\sinanftp\tmp\deng\dengon.dbf dengon_%date:~-10,2%%date:~-7,2%%date:~-4,4%_%time:~0,2%%time:~3,2%%time:~6,2%.dbf
timeout 6
echo Feito.

echo Movendo o arquivo DENGON+data+hora para a pasta dbf.
echo %time:~0,2%:%time:~3,2%:%time:~6,2% %date:~-10,2%/%date:~-7,2%/%date:~-4,4%-------Movendo o arquivo DENGON+data+hora para a pasta dbf. >>c:\sinanftp\log\sinanFTP.log
move c:\sinanftp\tmp\deng\dengon_*.dbf c:\sinanftp\dbf\
timeout 6
echo Feito.

exit
)

if %1 == chik (
echo entrando no argumento chik...
echo Enviando arquivo gerado pelo FTP.
echo %time:~0,2%:%time:~3,2%:%time:~6,2% %date:~-10,2%/%date:~-7,2%/%date:~-4,4%-------Enviando arquivo gerado pelo FTP. >>c:\sinanftp\log\sinanFTP.log
cd\
cd c:\WinSCP\
winscp.com /script="c:\sinanftp\rep\openFTP2.txt"
echo Feito.
)

if %1 == chik (
echo Renomeando o arquivo CHIKON.dbf para CHIKON+data+hora.dbf...
echo %time:~0,2%:%time:~3,2%:%time:~6,2% %date:~-10,2%/%date:~-7,2%/%date:~-4,4%-------Renomeando o arquivo CHIKON.dbf para CHIKON+data+hora.dbf... >>c:\sinanftp\log\sinanFTP.log
rename c:\sinanftp\tmp\chik\chikon.dbf chikon_%date:~-10,2%%date:~-7,2%%date:~-4,4%_%time:~0,2%%time:~3,2%%time:~6,2%.dbf
timeout 6
echo Feito.

echo Movendo o arquivo CHIKON+data+hora para a pasta dbf.
echo %time:~0,2%:%time:~3,2%:%time:~6,2% %date:~-10,2%/%date:~-7,2%/%date:~-4,4%-------Movendo o arquivo CHIKON+data+hora para a pasta dbf. >>c:\sinanftp\log\sinanFTP.log
move c:\sinanftp\tmp\chik\chikon_*.dbf c:\sinanftp\dbf\
timeout 6
echo Feito.

exit
)

:vazio
echo Nao foi usado nenhum argumento na linha de comando para usar este script.
echo %time:~0,2%:%time:~3,2%:%time:~6,2% %date:~-10,2%/%date:~-7,2%/%date:~-4,4%-------Nao foi usado nenhum argumento na linha de comando para usar este script. >>c:\sinanftp\log\sinanFTP.log
timeout 4
call c:\sinanftp\bat\log_close.bat
timeout 6
exit

:invalido
echo O argumento na linha de comando para usar este script e invalido.
echo %time:~0,2%:%time:~3,2%:%time:~6,2% %date:~-10,2%/%date:~-7,2%/%date:~-4,4%-------O argumento na linha de comando para usar este script e invalido. >>c:\sinanftp\log\sinanFTP.log
timeout 4
call c:\sinanftp\bat\log_close.bat
timeout 6
exit
