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
@ 2,3 say " Merge versao 1.1                                      "
@ 3,3 say " Uniao de arquivos DENGON.DBF.                         "
@ 4,3 say " CSIS Software                                         "
@ 5,3 say " Fevereiro/2018                                        "

* Verifica se os argumentos são válidos. 
if HB_ArgV( 1 ) <> "anoatual" .and. HB_ArgV( 1 ) <> "anoatual+passado"
? "Esses parametros não são válidos."
run ('c:\sinanftp\exe\escritor "Os parametros para rodar o arquivo merge.exe nao sao validos..."')
run ('c:\sinanftp\exe\escritor "Finalizando merge.exe ..."')
__Quit()
endif

if HB_ArgV( 1 ) = "anoatual" // instruções para o argumento de valor "anoatual".

* Registra na tabela de log as etapas realizadas no arquivo merge.exe.
run ('c:\sinanftp\exe\escritor "Roda o arquivo merge.exe para unificar os arquivos dbf baixados..."')

* Verifica se o arquivo necessario está presente e no lugar certo.
if FILE("c:\sinanftp\tmp\deng\1\dengue1DBF.dbf") = .F.
run ('c:\sinanftp\exe\escritor "Arquivo dengue1DBF.dbf não foi encontrado..."')
run ('c:\sinanftp\exe\escritor "Finalizando merge.exe ..."')
quit
endif

set color to g+/n
run ('c:\sinanftp\exe\escritor "Criando a estrutura da tabela denguex.dbf..."')
@ 7,1 say "Criando a estrutura da tabela denguex.dbf..."
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
DBCREATE("c:\sinanftp\tmp\deng\denguex", aDbf)

@ 8,1 say "Feito."
@ 9,1 say "Transferindo os registros para a nova tabela denguex.dbf..."
run ('c:\sinanftp\exe\escritor "Transferindo os registros para a tabela denguex.dbf..."')
use "c:\sinanftp\tmp\deng\1\dengue1DBF.dbf"
copy fields nu_notific,dt_notific,nu_ano,id_mn_resi,nm_bairro,nm_logrado,;
     dt_digita,nm_complem,nu_cep,nu_numero,dt_nasc to c:\sinanftp\tmp\deng\denguex.dbf
@ 10,1 say "Feito."

@ 11,1 say "Renomeando arquivo..."
run ('c:\sinanftp\exe\escritor "Renomenado arquivo principal para dengon.dbf..."')
close all

run ("rename c:\sinanftp\tmp\deng\denguex.dbf dengon.dbf")

run ('c:\sinanftp\exe\escritor "Fim dos procedimentos do arquivo merge.exe..."')

endif

if HB_ArgV( 1 ) = "anoatual+passado" // instruções para o argumento de valor "anoatual+passado".

* Registra na tabela de log as etapas realizadas no arquivo merge.exe.
run ('c:\sinanftp\exe\escritor "Roda o arquivo merge.exe para unificar os arquivos dbf baixados..."')

* Verifica se os arquivos necessarios estão presentes e no lugar certo.
if FILE("c:\sinanftp\tmp\deng\1\dengue1DBF.dbf") = .F.
run ('c:\sinanftp\exe\escritor "Arquivo dengue1DBF.dbf não foi encontrado..."')
run ('c:\sinanftp\exe\escritor "Finalizando merge.exe ..."')
quit
endif
if FILE("c:\sinanftp\tmp\deng\2\dengue2DBF.dbf") = .F.
run ('c:\sinanftp\exe\escritor "Arquivo dengue2DBF.dbf não foi encontrado..."')
run ('c:\sinanftp\exe\escritor "Finalizando merge.exe ..."')
quit
endif

set color to g+/n
run ('c:\sinanftp\exe\escritor "Criando a estrutura da tabela denguex.dbf..."')
@ 9,1 say "Criando a estrutura da tabela denguex.dbf..."
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
DBCREATE("c:\sinanftp\tmp\deng\denguex", aDbf)

@ 10,1 say "Feito."
@ 11,1 say "Transferindo os registros para a tabela denguex.dbf..."
run ('c:\sinanftp\exe\escritor "Transferindo os registros para a tabela denguex.dbf..."')
use "c:\sinanftp\tmp\deng\1\dengue1DBF.dbf"
copy fields nu_notific,dt_notific,nu_ano,id_mn_resi,nm_bairro,nm_logrado,;
     dt_digita,nm_complem,nu_cep,nu_numero,dt_nasc to c:\sinanftp\tmp\deng\denguex.dbf
@ 12,1 say "Feito."

run ('c:\sinanftp\exe\escritor "Criando a estrutura da tabela denguew.dbf..."')
@ 13,1 say "Criando a estrutura da tabela denguew.dbf..."
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
DBCREATE("c:\sinanftp\tmp\deng\denguew", aDbf)

@ 14,1 say "Feito."
@ 15,1 say "Transferindo os registros para a tabela denguew.dbf..."
run ('c:\sinanftp\exe\escritor "Transferindo os registros para a tabela denguew.dbf..."')
use "c:\sinanftp\tmp\deng\2\dengue2DBF.dbf"
copy fields nu_notific,dt_notific,nu_ano,id_mn_resi,nm_bairro,nm_logrado,;
dt_digita,nm_complem,nu_cep,nu_numero,dt_nasc to c:\sinanftp\tmp\deng\denguew.dbf
@ 16,1 say "Feito."

@ 17,1 say "Unindo as duas tabelas..."
run ('c:\sinanftp\exe\escritor "Unindo as duas tabelas denguex.dbf e denguew.dbf..."')
use "c:\sinanftp\tmp\deng\denguex.dbf"
append from "c:\sinanftp\tmp\deng\denguew.dbf"
@ 18,1 say "Feito..."
@ 19,1 say "Renomeando arquivos..."
run ('c:\sinanftp\exe\escritor "Renomenado arquivo principal e apagando arquivo excedente..."')
close all

run ("rename c:\sinanftp\tmp\deng\denguex.dbf dengon.dbf")

@ 20,1 say "Excluido arquivo."

run("erase c:\sinanftp\tmp\deng\denguew.dbf")

run ('c:\sinanftp\exe\escritor "Fim dos procedimentos do arquivo merge.exe..."')

endif

RETURN