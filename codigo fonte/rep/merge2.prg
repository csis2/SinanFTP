PROCEDURE Main()

clear
set console off
set status off
set scoreboard off
set century on
set date british
set confirm off
set exact on

set color to w+/n
DispBox (1,2,6,74,1)
set color to gr+/n 
@ 2,3 say " Merge2 versao 1.0                                     "
@ 3,3 say " Uniao de arquivos DENGON.DBF e CHIKON.DBF             "
@ 4,3 say " CSIS Software                                         "
@ 5,3 say " Maio/2018                                             "
set color to g+/n 

PUBLIC nPos := 13
PUBLIC aName, tmp
PUBLIC cFile := ""

run ('c:\sinanftp\exe\escritor "Iniciando o script merge2..."')

* Verifica se os argumentos são válidos. 
if HB_ArgV( 1 ) <> "deng" .and. HB_ArgV( 1 ) <> "chik"
@ 8,1 say "Esses parametros nao sao validos."
run ('c:\sinanftp\exe\escritor "Os parametros para rodar o arquivo merge2.exe nao sao validos..."')
run ('c:\sinanftp\exe\escritor "Finalizando merge2.exe ..."')
__Quit()
else
@ 8,1 say "Argumento valido."
run ('c:\sinanftp\exe\escritor "Os parametros para rodar o arquivo merge2.exe sao validos..."')
endif

* Imprime qual foi o argumento escolhido, se 'deng' ou 'chik'.
if HB_ArgV( 1 ) = "deng"
PUBLIC nLen := ADir( "c:\sinanftp\tmp\deng\*.dbf" )
@ 9,1 say "Argumento escolhido: " + HB_ArgV( 1 )
run ('c:\sinanftp\exe\escritor "Argumento escolhido:deng..."')
endif
if HB_ArgV( 1 ) = "chik"
PUBLIC nLen := ADir( "c:\sinanftp\tmp\chik\*.dbf" )
@ 9,1 say "Argumento escolhido: " + HB_ArgV( 1 )
run ('c:\sinanftp\exe\escritor "Argumento escolhido:chik..."')
endif

* verifica se há arquivos DBF na pasta especifica.
if HB_ArgV ( 1 ) = "deng"
if (File( 'c:\SinanFTP\tmp\deng\*.dbf' ) = .T.)
@ 10,1 say "Arquivos dbf presentes na pasta 'deng' para uniao de arquivos..."
run ('c:\sinanftp\exe\escritor "Arquivos dbf presentes na pasta deng para a uniao de arquivos..."')
else
@ 10,1 say "Arquivos dbf nao foram detectados na pasta 'deng' para a uniao de arquivos..."
run ('c:\sinanftp\exe\escritor "Arquivos dbf nao foram detectados na pasta 'deng' para a uniao de arquivos..."')
__Quit()
endif
endif
if HB_ArgV ( 1 ) = "chik"
if (File( 'c:\SinanFTP\tmp\chik\*.dbf' ) = .T.)
@ 10,1 say "Arquivos dbf presentes na pasta 'chik' para uniao de arquivos..."
run ('c:\sinanftp\exe\escritor "Arquivos dbf presentes na pasta chik para a uniao de arquivos..."')
else
@ 10,1 say "Arquivos dbf nao foram detectados na pasta 'chik' para a uniao de arquivos..."
run ('c:\sinanftp\exe\escritor "Arquivos dbf nao foram detectados na pasta 'chik' para a uniao de arquivos..."')
__Quit()
endif
endif

if HB_ArgV( 1 ) = "deng" // instruções para o argumento de valor "deng".
nLen = ADir( "c:\sinanftp\tmp\deng\*.dbf" )
set color to g+/n
@ 11,1 say "Criando a estrutura da tabela dengx.dbf..."
run ('c:\sinanftp\exe\escritor "Criando a estrutura da tabela dengx.dbf..."')
aDbf := {}
        AADD(aDbf, { "nu_notific", "C", 7, 0 })
        AADD(aDbf, { "dt_notific", "D", 8, 0 })
        AADD(aDbf, { "nu_ano", "C", 4, 0 })
        AADD(aDbf, { "id_mn_resi", "C", 6, 0 })
        AADD(aDbf, { "nm_bairro", "C", 60, 0 })
        AADD(aDbf, { "nm_logrado", "C", 60, 0 })
        AADD(aDbf, { "dt_digita", "D", 8, 0 })
        AADD(aDbf, { "nm_complem", "C", 30, 0 })
        AADD(aDbf, { "nu_cep", "C", 8, 0 })
        AADD(aDbf, { "nu_numero", "C", 6, 0 })
        AADD(aDbf, { "dt_nasc", "D", 8, 0 })
DBCREATE("c:\sinanftp\tmp\deng\dengx", aDbf)
endif

if HB_ArgV( 1 ) = "chik" // instruções para o argumento de valor "chik".
nLen = ADir( "c:\sinanftp\tmp\chik\*.dbf" )
set color to g+/n
@ 11,1 say "Criando a estrutura da tabela chikx.dbf..."
run ('c:\sinanftp\exe\escritor "Criando a estrutura da tabela chikx.dbf..."')
aDbf := {}
        AADD(aDbf, { "nu_notific", "C", 7, 0 })
        AADD(aDbf, { "dt_sin_pri", "D", 8, 0 })
        AADD(aDbf, { "sem_pri", "C", 6, 0 })
        AADD(aDbf, { "id_mn_resi", "C", 6, 0 })
		AADD(aDbf, { "classi_fin", "C", 2, 0 })
		AADD(aDbf, { "dt_obito", "D", 8, 0 })
		AADD(aDbf, { "coufinf", "C", 2, 0 })
