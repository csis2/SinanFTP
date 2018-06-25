@echo off
echo *************************************************************************
echo * compare.bat versao 1.0 - 09/06/2018 - CSIS Software                   *
echo * Verifica se o arquivo gerado no SinanFTP foi enviado ao FTP.          *
echo * Para fazer isso, o compare.bat faz o download do arquivo que foi      *
echo * enviado ao FTP e compara com o que foi gerado com o SinanFTP.         *
echo *************************************************************************
echo
echo Iniciando procedimentos do arquivo compare.bat.
echo %time:~0,2%:%time:~3,2%:%time:~6,2% %date:~-10,2%/%date:~-7,2%/%date:~-4,4%-------Iniciando procedimentos do arquivo compare.bat. >>c:\sinanftp\log\sinanFTP.log

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
if exist c:\sinanftp\tmp\ftp\dengon1.dbf (
echo Arquivo dengon1.dbf detectado. Continuando o procedimento...
echo %time:~0,2%:%time:~3,2%:%time:~6,2% %date:~-10,2%/%date:~-7,2%/%date:~-4,4%-------Arquivo dengon1.dbf detectado. Continuando o procedimento... >>c:\sinanftp\log\sinanFTP.log
) else (
echo Arquivo dengon1.dbf nao detectado. Fim do script compare.bat.
echo %time:~0,2%:%time:~3,2%:%time:~6,2% %date:~-10,2%/%date:~-7,2%/%date:~-4,4%-------Arquivo dengon1.dbf nao detectado. Fim do script compare.bat. >>c:\sinanftp\log\sinanFTP.log
call c:\sinanftp\bat\log_close.bat
exit
)
)

if %1 == chik (
if exist c:\sinanftp\tmp\ftp\chikon1.dbf (
echo Arquivo chikon1.dbf detectado. Continuando o procedimento...
echo %time:~0,2%:%time:~3,2%:%time:~6,2% %date:~-10,2%/%date:~-7,2%/%date:~-4,4%-------Arquivo chikon1.dbf detectado. Continuando o procedimento... >>c:\sinanftp\log\sinanFTP.log
) else (
echo Arquivo chikon1.dbf nao detectado. Fim do script compare.bat.
echo %time:~0,2%:%time:~3,2%:%time:~6,2% %date:~-10,2%/%date:~-7,2%/%date:~-4,4%-------Arquivo chikon1.dbf nao detectado. Fim do script compare.bat. >>c:\sinanftp\log\sinanFTP.log
call c:\sinanftp\bat\log_close.bat
exit
)
)

if %1 == deng (
echo Iniciando procedimentos para fazer o download do arquivo dengon.dbf por FTP.
echo %time:~0,2%:%time:~3,2%:%time:~6,2% %date:~-10,2%/%date:~-7,2%/%date:~-4,4%-------Iniciando procedimentos para fazer o download do arquivo dengon.dbf por FTP. >>c:\sinanftp\log\sinanFTP.log
)

if %1 == chik (
echo Iniciando procedimentos para fazer o download do arquivo chikon.dbf por FTP.
echo %time:~0,2%:%time:~3,2%:%time:~6,2% %date:~-10,2%/%date:~-7,2%/%date:~-4,4%-------Iniciando procedimentos para fazer o download do arquivo chikon.dbf por FTP. >>c:\sinanftp\log\sinanFTP.log
)

if %1 == deng (
call :dengblock
)

if %1 == chik (
call :chikblock
)

:dengblock

REM Aqui voce deve fornecer o login, senha e nome do host do FTP para acessar o WinSCP (arquivo dengon.dbf)
set login=sinan_ftp
set senha=9c6yrbrj
set host=pentaho-prod.saude-go.net

echo Fazendo o download do arquivo dengon.dbf pelo FTP...
echo %time:~0,2%:%time:~3,2%:%time:~6,2% %date:~-10,2%/%date:~-7,2%/%date:~-4,4%-------Fazendo o download do arquivo dengon.dbf pelo FTP. >>c:\sinanftp\log\sinanFTP.log
c:\winscp\winscp.com /ini=nul /command "open ftp://%login%:%senha%@%host%" "get /Dengue/dengon.dbf c:\sinanFTP\tmp\ftp\dengon2.dbf" "exit"

if exist c:\sinanftp\tmp\ftp\dengon2.dbf (
echo Arquivo dengon2.dbf detectado. Continuando o procedimento...
echo %time:~0,2%:%time:~3,2%:%time:~6,2% %date:~-10,2%/%date:~-7,2%/%date:~-4,4%-------Arquivo dengon2.dbf detectado. Continuando o procedimento... >>c:\sinanftp\log\sinanFTP.log
) else (
echo Arquivo dengon2.dbf nao detectado. Fim do script compare.bat.
echo %time:~0,2%:%time:~3,2%:%time:~6,2% %date:~-10,2%/%date:~-7,2%/%date:~-4,4%-------Arquivo dengon2.dbf nao detectado. Fim do script compare.bat. >>c:\sinanftp\log\sinanFTP.log
call c:\sinanftp\bat\log_close.bat
exit
)

echo Iniciando o processo de comparacao.
echo %time:~0,2%:%time:~3,2%:%time:~6,2% %date:~-10,2%/%date:~-7,2%/%date:~-4,4%-------Iniciando o processo de comparacao... >>c:\sinanftp\log\sinanFTP.log

