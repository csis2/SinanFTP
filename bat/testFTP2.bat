cls
echo off
echo.
echo **************************************
echo *                                    *
echo * Script em MS-DOS para testar o FTP *
echo *                                    *
echo *                                    *
echo *            Versao 1.0              *
echo *            22/02/2018              *
echo *                                    *
echo **************************************
echo.
echo off
echo
cd\

echo %time:~0,2%:%time:~3,2%:%time:~6,2% %date:~-10,2%/%date:~-7,2%/%date:~-4,4%-------Iniciando teste do FTP (testFTP.bat). >>c:\sinanftp\log\sinanFTP.log

cd c:\sinanftp\tmp\ftp
echo Gerando arquivo de teste...
echo Teste FTP>teste.ftp

echo Procedimento para enviar o arquivo gerado pelo FTP...
echo Acessando o diretorio do FTP...
cd\
cd c:\Program Files (x86)\WinSCP\
winscp.com /script="c:\sinanftp\rep\testFTPup.txt"
echo Feito.

echo deletando arquivo gerado na pasta tmp...
cd\
cd c:\sinanftp\tmp\ftp
erase *.ftp

echo Procedimento para download do arquivo no FTP...
echo Acessando o diretorio do FTP...
cd\
cd c:\Program Files (x86)\WinSCP\
winscp.com /script="c:\sinanftp\rep\testFTPdown.txt"
echo Feito.

echo acessando a pasta tmp para constatar que o download foi realizado...
cd\
cd c:\sinanftp\tmp\ftp

echo Testa se o arquivo compactado esta presente...
if exist teste.ftp (goto ftpok) else (goto ftpnotok)

:ftpok
echo %time:~0,2%:%time:~3,2%:%time:~6,2% %date:~-10,2%/%date:~-7,2%/%date:~-4,4%-------FTP operando sem problema. >>c:\sinanftp\log\sinanFTP.log
erase *.ftp
exit

:ftpnotok
echo %time:~0,2%:%time:~3,2%:%time:~6,2% %date:~-10,2%/%date:~-7,2%/%date:~-4,4%-------FTP com problema. >>c:\sinanftp\log\sinanFTP.log
erase *.ftp
exit