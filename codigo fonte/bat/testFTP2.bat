cls
echo off
echo.
echo **************************************
echo *                                    *
echo * Script em MS-DOS para testar o FTP *
echo *           CSIS Software            *
echo *                                    *
echo *            Versao 1.2              *
echo *            22/02/2018              *
echo *                                    *
echo **************************************
echo.
echo off
echo
cd\

echo Iniciando script para testar o FTP (testFTP2.bat)
echo %time:~0,2%:%time:~3,2%:%time:~6,2% %date:~-10,2%/%date:~-7,2%/%date:~-4,4%-------Iniciando script para testar o FTP (testFTP2.bat). >>c:\sinanftp\log\sinanFTP.log

echo Verificando se o WinSCP está instalado para a transferencia dos arquivos...
echo %time:~0,2%:%time:~3,2%:%time:~6,2% %date:~-10,2%/%date:~-7,2%/%date:~-4,4%-------Verificando se o WinSCP está instalado para a transferencia dos arquivos. >>c:\sinanftp\log\sinanFTP.log
if exist c:\winscp\winscp.com (
echo WinSCP.com presente no diretorio.
echo %time:~0,2%:%time:~3,2%:%time:~6,2% %date:~-10,2%/%date:~-7,2%/%date:~-4,4%-------WinSCP.com presente no diretorio. >>c:\sinanftp\log\sinanFTP.log
) else (
echo WinSCP.com nao esta presente no diretorio. Fim do script.
echo %time:~0,2%:%time:~3,2%:%time:~6,2% %date:~-10,2%/%date:~-7,2%/%date:~-4,4%-------WinSCP.com nao esta presente no diretorio. Fim do script. >>c:\sinanftp\log\sinanFTP.log
call c:\sinanftp\bat\log_close.bat
exit
)

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
call :dengblock_teste
)

if %1 == chik (
call :chikblock_teste
)

:dengblock_teste

echo Testando o WinSCP com transferencia de arquivo de teste.
echo %time:~0,2%:%time:~3,2%:%time:~6,2% %date:~-10,2%/%date:~-7,2%/%date:~-4,4%-------Testando o WinSCP com transferencia de arquivo de teste. >>c:\sinanftp\log\sinanFTP.log

cd\
cd c:\sinanftp\tmp\ftp
echo Gerando arquivo de teste...
echo Teste FTP>teste.ftp

echo Procedimento para enviar o arquivo gerado pelo FTP...

REM Aqui voce deve fornecer o login, senha e nome do host do FTP para acessar o WinSCP (arquivo dengon.dbf)
set login=sinan_ftp
set senha=9c6yrbrj
set host=pentaho-prod.saude-go.net

echo Fazendo o upload do arquivo de teste pelo FTP...
echo %time:~0,2%:%time:~3,2%:%time:~6,2% %date:~-10,2%/%date:~-7,2%/%date:~-4,4%-------Fazendo o upload do arquivo de teste pelo FTP. >>c:\sinanftp\log\sinanFTP.log
c:\winscp\winscp.com /ini=nul /command "open ftp://%login%:%senha%@%host%" "cd /Dengue" "put c:\sinanFTP\tmp\ftp\teste.ftp" "exit"
echo Feito.

echo deletando arquivo gerado na pasta tmp...
cd\
cd c:\sinanftp\tmp\ftp
erase *.ftp

echo Procedimento para fazer o download do arquivo no FTP...

echo Fazendo o download do arquivo de teste pelo FTP...
echo %time:~0,2%:%time:~3,2%:%time:~6,2% %date:~-10,2%/%date:~-7,2%/%date:~-4,4%-------Fazendo o download do arquivo de teste pelo FTP. >>c:\sinanftp\log\sinanFTP.log
c:\winscp\winscp.com /ini=nul /command "open ftp://%login%:%senha%@%host%" "cd /Dengue" "get -delete teste.ftp c:\sinanFTP\tmp\ftp\" "exit"
echo Feito.

echo acessando a pasta tmp para constatar que o download foi realizado...
cd\
cd c:\sinanftp\tmp\ftp

echo Testa se o arquivo compactado esta presente...
if exist teste.ftp (goto ftpok) else (goto ftpnotok)

:chikblock_teste

echo Testando o WinSCP com transferencia de arquivo de teste.
echo %time:~0,2%:%time:~3,2%:%time:~6,2% %date:~-10,2%/%date:~-7,2%/%date:~-4,4%-------Testando o WinSCP com transferencia de arquivo de teste. >>c:\sinanftp\log\sinanFTP.log

cd\
cd c:\sinanftp\tmp\ftp
echo Gerando arquivo de teste...
echo Teste FTP>teste.ftp

echo Procedimento para enviar o arquivo gerado pelo FTP...

REM Aqui voce deve fornecer o login, senha e nome do host do FTP para acessar o WinSCP (arquivo chikon.dbf)
set login=sinan_ftp
set senha=Co6L!QEN
set host=pentaho8-prod.saude-go.net

echo Fazendo o upload do arquivo de teste pelo FTP...
echo %time:~0,2%:%time:~3,2%:%time:~6,2% %date:~-10,2%/%date:~-7,2%/%date:~-4,4%-------Fazendo o upload do arquivo de teste pelo FTP. >>c:\sinanftp\log\sinanFTP.log
c:\winscp\winscp.com /ini=nul /command "open ftp://%login%:%senha%@%host%" "cd /Chikungunya" "put c:\sinanFTP\tmp\ftp\teste.ftp" "exit"
echo Feito.

echo deletando arquivo gerado na pasta tmp...
cd\
cd c:\sinanftp\tmp\ftp
erase *.ftp

echo Procedimento para fazer o download do arquivo no FTP...

echo Fazendo o download do arquivo de teste pelo FTP...
echo %time:~0,2%:%time:~3,2%:%time:~6,2% %date:~-10,2%/%date:~-7,2%/%date:~-4,4%-------Fazendo o download do arquivo de teste pelo FTP. >>c:\sinanftp\log\sinanFTP.log
c:\winscp\winscp.com /ini=nul /command "open ftp://%login%:%senha%@%host%" "cd /Chikungunya" "get -delete teste.ftp c:\sinanFTP\tmp\ftp\" "exit"
echo Feito.

echo acessando a pasta tmp para constatar que o download foi realizado...
cd\
cd c:\sinanftp\tmp\ftp

echo Testa se o arquivo compactado esta presente...
if exist teste.ftp (goto ftpok) else (goto ftpnotok)

:ftpok
echo FTP operando sem problema.
echo %time:~0,2%:%time:~3,2%:%time:~6,2% %date:~-10,2%/%date:~-7,2%/%date:~-4,4%-------FTP operando sem problema. >>c:\sinanftp\log\sinanFTP.log
erase *.ftp
exit

:ftpnotok
echo FTP com problema.
echo %time:~0,2%:%time:~3,2%:%time:~6,2% %date:~-10,2%/%date:~-7,2%/%date:~-4,4%-------FTP com problema. Fim do script. >>c:\sinanftp\log\sinanFTP.log
erase *.ftp
call c:\sinanftp\bat\log_close.bat
exit

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