echo n|comp c:\sinanftp\tmp\ftp\dengon1.dbf c:\sinanftp\tmp\ftp\dengon2.dbf /N
if %errorlevel% == 0 (
echo O arquivo dengon.dbf foi corretamente enviado pelo FTP.
echo %time:~0,2%:%time:~3,2%:%time:~6,2% %date:~-10,2%/%date:~-7,2%/%date:~-4,4%-------O arquivo dengon.dbf foi corretamente enviado para o FTP. >>c:\sinanftp\log\sinanFTP.log
echo Fim do script compare.bat.
echo %time:~0,2%:%time:~3,2%:%time:~6,2% %date:~-10,2%/%date:~-7,2%/%date:~-4,4%-------Fim do script compare.bat. >>c:\sinanftp\log\sinanFTP.log
call c:\sinanftp\bat\log_close.bat
START "" /D c:\sinanftp\exe\ "sinanmail.exe" deng ok
exit
) else (
echo O processo falhou. O arquivo dengon.dbf nao foi enviado pelo FTP.
echo %time:~0,2%:%time:~3,2%:%time:~6,2% %date:~-10,2%/%date:~-7,2%/%date:~-4,4%-------O processo falhou. O arquivo dengon.dbf nao foi enviado pelo FTP. >>c:\sinanftp\log\sinanFTP.log
call c:\sinanftp\bat\log_close.bat
START "" /D c:\sinanftp\exe\ "sinanmail.exe" deng error
exit
)

:chikblock

REM Aqui voce deve fornecer o login, senha e nome do host do FTP para acessar o WinSCP (arquivo chikon.dbf)
set login=sinan_ftp
set senha=Co6L!QEN
set host=pentaho8-prod.saude-go.net

echo Fazendo o download do arquivo chikon.dbf pelo FTP...
echo %time:~0,2%:%time:~3,2%:%time:~6,2% %date:~-10,2%/%date:~-7,2%/%date:~-4,4%-------Fazendo o download do arquivo chikon.dbf pelo FTP. >>c:\sinanftp\log\sinanFTP.log
c:\winscp\winscp.com /ini=nul /command "open ftp://%login%:%senha%@%host%" "get /Chikungunya/chikon.dbf c:\sinanFTP\tmp\ftp\chikon2.dbf" "exit"

if exist c:\sinanftp\tmp\ftp\chikon2.dbf (
echo Arquivo chikon2.dbf detectado. Continuando o procedimento...
echo %time:~0,2%:%time:~3,2%:%time:~6,2% %date:~-10,2%/%date:~-7,2%/%date:~-4,4%-------Arquivo chikon2.dbf detectado. Continuando o procedimento... >>c:\sinanftp\log\sinanFTP.log
) else (
echo Arquivo chikon2.dbf nao detectado. Fim do script compare.bat.
echo %time:~0,2%:%time:~3,2%:%time:~6,2% %date:~-10,2%/%date:~-7,2%/%date:~-4,4%-------Arquivo chikon2.dbf nao detectado. Fim do script compare.bat. >>c:\sinanftp\log\sinanFTP.log
call c:\sinanftp\bat\log_close.bat
exit
)

echo Iniciando o processo de comparacao.
echo %time:~0,2%:%time:~3,2%:%time:~6,2% %date:~-10,2%/%date:~-7,2%/%date:~-4,4%-------Iniciando o processo de comparacao... >>c:\sinanftp\log\sinanFTP.log

echo n|comp c:\sinanftp\tmp\ftp\chikon1.dbf c:\sinanftp\tmp\ftp\chikon2.dbf /N
if %errorlevel% == 0 (
echo O arquivo chikon.dbf foi corretamente enviado pelo FTP.
echo %time:~0,2%:%time:~3,2%:%time:~6,2% %date:~-10,2%/%date:~-7,2%/%date:~-4,4%-------O arquivo chikon.dbf foi corretamente enviado para o FTP. >>c:\sinanftp\log\sinanFTP.log
echo Fim do script compare.bat.
echo %time:~0,2%:%time:~3,2%:%time:~6,2% %date:~-10,2%/%date:~-7,2%/%date:~-4,4%-------Fim do script compare.bat. >>c:\sinanftp\log\sinanFTP.log
call c:\sinanftp\bat\log_close.bat
START "" /D c:\sinanftp\exe\ "sinanmail.exe" chik ok
exit
) else (
echo O processo falhou. O arquivo chikon.dbf nao foi enviado pelo FTP.
echo %time:~0,2%:%time:~3,2%:%time:~6,2% %date:~-10,2%/%date:~-7,2%/%date:~-4,4%-------O processo falhou. O arquivo chikon.dbf nao foi enviado pelo FTP. >>c:\sinanftp\log\sinanFTP.log
call c:\sinanftp\bat\log_close.bat
START "" /D c:\sinanftp\exe\ "sinanmail.exe" chik error
exit
)

:vazio
echo Nao foi usado nenhum argumento na linha de comando para usar este script.
echo %time:~0,2%:%time:~3,2%:%time:~6,2% %date:~-10,2%/%date:~-7,2%/%date:~-4,4%-------Nao foi usado nenhum argumento na linha de comando para usar este script. >>c:\sinanftp\log\sinanFTP.log
call c:\sinanftp\bat\log_close.bat
exit

:invalido
echo O argumento na linha de comando para usar este script e invalido.
echo %time:~0,2%:%time:~3,2%:%time:~6,2% %date:~-10,2%/%date:~-7,2%/%date:~-4,4%-------O argumento na linha de comando para usar este script e invalido. >>c:\sinanftp\log\sinanFTP.log
call c:\sinanftp\bat\log_close.bat
exit
