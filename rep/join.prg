function Main()

* Programa:join.prg - 27/01/2018 - versão 1.0 - CSIS Software.
* Desenvolvido em Harbour 3.0.0.
* Compilado no Harbour Make (hbmk2) versão 3.0.0.
* ============================================================
* Compara os registros dos arquivos solicitacoes.dbf e totalsol.dbf. Se houver numeros de solicitacoes coincidentes,
* copia para o arquivo totalsol.dbf, os campos "tipo" e "ano" extraidos do arquivo solicitacoes.dbf.
* Ao final do processo, marca todos os regitros do campo "download" como "N", indicando que nenhum "download" foi realizado ainda.

* Variáveis públicas auxiliares.
PUBLIC cItem1 := ""
PUBLIC cItem2 := ""
PUBLIC cItem3 := ""
PUBLIC nVez := 1
PUBLIC nRecs := 0

* Compara os registros dos arquivos solicitacoes.dbf e totalsol.dbf. Se houver numeros de solicitacoes coincidentes,
* copia para o arquivo totalsol.dbf, os campos "tipo" e "ano" extraidos do arquivo solicitacoes.dbf.
use "c:\SinanFTP\auxx\solicitacoes.dbf"
nRecs = reccount()
goto top
for n :=1 to nRecs
goto n
cItem1 = alltrim(numsol)
cItem2 = alltrim(tipo)
cItem3 = alltrim(ano)

use "c:\SinanFTP\auxx\totalsol.dbf"
locate for alltrim(filename) = cItem1
if found() = .T.
goto recno()
replace tipo with cItem2
replace ano with cItem3
endif

use "c:\SinanFTP\auxx\solicitacoes.dbf"

next n

* Marca todos os regitros do campo "download" como "N", indicando que nenhum "download" foi realizado ainda.
use "c:\SinanFTP\auxx\totalsol.dbf"
goto top
do while .not. eof()
replace download with alltrim("N")
skip
enddo
close

return nil