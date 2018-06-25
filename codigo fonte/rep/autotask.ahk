#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; autotask versão 1.0 - CSIS Software - 21/04/2018.
; Gera novas tarefas no agendador caso os downloads realizados no baixaDBFx falhem.

#include tf.ahk ; biblioteca para manipulação de texto.
; bibliotecas para criptografia e descriptografia de arquivos.
#Include Crypt.ahk
#Include CryptConst.ahk
#Include CryptFoos.ahk

; variaveis globais
GLOBAL nFind := 0
GLOBAL cTimeExtra := ""
GLOBAL nTempo := 0
GLOBAL cAutoDominio := ""
GLOBAL cAutoLogin := ""
GLOBAL cAutoSenha := ""
GLOBAL cDomLog := ""
GLOBAL cArguiX := ""

file := FileOpen("c:\SinanFTP\log\SinanFTP.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Agendando novo processo, pois o atual falhou . `r`n"
file.Write(TestString)
file.Close()
sleep, 3000

; Lê no arquivo de configuração se há permissão para trabalhar com acesso ao PC usando login e senha.
IniRead, OutputVar33, c:\SinanFTP\set\SetSinanFTP2.ini, ACESSO PC, Usa?
if (OutputVar33 <> "true")
{
file := FileOpen("c:\SinanFTP\log\SinanFTP.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Nao foi concedida permissao para acessar o PC no programa 'config.exe'. `r`n"
file.Write(TestString)
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString2 := TimeString "------- O agendamento de um novo processo falhou. `r`n"
file.Write(TestString2)
file.Close()
sleep, 3000
ExitApp
}

; Lê o login e a senha no arquivo de configuração e os coloca em variáveis.
if (OutputVar33 = "true")
{
; Descriptografa a senha de acesso ao PC armazenada no arquivo SetSinanFTP2.
IniRead, OutputVar, c:\SinanFTP\set\SetSinanFTP2.ini, ACESSO PC, Pass
decrypted_string := Crypt.Encrypt.StrDecrypt(OutputVar,"B65C8825FB47B72A8A15EF85E48C0C8BD5C50D51",5,1)
cAutoSenha = % decrypted_string

; Le o arquivo de configuração SetSinanFTP e procura o valor do dominio e login do PC.
IniRead, OutputVar10, c:\SinanFTP\set\SetSinanFTP2.ini, ACESSO PC, Domain
cAutoDominio = %OutputVar10%
IniRead, OutputVar11, c:\SinanFTP\set\SetSinanFTP2.ini, ACESSO PC, Login
cAutoLogin = %OutputVar11%
cDomLog = %cAutoDominio%\%cAutoLogin%
}

; Le o arquivo de configuração SetSinanFTP e procura o valor de tempo armazenado na seção TEMPO2.
IniRead, OutputVar7, c:\SinanFTP\set\SetSinanFTP.ini, TEMPO2, Tempo
nTempo = %OutputVar7%

; armazena na variável cTimeExtra o horário da nova tarefa a ser criada.
var:=A_Now
EnvAdd, Var, %nTempo% ,Minits ; adiciona x minutos na hora atual. O valor acrescentado depende do valor
                              ; estipulado na seção TEMPO2 do arquivo de configuração SetSinanFTP.
FormatTime, var,%var%, HH:mm tt ; formata a novo horario.
cTimeExtra = %Var%

cArguiX = %1% ; Armazena o argumento na variavel global 'argui'.

; *********************************************************************************************************

if (cArguiX = "deng") ; se o argumento for esse, cria tarefa relativa ao agravo Dengue.
{
Gosub, DengLabel
Sleep 5000
ExitApp
}

if (cArguiX = "chik") ; se o argumento for esse, cria tarefa relativa ao agravo Chikungunya.
{
Gosub, ChikLabel 
Sleep 5000
ExitApp
}

; Label para desmarcar as seleções feitas.
DengLabel:

; Gera um arquivo texto com as tarefas agendadas no Windows e procura nesse arquivo uma tarefa específica.
FileDelete, C:\temp\tasklist.txt
Sleep 5000
Run, %ComSpec% /c schtasks.exe /query /fo CSV|Findstr /v "^\"TaskName\".*$">c:\temp\TaskList.txt,,hide
Sleep 5000
nFind = % TF_Find("c:\temp\TaskList.txt", "", "", "\SinanFTP_autotask1") 

if (nFind = 0)
{
if (cAutoDominio <> "")
{
Run, schtasks /create /tn SinanFTP_autotask1 /tr "c:\sinanFTP\bat\run.bat" /sc daily /st %cTimeExtra% /ru %cDomLog% /rp %cAutoSenha%, ,hide
ExitApp
} else {
Run, schtasks /create /tn SinanFTP_autotask1 /tr "c:\sinanFTP\bat\run.bat" /sc daily /st %cTimeExtra%, ,hide
ExitApp
}
}

nFind = % TF_Find("c:\temp\TaskList.txt", "", "", "\SinanFTP_autotask2") 

if (nFind = 0)
{

if (cAutoDominio <> "")
{
Run, schtasks /create /tn SinanFTP_autotask2 /tr "c:\sinanFTP\bat\run.bat" /sc daily /st %cTimeExtra% /ru %cDomLog% /rp %cAutoSenha%, ,hide
ExitApp
} else {
Run, schtasks /create /tn SinanFTP_autotask2 /tr "c:\sinanFTP\bat\run.bat" /sc daily /st %cTimeExtra%, ,hide
ExitApp
}
}

nFind = % TF_Find("c:\temp\TaskList.txt", "", "", "\SinanFTP_autotask3") 

if (nFind = 0)
{

if (cAutoDominio <> "")
{
Run, schtasks /create /tn SinanFTP_autotask3 /tr "c:\sinanFTP\bat\run.bat" /sc daily /st %cTimeExtra% /ru %cDomLog% /rp %cAutoSenha%, ,hide
ExitApp
} else {
Run, schtasks /create /tn SinanFTP_autotask3 /tr "c:\sinanFTP\bat\run.bat" /sc daily /st %cTimeExtra%, ,hide
ExitApp
}
}

nFind = % TF_Find("c:\temp\TaskList.txt", "", "", "\SinanFTP_autotask4") 

if (nFind = 0)
{

if (cAutoDominio <> "")
{
Run, schtasks /create /tn SinanFTP_autotask4 /tr "c:\sinanFTP\bat\run.bat" /sc daily /st %cTimeExtra% /ru %cDomLog% /rp %cAutoSenha%, ,hide
ExitApp
} else {
Run, schtasks /create /tn SinanFTP_autotask4 /tr "c:\sinanFTP\bat\run.bat" /sc daily /st %cTimeExtra%, ,hide
ExitApp
}
}

nFind = % TF_Find("c:\temp\TaskList.txt", "", "", "\SinanFTP_autotask5") 

if (nFind = 0)
{

if (cAutoDominio <> "")
{
Run, schtasks /create /tn SinanFTP_autotask5 /tr "c:\sinanFTP\bat\run.bat" /sc daily /st %cTimeExtra% /ru %cDomLog% /rp %cAutoSenha%, ,hide
ExitApp
} else {
Run, schtasks /create /tn SinanFTP_autotask5 /tr "c:\sinanFTP\bat\run.bat" /sc daily /st %cTimeExtra%, ,hide
ExitApp
}
}

nFind = % TF_Find("c:\temp\TaskList.txt", "", "", "\SinanFTP_autotask5") 

if (nFind <> 0) 
{
Run, schtasks /delete /TN "SinanFTP_autotask1" /f, ,hide
Run, schtasks /delete /TN "SinanFTP_autotask2" /f, ,hide
Run, schtasks /delete /TN "SinanFTP_autotask3" /f, ,hide
Run, schtasks /delete /TN "SinanFTP_autotask4" /f, ,hide
Run, schtasks /delete /TN "SinanFTP_autotask5" /f, ,hide
ExitApp
}

return

; Label para desmarcar as seleções feitas.
ChikLabel:

; Gera um arquivo texto com as tarefas agendadas no Windows e procura nesse arquivo uma tarefa específica.
FileDelete, C:\temp\tasklist.txt
Sleep 5000
Run, %ComSpec% /c schtasks.exe /query /fo CSV|Findstr /v "^\"TaskName\".*$">c:\temp\TaskList.txt,,hide
Sleep 5000
nFind = % TF_Find("c:\temp\TaskList.txt", "", "", "\SinanFTP_autotask1") 

if (nFind = 0)
{
if (cAutoDominio <> "")
{
Run, schtasks /create /tn SinanFTP_autotask1 /tr "c:\sinanFTP\bat\run2.bat" /sc daily /st %cTimeExtra% /ru %cDomLog% /rp %cAutoSenha%, ,hide
ExitApp
} else {
Run, schtasks /create /tn SinanFTP_autotask1 /tr "c:\sinanFTP\bat\run2.bat" /sc daily /st %cTimeExtra%, ,hide
ExitApp
}
}

nFind = % TF_Find("c:\temp\TaskList.txt", "", "", "\SinanFTP_autotask2") 

if (nFind = 0)
{

if (cAutoDominio <> "")
{
Run, schtasks /create /tn SinanFTP_autotask2 /tr "c:\sinanFTP\bat\run2.bat" /sc daily /st %cTimeExtra% /ru %cDomLog% /rp %cAutoSenha%, ,hide
ExitApp
} else {
Run, schtasks /create /tn SinanFTP_autotask2 /tr "c:\sinanFTP\bat\run2.bat" /sc daily /st %cTimeExtra%, ,hide
ExitApp
}
}

nFind = % TF_Find("c:\temp\TaskList.txt", "", "", "\SinanFTP_autotask3") 

if (nFind = 0)
{

if (cAutoDominio <> "")
{
Run, schtasks /create /tn SinanFTP_autotask3 /tr "c:\sinanFTP\bat\run2.bat" /sc daily /st %cTimeExtra% /ru %cDomLog% /rp %cAutoSenha%, ,hide
ExitApp
} else {
Run, schtasks /create /tn SinanFTP_autotask3 /tr "c:\sinanFTP\bat\run2.bat" /sc daily /st %cTimeExtra%, ,hide
ExitApp
}
}

nFind = % TF_Find("c:\temp\TaskList.txt", "", "", "\SinanFTP_autotask4") 

if (nFind = 0)
{

if (cAutoDominio <> "")
{
Run, schtasks /create /tn SinanFTP_autotask4 /tr "c:\sinanFTP\bat\run2.bat" /sc daily /st %cTimeExtra% /ru %cDomLog% /rp %cAutoSenha%, ,hide
ExitApp
} else {
Run, schtasks /create /tn SinanFTP_autotask4 /tr "c:\sinanFTP\bat\run2.bat" /sc daily /st %cTimeExtra%, ,hide
ExitApp
}
}

nFind = % TF_Find("c:\temp\TaskList.txt", "", "", "\SinanFTP_autotask5") 

if (nFind = 0)
{

if (cAutoDominio <> "")
{
Run, schtasks /create /tn SinanFTP_autotask5 /tr "c:\sinanFTP\bat\run2.bat" /sc daily /st %cTimeExtra% /ru %cDomLog% /rp %cAutoSenha%, ,hide
ExitApp
} else {
Run, schtasks /create /tn SinanFTP_autotask5 /tr "c:\sinanFTP\bat\run2.bat" /sc daily /st %cTimeExtra%, ,hide
ExitApp
}
}

nFind = % TF_Find("c:\temp\TaskList.txt", "", "", "\SinanFTP_autotask5") 

if (nFind <> 0) 
{
Run, schtasks /delete /TN "SinanFTP_autotask1" /f, ,hide
Run, schtasks /delete /TN "SinanFTP_autotask2" /f, ,hide
Run, schtasks /delete /TN "SinanFTP_autotask3" /f, ,hide
Run, schtasks /delete /TN "SinanFTP_autotask4" /f, ,hide
Run, schtasks /delete /TN "SinanFTP_autotask5" /f, ,hide
ExitApp
}

return