DBCREATE("c:\sinanftp\tmp\chik\chikx", aDbf)
endif

if HB_ArgV( 1 ) = "deng" 
@ 12,1 say "Anexando os arquivos baixados no arquivo dengx.dbf"
run ('c:\sinanftp\exe\escritor "Anexando os arquivos baixados no arquivo dengx.dbf..."')
endif

if HB_ArgV( 1 ) = "chik" 
@ 12,1 say "Anexando os arquivos baixados no arquivo chikx.dbf"
run ('c:\sinanftp\exe\escritor "Anexando os arquivos baixados no arquivo chikx.dbf..."')
endif

IF nLen > 0 // coloca em um array os arquivos dbf descompactados no script 'unzipping'.
   aName := Array( nLen ) 
   if HB_ArgV( 1 ) = "deng"
   ADir( "c:\sinanftp\tmp\deng\DENGON*.dbf", aName)
   endif
   if HB_ArgV( 1 ) = "chik"
   ADir( "c:\sinanftp\tmp\chik\CHIKON*.dbf", aName)
   endif
   
   FOR tmp := 1 TO nLen
   
   * seleciona no array criado anteriormente, o arquivo que será anexado.
   if HB_ArgV( 1 ) = "deng"
   cFile = "c:\sinanftp\tmp\deng\"+aName[tmp]
   endif
   if HB_ArgV( 1 ) = "chik"
   cFile = "c:\sinanftp\tmp\chik\"+aName[tmp]
   endif
   
   @ nPos, 1 say (aName [ tmp ]) + "-----" + cFile

* Um a um os arquivos descompactados são anexados no arquivo que foi criado: dengx.dbf.
if HB_ArgV( 1 ) = "deng"
use "c:\sinanftp\tmp\deng\dengx"
append from (cFile) fields nu_notific,dt_notific,nu_ano,id_mn_resi,nm_bairro,nm_logrado,;
dt_digita,nm_complem,nu_cep,nu_numero,dt_nasc
close all
endif

* Um a um os arquivos descompactados são anexados no arquivo que foi criado: chikx.dbf. 
if HB_ArgV( 1 ) = "chik"
use "c:\sinanftp\tmp\chik\chikx"
append from (cFile) fields nu_notific, dt_sin_pri, sem_pri, id_mn_resi, classi_fin,	dt_obito, coufinf
close all
endif

nPos = nPos + 1
   
NEXT
ENDIF

* Após a anexação dos registros, verifica se existem registros no arquivo dengx.dbf
if HB_ArgV( 1 ) = "deng"
use "c:\sinanftp\tmp\deng\dengx.dbf"
if reccount()>0
@ nPos,1 say "Identificado registros dentro da tabela dengx.dbf."
run ('c:\sinanftp\exe\escritor "Identificado registros dentro da tabela dengx.dbf..."')
@ nPos+1, 1 say "Renomeando arquivo dengx.dbf..."
run ('c:\sinanftp\exe\escritor "Renomeando arquivo dengx.dbf..."')
close all
rename "c:\sinanftp\tmp\deng\dengx.dbf" to "c:\sinanftp\tmp\deng\dengon.dbf"
if (File( 'c:\SinanFTP\tmp\deng\dengon.dbf' ) = .T.)
@ nPos+2, 1 say "Renomeado arquivo dengx.dbf para dengon.dbf..."
run ('c:\sinanftp\exe\escritor "Renomeado arquivo dengx.dbf para dengon.dbf..."')
endif
@ nPos+3,1 say "Finalizando o script."
run ('c:\sinanftp\exe\escritor "Finalizando o script."')
else
@ nPos,1 say "Nao foi identificado registros dentro da tabela dengx.dbf. O processo falhou."
@ nPos+1, 1 say "Finalizando o script..."
run ('c:\sinanftp\exe\escritor "Nao foi identificado registros dentro da tabela dengx.dbf. O processo falhou."')
run ('c:\sinanftp\exe\escritor "Finalizando o script...."')
endif
endif

* Após a anexação dos registros, verifica se existem registros no arquivo chikx.dbf
if HB_ArgV( 1 ) = "chik"
use "c:\sinanftp\tmp\chik\chikx.dbf"
if reccount()>0
@ nPos,1 say "Identificado registros dentro da tabela chikx.dbf."
run ('c:\sinanftp\exe\escritor "Identificado registros dentro da tabela chikx.dbf..."')
@ nPos+1, 1 say "Renomeando arquivo chikx.dbf..."
run ('c:\sinanftp\exe\escritor "Renomeando arquivo chikx.dbf..."')
close all
rename "c:\sinanftp\tmp\chik\chikx.dbf" to "c:\sinanftp\tmp\chik\chikon.dbf"
if (File( 'c:\SinanFTP\tmp\chik\chikon.dbf' ) = .T.)
@ nPos+2, 1 say "Renomeado arquivo chikx.dbf para chikon.dbf..."
run ('c:\sinanftp\exe\escritor "Renomeado arquivo chikx.dbf para chikon.dbf..."')
endif
@ nPos+3,1 say "Finalizando o script."
run ('c:\sinanftp\exe\escritor "Finalizando o script."')
else
@ nPos,1 say "Nao foi identificado registros dentro da tabela chikx.dbf. O processo falhou."
@ nPos+1, 1 say "Finalizando o script..."
run ('c:\sinanftp\exe\escritor "Nao foi identificado registros dentro da tabela chikx.dbf. O processo falhou."')
run ('c:\sinanftp\exe\escritor "Finalizando o script...."')
endif
endif

RETURN