PROCEDURE Main()

clear
set console off
set status off
set scoreboard off
set century on
set date british
set confirm off

public nFound := 0
public cFound := ""
public cFile := ""

set color to w+/n
DispBox (1,2,9,74,1)
set color to gr+/n 

@ 3,3 say " Fill.exe - versao 1.0 - CSIS Software                              "
@ 4,3 say " Preenchimento automatico do campo dt_digita.                       "
@ 5,3 say "                                                                    "
@ 6,3 say " SUVISA - CSIS                                                      "
@ 7,3 say " Fevereiro/2018                                                     "
set color to g+/n

@ 10,1 say "Iniciando o fill.exe para preencher os campos dt_digita vazios..."
run ('c:\sinanftp\exe\escritor "Iniciando o fill.exe para preencher os campos dt_digita vazios..."')

* Verifica se os argumentos são válidos. 
if HB_ArgV( 1 ) <> "deng" .and. HB_ArgV( 1 ) <> "chik"
@ 11,1 say "Esses parametros nao sao validos."
run ('c:\sinanftp\exe\escritor "Os parametros para rodar o arquivo fill.exe nao sao validos..."')
run ('c:\sinanftp\exe\escritor "Finalizando o script fill.exe ..."')
__Quit()
else
@ 11,1 say "Argumento valido."
run ('c:\sinanftp\exe\escritor "Os parametros para rodar o arquivo fill.exe sao validos..."')
endif

* Imprime qual foi o argumento escolhido, se 'deng' ou 'chik'.
if HB_ArgV( 1 ) = "deng"
@ 12,1 say "Argumento escolhido: " + HB_ArgV( 1 )
run ('c:\sinanftp\exe\escritor "Argumento escolhido:deng..."')
endif
if HB_ArgV( 1 ) = "chik"
@ 12,1 say "Argumento escolhido: " + HB_ArgV( 1 )
run ('c:\sinanftp\exe\escritor "Argumento escolhido:chik..."')
endif

if HB_ArgV ( 1 ) = "deng"
if FILE("c:\SinanFTP\tmp\deng\dengon.dbf") = .F.
@ 13,1 say "O arquivo dengon.dbf nao foi encontrado."
@ 14,1 say "Fim do programa fill.exe."
run ('c:\sinanftp\exe\escritor "O arquivo dengon.dbf nao foi encontrado."')
run ('c:\sinanftp\exe\escritor "Fim do programa fill.exe."')
quit
endif
endif

if HB_ArgV ( 1 ) = "chik"
if FILE("c:\SinanFTP\tmp\chik\chikon.dbf") = .F.
@ 13,1 say "O arquivo chikon.dbf nao foi encontrado."
@ 14,1 say "Fim do programa fill.exe."
run ('c:\sinanftp\exe\escritor "O arquivo chikon.dbf nao foi encontrado."')
run ('c:\sinanftp\exe\escritor "Fim do programa fill.exe."')
quit
endif
endif

@ 13,1 say "Procurando pelos campos dt_digita vazios..."
run ('c:\sinanftp\exe\escritor "Procurando pelos campos dt_digita vazios..."')

if HB_ArgV ( 1 ) = "deng"
use c:\sinanftp\tmp\deng\dengon.dbf
endif
if HB_ArgV ( 1 ) = "chik"
use c:\sinanftp\tmp\deng\chikon.dbf
endif

do while .not. eof()
locate for empty(dt_digita)=.T.
if found()= .T.
nFound = nFound + 1
replace dt_digita with dt_notific
endif
skip
enddo

cFound = alltrim(str(nFound))
if nFound = 0
@ 14,1 say "Registros vazios no campo dt_digita nao foram encontrados..."
@ 15,1 say "Fim de execucao do fill.exe."
run ('c:\sinanftp\exe\escritor "Registros vazios no campo dt_digita nao foram encontrados..."')
run ('c:\sinanftp\exe\escritor "Fim de execucao do fill.exe."')
quit

else

@ 14,1 say (cFound) + " registros vazios no campo dt_digita foram encontrados e corrigidos..."
@ 15,1 say "Fim de execucao do fill.exe."
cFile = "c:\sinanftp\auxx\fill_aux.txt"
MEMOWRIT( cFile, cFound )
HB_Alert( "Aguarde um instante", "Ok!", , 7 )
run ('c:\sinanftp\bat\fill_aux.bat')
run ('c:\sinanftp\exe\escritor "Campo dt_digita com registros vazios foi corrigido..."')
run ('c:\sinanftp\exe\escritor "Fim de execucao do fill.exe."')
quit

endif

RETURN