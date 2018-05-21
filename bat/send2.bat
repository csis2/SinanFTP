cls
@echo off
echo *************************************************************************
echo * send2.bat versao 1.0 - 07/03/2018 - CSIS Software                     *
echo * Envia o arquivo dengon.dbf pelo FTP.                                  *
echo *************************************************************************
echo

echo Iniciando procedimentos do arquivo send2.bat.
echo %time:~0,2%:%time:~3,2%:%time:~6,2% %date:~-10,2%/%date:~-7,2%/%date:~-4,4%-------Iniciando procedimentos do arquivo send2.bat. >>c:\sinanftp\log\sinanFTP.log

echo Enviando arquivo gerado pelo FTP.
echo %time:~0,2%:%time:~3,2%:%time:~6,2% %date:~-10,2%/%date:~-7,2%/%date:~-4,4%-------Enviando arquivo gerado pelo FTP. >>c:\sinanftp\log\sinanFTP.log

echo Procedimento para enviar o arquivo gerado pelo FTP...
echo Acessando o diretorio do FTP...
cd\
cd c:\Program Files (x86)\WinSCP\
winscp.com /script="c:\sinanftp\rep\script_winscp.txt"
echo Feito.

echo Transferindo arquivo gerado para a pasta dbf.
echo %time:~0,2%:%time:~3,2%:%time:~6,2% %date:~-10,2%/%date:~-7,2%/%date:~-4,4%-------Transferindo arquivo gerado para a pasta dbf. >>c:\sinanftp\log\sinanFTP.log

echo Renomeando o arquivo DENGON.dbf para DENGON+data+hora.dbf...
cd\
cd c:\sinanftp\tmp\deng\
rename dengon.dbf dengon_%date:~-10,2%%date:~-7,2%%date:~-4,4%_%time:~0,2%%time:~3,2%%time:~6,2%.dbf
echo Feito.

echo Movendo o arquivo DENGON+data+hora.dbf para a pasta dbf...
move *.dbf c:\sinanftp\dbf\
echo Feito.

echo %time:~0,2%:%time:~3,2%:%time:~6,2% %date:~-10,2%/%date:~-7,2%/%date:~-4,4%-------Renomeando e finalizando arquivo de log. >>c:\sinanftp\log\sinanFTP.log
echo Renomeando log de eventos
cd\
cd c:\sinanftp\log
rename SinanFTP.log SinanFTP_%date:~-10,2%%date:~-7,2%%date:~-4,4%_%time:~0,2%%time:~3,2%%time:~6,2%.log
del /F /Q SinanFTP.log