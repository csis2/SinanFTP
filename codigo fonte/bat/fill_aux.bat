set /p var=<c:\sinanFTP\auxx\fill_aux.txt
echo %var%
echo %time:~0,2%:%time:~3,2%:%time:~6,2% %date:~-10,2%/%date:~-7,2%/%date:~-4,4%-------Foram encontrados %var% registros vazios no campos dt_digitacao.... >>c:\sinanftp\log\sinanFTP.log