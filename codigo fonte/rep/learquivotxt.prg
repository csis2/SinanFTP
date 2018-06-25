function Main()

* desenvolvido em Harbour versão 3.0.0.
* compilado em Harbour Make (hbmk2) versão 3.0.0.
* compilado como: hbmk2 learquivotxt.prg hbct.hbc
* Learquivotxt.prg - 25/01/2018 - versão 1.0. - CSIS Software.
* Lê um arquivo de texto da tela do SINAN Online e extrai o número da solicitação de arquivo DBF.

#include "fileio.ch" // Importa biblioteca de funções de entrada e saída de dados.

* Lista das variáveis públicas para o argumento 'solic'.
PUBLIC cStr := "" // variável auxiliar.
PUBLIC cStr2 := "" // variável auxiliar.
PUBLIC cStr3 := "" // variável auxiliar.
PUBLIC cNumSol := "" // variável que conterá o número da solicitação.
PUBLIC cTipo := "" // variável que conterá o tipo de agravo solicitação.
PUBLIC cAno := "" // variável que conterá o ano da data inicial e data final solicitado no formulário de solicitação.

* Lista das variáveis públicas para o argumento 'consul'.

PUBLIC nPos := 0
PUBLIC nPos2 := 0
PUBLIC cVar1 := ""
PUBLIC cVar2 := ""
PUBLIC cVar3 := ""
PUBLIC cVar4 := ""
PUBLIC nLoop := 1

* Verifica se os argumentos são válidos. 
if HB_ArgV( 1 ) <> "solic" .and. HB_ArgV( 1 ) <> "consul"
? "Esses parametros não são válidos."
__Quit()
endif

if HB_ArgV( 1 ) = "solic" // instruções para o argumento de valor "solic".
* Cria uma tabela DBF que registrará o conteúdo do arquivo "temptext0.txt" linha a linha.
aDbf := {}
        AADD(aDbf, { "registro", "C", 150, 0 })
        DBCREATE("c:\SinanFTP\auxx\base1", aDbf)

* Coloca o conteúdo do arquivo "temptext0.txt" dentro do arquivo "base1.dbf".
use "c:\SinanFTP\auxx\base1.dbf"
append from "c:\SinanFTP\auxx\temptext0.txt" delimited with "\r\n"
* posiciona o ponteiro para o início do arquivo e apaga registros que estiverem vazios.
goto top
delete for empty(registro) = .T.
pack

* Procura pela substring "efetuada". O registro com essa substring é que está o número da solicitação.
goto top
locate for substr(registro,13,8)="efetuada"
if Found() = .T. // Substring achada. Remove todos os caracteres do registro e deixa apenas o número da solicitação.
goto Recno()
cStr := alltrim(registro)
cStr2=rangerem( 0, 47, cStr )
cStr3=rangerem( 58, 255, cStr2 )
cNumSol = alltrim(cStr3) // Armazena o número da solicitação na variável "cNumSol".
endif

* Exclui os registros do arquivo "base1.dbf" para próximo uso.
use "c:\SinanFTP\auxx\base1.dbf"
zap
* Coloca o conteúdo do arquivo "tempsolicit.txt" dentro do arquivo "base1.dbf". 
append from "c:\SinanFTP\auxx\tempsolicit.txt" delimited with "\r\n"
* Exclui registros vazios.
goto top
delete for empty(registro) = .T.
pack
* Coloca o conteúdo dos registros nas variáveis correspondentes.
goto top
cTipo = alltrim(registro) // variável com o tipo do agravo.
skip
cAno = alltrim(registro) // variável com o ano da solicitação.

* Procura no diretório o arquivo "solicitacoes.dbf"
if FILE("c:\SinanFTP\auxx\solicitacoes.dbf") = .F. // se não encontrar, cria o arquivo.
    *Cria uma tabela DBF (caso esta não exista) que registrará as três variáveis encontradas.
	aDbf := {}
	AADD(aDbf, { "numsol", "C", 10, 0 })
	AADD(aDbf, { "tipo", "C", 8, 0 })
	AADD(aDbf, { "ano", "C", 4, 0 })
	DBCREATE("c:\SinanFTP\auxx\solicitacoes", aDbf)
endif

* Transfere os valores das variáveis para os campos do arquivo solicitacoes.dbf.
use "c:\SinanFTP\auxx\solicitacoes.dbf"
goto top
append blank
replace numsol with cNumSol
replace tipo with cTipo
replace ano with cAno
close

endif ; finaliza as instruções relativas ao primeiro argumento.

if HB_ArgV( 1 ) = "consul" // instruções para o argumento de valor "consul".

* Cria uma tabela DBF que registrará o conteúdo do arquivo "temptext1.txt" linha a linha.
aDbf := {}
        AADD(aDbf, { "registro", "C", 150, 0 })
		DBCREATE("c:\SinanFTP\auxx\base2", aDbf)
	
* Coloca o conteúdo do arquivo "temptext1.txt" dentro do arquivo "base2.dbf".	
use "c:\SinanFTP\auxx\base2.dbf"
append from "c:\SinanFTP\auxx\temptext1.txt" delimited with "\r\n"
* posiciona o ponteiro para o início do arquivo e apaga registros que estiverem vazios.
goto top
delete for empty(registro) = .T.
pack

* Procura pela string "link". Após essa string, surgem os registros das solicitações.
goto top
locate for registro="Link"
if Found()=.T.
nPos := recno()
goto nPos

* Exclui os registros irrelevantes;
goto top 
delete for recno()<=nPos while .not. eof()
pack
endif
* Procura pela string "suporte a sistemas". Vai servir de referência para exclusão de mais registros irrelevantes.
locate for registro="Suporte a sistemas"
if Found()=.T.
nPos2 := recno()
goto nPos2
goto top 
delete for recno()>=nPos2 while .not. eof()
pack
endif

* Cria uma tabela DBF contendo todas as requisições de arquivos solicitadas e outras informações.
aDbf := {}
        AADD(aDbf, { "filename", "C", 10, 0 })
		AADD(aDbf, { "registros", "C", 12, 0 })
		AADD(aDbf, { "tipo", "C", 4, 0 })
		AADD(aDbf, { "ano", "C", 4, 0 })
		AADD(aDbf, { "status", "C", 30, 0 })
		AADD(aDbf, { "link", "C", 30, 0 })
		AADD(aDbf, { "download", "C", 1, 0 })
		DBCREATE("c:\SinanFTP\auxx\totalsol", aDbf) //base3

* Ordena os dados contidos em "base2.dbf" e distribui os registros nos campos da tabela "totalsol.dbf".		
for i :=1 to 50
use "c:\SinanFTP\auxx\base2"
goto nLoop
cVar1 := registro
skip
cVar2 := registro
skip
cVar3 := registro
skip
cVar4 := registro
if cVar4 <> "Baixar arquivo DBF"
cVar4 := "Link nao disponivel"
endif
skip
nLoop := recno()
use "c:\SinanFTP\auxx\totalsol.dbf"
append blank
replace filename with cVar1
replace registros with cVar2
replace status with cVar3
replace link with cVar4
close
next i

* Por último, exclui registros vazios no arquivo "totalsol.dbf".
use "c:\SinanFTP\auxx\totalsol.dbf"
delete for empty (filename)=.T.
pack
close

endif ; finaliza as instruções relativas ao segundo argumento.

return nil 