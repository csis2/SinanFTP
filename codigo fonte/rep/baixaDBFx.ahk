#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#WinActivateForce
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; Script BaixaDBFx versão 1.3 - CSIS Software.
; 28/12/2017
; Escrito em AutoHotkey versão 1.1.26.01

; importando bibliotecas de criptografia;
#Include Crypt.ahk
#Include CryptConst.ahk
#Include CryptFoos.ahk

; ajuste de ambiente
DetectHiddenWindows, off
DetectHiddenText, on
CoordMode, Screen  ;
SetTitleMatchMode 2
SetTitleMatchMode Slow  

; exclusão de arquivos
FileDelete, c:\SinanFTP\auxx\*.*
FileDelete, c:\SinanFTP\log\SinanFTP.log
FileDelete, c:\SinanFTP\tmp\deng\*.*
FileDelete, c:\SinanFTP\tmp\chik\*.*
FileDelete, c:\SinanFTP\tmp\ftp\*.*

sleep, 5000
; Lista de variáveis globais.
GLOBAL argui := "" ; armazena o argumento escolhido pelo usuário.
GLOBAL cAnoAtual := "" ; define o ano atual com base na data do OS.
GLOBAL cAnoPassado := "" ; define o ano anterior com base na data do OS.
GLOBAL cAno := "" ; variavel auxiliar na contagem de ano.
GLOBAL nLooping := 0 ; Define quantas vezes o formulário será preenchido.
GLOBAL cDataIni := "" ; Variável que armazena a data do campo data inicial.
GLOBAL cDataFin := "" ; Variável que armazena a data do campo data final.
GLOBAL cFileNameIs := "" ; Variável que armazena o número da solicitação do arquivo que será baixado.
GLOBAL cFileNameFull := "" ; Variável que armazena o nome completo dos arquivos para download, inclusive a extensão.
GLOBAL cPositionIs := "" ; Variável que armazena qual é a posição desse arquivo.
GLOBAL nX := 0 ; guarda a coordenada X que mostra a posição de um link para baixar um arquivo.
GLOBAL nY := 0 ; guarda a coordenada Y que mostra a posição de um link para baixar um arquivo.
GLOBAL cLogin := "" ; guarda o login para acessar o SINAN Online.
GLOBAL cSenha := "" ; guarda a senha para acessar o SINAN Online.
GLOBAL nTempo := 0 ; armazena o tempo de espera para o download.
GLOBAL cRegistros := "" ; registra o número de registros do arquivo que será baixado.
GLOBAL cStatus := "" ; registra o status do arquivo que será baixado.
GLOBAL cIndice := "" ; registra o número da iteração do último loop.
GLOBAL cAnosDeng := "" ; registra os anos em que serão gerados os arquivos dbf para Dengue.
GLOBAL cAnosChik := "" ; registra os anos em que serão gerados os arquivos dbf para Chikungunya.
GLOBAL nIndice := 0 ; registra a iteração atual do loop.

; Lê no arquivo de configuração se há login e senha para acessar o Sinan Online.
IniRead, OutputVar45, c:\SinanFTP\set\SetSinanFTP2.ini, SINAN ONLINE, Login
IniRead, OutputVar46, c:\SinanFTP\set\SetSinanFTP2.ini, SINAN ONLINE, Pass
if (OutputVar45 = "")
{
msgbox Você não forneceu o login para acessar o SINAN Online.
msgbox Acesse o programa "config.exe" e faça o ajuste necessário.
ExitApp
}
if (OutputVar46 = "")
{
msgbox Você não forneceu a senha para acessar o SINAN Online.
msgbox Acesse o programa "config.exe" e faça o ajuste necessário.
ExitApp
}

; Lê no arquivo de configuração se há permissão para trabalhar com acesso a rede proxy.
IniRead, OutputVar33, c:\SinanFTP\set\SetSinanFTP2.ini, PROXY, Usa?
if (OutputVar33 = "true")
{
RunWait, auth_trap.exe, c:\SinanFTP\exe ; Autentica o acesso a rede proxy caso o pedido de autenticação apareça.
}

IfNotExist, c:\SinanFTP\set\SetSinanFTP.ini
{
msgbox O arquivo "SetSinanFTP.ini" que guarda configurações importantes para o funcionamento do SinanFTP não foi encontrado.
msgbox Acesse o arquivo "SetSinanFTP.ini" na subpasta "set" e faça o ajuste necessário.
ExitApp
}

IfNotExist, c:\SinanFTP\set\SetSinanFTP2.ini
{
msgbox O arquivo "SetSinanFTP2.ini" que guarda os dados de login e senha para acessar o SinanFTP não foi encontrado.
msgbox Acesse o programa "config.exe" e faça o ajuste necessário.
ExitApp
}

; Definições de ano.
; Armazena na variável cAno, o ano atual.
;FormatTime, TimeString, A_YYYY
;StringRight, OutputVar, TimeString, 4  
;cAno = %OutputVar%

; Testa se o script está rodando com argumento.
if 0 < 1  
{
    MsgBox, 16,,     Esse script requer que voce passe um argumento para que ele seja executado corretamente.
    ExitApp ; se o argumento não foi encontrado, finaliza o script.
}

; Verifica se os argumentos são válidos.
argui = %1% ; Armazena o argumento na variavel global 'argui'.
if (argui = "deng") ; nesse argumento, os dados extraídos serão referentes ao agravo Dengue.
{
IniRead, OutputVar62, c:\SinanFTP\set\SetSinanFTP.ini, ANOS DENGUE, Anos
if (OutputVar62 = "")
{
msgbox Você não forneceu o(s) ano(s) para a geração dos arquivos de Dengue.
msgbox Acesse o arquivo SetSinanFTP.ini e faça o ajuste necessário.
ExitApp
}
}

if (argui = "chik") ; se o argumento for esse, os dados extraídos serão referentes ao agravo Chikungunya.
{
IniRead, OutputVar63, c:\SinanFTP\set\SetSinanFTP.ini, ANOS CHIKUNGUNYA, Anos
if (OutputVar63 = "")
{
msgbox Você não forneceu o(s) ano(s) para a geração dos arquivos de Chikungunya.
msgbox Acesse o arquivo SetSinanFTP.ini e faça o ajuste necessário.
ExitApp
}
}

if (argui <> "deng" and argui <> "chik")
{
msgbox O argumento usado: %argui%, não é valido.
ExitApp ; se o argumento não foi validado, finaliza o script.
}

if (argui = "deng") ; indexa em um array os anos que o usuário escolheu para gerar os arquivos DBF, nesse caso, Dengue.
{
IniRead, OutputVar70, c:\SinanFTP\set\SetSinanFTP.ini, ANOS DENGUE, Anos
cAnosDeng = %OutputVar70%
deng_array := StrSplit(cAnosDeng, ",")
nLooping = % deng_array.Length() ; define quantas vezes o formulário será preenchido de acordo com a quant. de anos.
}

if (argui = "chik") ; indexa em um array os anos que o usuário escolheu para gerar os arquivos DBF, nesse caso, Chikungunya.
{
IniRead, OutputVar70, c:\SinanFTP\set\SetSinanFTP.ini, ANOS CHIKUNGUNYA, Anos
cAnosChik = %OutputVar70%
chik_array := StrSplit(cAnosChik, ",")
nLooping = % chik_array.Length() ; define quantas vezes o formulário será preenchido de acordo com a quant. de anos.
}

; Fecha os processos que estão utilizando o Firefox.
Process, close, firefox.exe

;inicialização do arquivo de log.
file := FileOpen("c:\SinanFTP\log\SinanFTP.log", "w")
file.Close()
file := FileOpen("c:\SinanFTP\log\SinanFTP.log", "a")
TestString := "************************************************************************************************************`r`n"
file.Write(TestString)
TestString := "*                                                                                                          *`r`n"
file.Write(TestString)
TestString := "*                                          Arquivo de log SinanFTP                                         *`r`n"
file.Write(TestString)
TestString := "*                                                                                                          *`r`n"
file.Write(TestString)
TestString := "************************************************************************************************************`r`n"
file.Write(TestString)

FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Começa o processo SinanFTP. `r`n"
file.Write(TestString)

FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Parametro escolhido:" argui ".`r`n"
file.Write(TestString)
file.Close()

Run, "http://www.saude.gov.br/sinan" ; Abre o navegador e acessa o site do SINAN Online.

Sleep 25000 ; aguarda 25 segundos pelas próximas instruções.

; gera o PID (process identifier) do Firefox e analisa se ele foi aberto pelo comando Run.
Process, exist, firefox.exe ;
NewPID = %ErrorLevel% 
if NewPID = 0
{
file := FileOpen("c:\SinanFTP\log\SinanFTP.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------O navegador Firefox não foi aberto. `r`n"
file.Write(TestString)
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Finalizando processo SinanFTP. `r`n"
file.Write(TestString)
file.Close()

Sleep 3000
RunWait, autotask.exe, c:\SinanFTP\exe, max ; como o processo falhou, agenda uma nova tarefa.
Sleep 3000
RunWait, log_close.bat, c:\SinanFTP\bat, max ; finaliza e renomeia o log.
Sleep 3000

ExitApp ; finaliza o script.
}
else
{
IfWinExist, ahk_pid %NewPID%
WinActivate
file := FileOpen("c:\SinanFTP\log\SinanFTP.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------O navegador Firefox foi aberto. `r`n"
file.Write(TestString)
file.Close()
}

if WinExist("SINAN") ; testa se o site do SINAN Online foi carregado no navegador.
{
file := FileOpen("c:\SinanFTP\log\SinanFTP.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Site do SINAN Online identificado. `r`n"
file.Write(TestString)
file.Close()
WinActivate
}

else 

{
file := FileOpen("c:\SinanFTP\log\SinanFTP.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Site do SINAN Online não foi identificado. `r`n"
file.Write(TestString)
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Finalizando processo SinanFTP. `r`n"
file.Write(TestString)
file.Close()

Sleep 3000
RunWait, autotask.exe, c:\SinanFTP\exe, max ; como o processo falhou, agenda uma nova tarefa.
Sleep 3000
RunWait, log_close.bat, c:\SinanFTP\bat, max ; finaliza e renomeia o log.
Sleep 3000

Process, close, firefox.exe
ExitApp ; finaliza o script.
}	

if WinExist("SINAN") ; Foca na janela do SINAN e maximiza a janela.
{
WinActivate
WinMaximize
file := FileOpen("c:\SinanFTP\log\SinanFTP.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Janela do Firefox maximizada. `r`n"
file.Write(TestString)
file.Close()
}

Sleep, 1000

;procura pelo botão "Entrar" no SINAN Online.
ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, c:\SinanFTP\img\entrar.bmp

if ErrorLevel = 2
{
file := FileOpen("c:\SinanFTP\log\SinanFTP.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Falha na identificação do botão 'Entrar'. `r`n"
file.Write(TestString)
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Finalizando processo SinanFTP. `r`n"
file.Write(TestString)
file.Close()

Sleep 3000
RunWait, autotask.exe, c:\SinanFTP\exe, max ; como o processo falhou, agenda uma nova tarefa.
Sleep 3000
RunWait, log_close.bat, c:\SinanFTP\bat, max ; finaliza e renomeia o log.
Sleep 3000

Process, close, firefox.exe

ExitApp ; finaliza o script.
}	

else if ErrorLevel = 1
{
file := FileOpen("c:\SinanFTP\log\SinanFTP.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------A imagem do botão 'Entrar' não foi identificada na tela. `r`n"
file.Write(TestString)
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Finalizando processo SinanFTP. `r`n"
file.Write(TestString)
file.Close()

Sleep 3000
RunWait, autotask.exe, c:\SinanFTP\exe, max ; como o processo falhou, agenda uma nova tarefa.
Sleep 3000
RunWait, log_close.bat, c:\SinanFTP\bat, max ; finaliza e renomeia o log.
Sleep 3000

Process, close, firefox.exe
ExitApp ; finaliza o script.
}	

else ; Botão Entrar identificado.

{
file := FileOpen("c:\SinanFTP\log\SinanFTP.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------O botão 'Entrar' foi identificado. `r`n"
file.Write(TestString)
file.Close()

; Lê o login e a senha no arquivo "SetSinanFTP2.ini" e os coloca em variáveis.
IniRead, OutputVar5, c:\SinanFTP\set\SetSinanFTP2.ini, SINAN ONLINE, Login
cLogin = %OutputVar5%
IniRead, OutputVar, c:\SinanFTP\set\SetSinanFTP2.ini, SINAN ONLINE, Pass
decrypted_string := Crypt.Encrypt.StrDecrypt(OutputVar,"B65C8825FB47B72A8A15EF85E48C0C8BD5C50D51",5,1)
cSenha = %decrypted_string%

; Procedimentos para preencher os campos "login" e "senha" do SINAN Online e clicar no botão "Entrar".
SendInput %cLogin%
Sleep, 2000
Send {TAB}
Sleep, 2000
SendInput %cSenha%
Sleep, 2000
MouseMove FoundX+50, FoundY+10 ;configuração ideal de click no botão.
sleep, 2000
MouseClick, left, FoundX+50, FoundY+10 ;configuração ideal de click no botão.

file := FileOpen("c:\SinanFTP\log\SinanFTP.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Inserido login e senha no formulário. Botão 'Entrar' clicado.`r`n"
file.Write(TestString)
file.Close()
}	

sleep, 7000

;procura pelo ícone "Principal" no SINAN Online para confirmar login.
ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, c:\SinanFTP\img\principal.bmp

if ErrorLevel = 2
{
file := FileOpen("c:\SinanFTP\log\SinanFTP.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Falha ao fazer login no SINAN Online. A página não carregou. `r`n"
file.Write(TestString)
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Finalizando processo SinanFTP. `r`n"
file.Write(TestString)
file.Close()

Sleep 3000
RunWait, autotask.exe, c:\SinanFTP\exe, max ; como o processo falhou, agenda uma nova tarefa.
Sleep 3000
RunWait, log_close.bat, c:\SinanFTP\bat, max ; finaliza e renomeia o log.
Sleep 3000

Process, close, firefox.exe
ExitApp ; finaliza o script.
}	
else if ErrorLevel = 1
{
file := FileOpen("c:\SinanFTP\log\SinanFTP.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Falha ao fazer login no SINAN Online. A página não carregou. `r`n"
file.Write(TestString)
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Finalizando processo SinanFTP. `r`n"
file.Write(TestString)
file.Close()

Sleep 3000
RunWait, autotask.exe, c:\SinanFTP\exe, max ; como o processo falhou, agenda uma nova tarefa.
Sleep 3000
RunWait, log_close.bat, c:\SinanFTP\bat, max ; finaliza e renomeia o log.
Sleep 3000

Process, close, firefox.exe
ExitApp ; finaliza o script.
}	

else ; Login no SINAN Online realizado com sucesso.

{
file := FileOpen("c:\SinanFTP\log\SinanFTP.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Login no SINAN Online realizado com sucesso. `r`n"
file.Write(TestString)
file.Close()
}	

; Inicio de um loop que define quantas vezes o formulário será preenchido em uma mesma sessão do SINAN Online.
Loop, %nLooping% ; A variável nLooping define quantas vezes o formulário será preenchido.
{
;procura pelo módulo "Exportação" no SINAN Online.
ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, c:\SinanFTP\img\export.bmp

if ErrorLevel = 2
{
file := FileOpen("c:\SinanFTP\log\SinanFTP.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Falha na identificação do módulo 'Exportação'. `r`n"
file.Write(TestString)
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Finalizando processo SinanFTP. `r`n"
file.Write(TestString)
file.Close()

Sleep 3000
RunWait, autotask.exe, c:\SinanFTP\exe, max ; como o processo falhou, agenda uma nova tarefa.
Sleep 3000
RunWait, log_close.bat, c:\SinanFTP\bat, max ; finaliza e renomeia o log.
Sleep 3000

Process, close, firefox.exe
ExitApp ; finaliza o script.
}	

else if ErrorLevel = 1
{
file := FileOpen("c:\SinanFTP\log\SinanFTP.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------O módulo 'Exportação' não foi identificado na tela. `r`n"
file.Write(TestString)
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Finalizando processo SinanFTP. `r`n"
file.Write(TestString)
file.Close()

Sleep 3000
RunWait, autotask.exe, c:\SinanFTP\exe, max ; como o processo falhou, agenda uma nova tarefa.
Sleep 3000
RunWait, log_close.bat, c:\SinanFTP\bat, max ; finaliza e renomeia o log.
Sleep 3000

Process, close, firefox.exe
ExitApp ; finaliza o script.
}	

else ; Módulo "exportação" identificado.

{
file := FileOpen("c:\SinanFTP\log\SinanFTP.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Módulo 'exportação' identificado. `r`n"
file.Write(TestString)
file.Close()
sleep, 3000

MouseMove FoundX+20, FoundY+5
sleep, 2000
MouseClick, left, FoundX+20, FoundY+5

file := FileOpen("c:\SinanFTP\log\SinanFTP.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Módulo 'exportação' foi clicado no menu suspenso. `r`n"
file.Write(TestString)
file.Close()
}	

if WinExist("SINAN") ; Foca na janela do SINAN.
{
WinActivate
}

sleep, 5000

;procura pelo item "Solicitar exportação de base de dados em DBF" no SINAN Online.
ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, c:\SinanFTP\img\BaseDBF.bmp

if ErrorLevel = 2
{
file := FileOpen("c:\SinanFTP\log\SinanFTP.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Falha na identificação do item 'exportar base de dados em DBF'. `r`n"
file.Write(TestString)
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Finalizando processo SinanFTP. `r`n"
file.Write(TestString)
file.Close()

Sleep 3000
RunWait, autotask.exe, c:\SinanFTP\exe, max ; como o processo falhou, agenda uma nova tarefa.
Sleep 3000
RunWait, log_close.bat, c:\SinanFTP\bat, max ; finaliza e renomeia o log.
Sleep 3000

Process, close, firefox.exe
ExitApp ; finaliza o script.
}	

else if ErrorLevel = 1
{
file := FileOpen("c:\SinanFTP\log\SinanFTP.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------O item 'exportar base de dados em DBF' não foi identificado na tela. `r`n"
file.Write(TestString)
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Finalizando processo SinanFTP. `r`n"
file.Write(TestString)
file.Close()

Sleep 3000
RunWait, autotask.exe, c:\SinanFTP\exe, max ; como o processo falhou, agenda uma nova tarefa.
Sleep 3000
RunWait, log_close.bat, c:\SinanFTP\bat, max ; finaliza e renomeia o log.
Sleep 3000

Process, close, firefox.exe
ExitApp ; finaliza o script.
}	

else ; Módulo exportação identificado.

{
file := FileOpen("c:\SinanFTP\log\SinanFTP.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Item 'exportar base de dados em DBF identificado'. `r`n"
file.Write(TestString)
file.Close()
sleep, 3000

MouseMove FoundX+20, FoundY+5
sleep, 2000
MouseClick, left, FoundX+20, FoundY+5

file := FileOpen("c:\SinanFTP\log\SinanFTP.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Item 'exportar base de dados em DBF' foi clicado no menu suspenso. `r`n"
file.Write(TestString)
file.Close()
}	

if WinExist("SINAN") ; Foca na janela do SINAN.
{
WinActivate
}

sleep, 4000

;Identifica se o usuário teve acesso ao módulo de Exportação de dados em DBF.
ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, c:\SinanFTP\img\identificacao.bmp

if ErrorLevel = 2
{
file := FileOpen("c:\SinanFTP\log\SinanFTP.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Falha no acesso ao módulo de exportação de dados em DBF. `r`n"
file.Write(TestString)
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Finalizando processo SinanFTP. `r`n"
file.Write(TestString)
file.Close()

Sleep 3000
RunWait, autotask.exe, c:\SinanFTP\exe, max ; como o processo falhou, agenda uma nova tarefa.
Sleep 3000
RunWait, log_close.bat, c:\SinanFTP\bat, max ; finaliza e renomeia o log.
Sleep 3000

Process, close, firefox.exe
ExitApp ; finaliza o script.
}	

else if ErrorLevel = 1
{
file := FileOpen("c:\SinanFTP\log\SinanFTP.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------O acesso ao módulo de exportação de dados em DBF falhou. `r`n"
file.Write(TestString)
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Finalizando processo SinanFTP. `r`n"
file.Write(TestString)
file.Close()

Sleep 3000
RunWait, autotask.exe, c:\SinanFTP\exe, max ; como o processo falhou, agenda uma nova tarefa.
Sleep 3000
RunWait, log_close.bat, c:\SinanFTP\bat, max ; finaliza e renomeia o log.
Sleep 3000

Process, close, firefox.exe
ExitApp ; finaliza o script.
}	

else ; Acesso ao módulo de exportação de dados em DBF.

{
file := FileOpen("c:\SinanFTP\log\SinanFTP.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Módulo de exportação de dados em DBF acessado. Iniciando preenchimento do formulário.`r`n"
file.Write(TestString)
file.Close()
sleep, 3000
}	

if WinExist("SINAN") ; Foca na janela do SINAN.
{
WinActivate
}

; Procedimento de preenchimento de formulário de exportação de dados em DBF.

if (argui = "deng") ; escolhe o agravo no formulário de acordo com o que foi solicitado pelo usuário.
{
nIndice = % A_Index ; registra o valor da iteração atual do loop.
cAno = % deng_array[nIndice] ; registra na variável cAno, o ano que será preenchido no formulário.
; formato final das datas inicial e final para o formulário.
cDataIni = 0101%cAno%
cDataFin = 3112%cAno%
}

if (argui = "chik") ; escolhe o agravo no formulário de acordo com o que foi solicitado pelo usuário.
{
nIndice = % A_Index ; registra o valor da iteração atual do loop.
cAno = % chik_array[nIndice] ; registra na variável cAno, o ano que será preenchido no formulário.
; formato final das datas inicial e final para o formulário.
cDataIni = 0101%cAno%
cDataFin = 3112%cAno%
}

Sleep, 4000
;Pula o campo "Periodo de notificação" , o padrão de preenchimento desse campo é "Data".
Send {TAB}
Sleep, 2000
SendInput %cDataIni%
Sleep, 2000
Send {TAB}
Sleep, 2000
SendInput %cDataFin%
Sleep, 2000
Send {TAB}
Sleep, 1000
Send n
Sleep 1000
Send n
Send {TAB 3}
Sleep, 2000

if (argui = "deng") ; escolhe o agravo no formulário de acordo com o que foi solicitado pelo usuário.
{
Send d ; Dengue
}
if (argui = "chik") ; escolhe o agravo no formulário de acordo com o que foi solicitado pelo usuário.
{
Send f ; Febre de Chikungunya.
}

Sleep, 2000
Send {TAB}
Sleep, 1000
Send {Space}

; Procura pelo botão "Solicitar"
ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, c:\SinanFTP\img\Solicitar.bmp

if ErrorLevel = 2
{
file := FileOpen("c:\SinanFTP\log\SinanFTP.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Falha na identificação do botão 'Solicitar'. `r`n"
file.Write(TestString)
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Finalizando processo SinanFTP. `r`n"
file.Write(TestString)
file.Close()

Sleep 3000
RunWait, autotask.exe, c:\SinanFTP\exe, max ; como o processo falhou, agenda uma nova tarefa.
Sleep 3000
RunWait, log_close.bat, c:\SinanFTP\bat, max ; finaliza e renomeia o log.
Sleep 3000

Process, close, firefox.exe
ExitApp ; finaliza o script.
}	

else if ErrorLevel = 1
{
file := FileOpen("c:\SinanFTP\log\SinanFTP.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------A imagem do botão 'Solicitar' não foi identificada na tela. `r`n"
file.Write(TestString)
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Finalizando processo SinanFTP. `r`n"
file.Write(TestString)
file.Close()

Sleep 3000
RunWait, autotask.exe, c:\SinanFTP\exe, max ; como o processo falhou, agenda uma nova tarefa.
Sleep 3000
RunWait, log_close.bat, c:\SinanFTP\bat, max ; finaliza e renomeia o log.
Sleep 3000

Process, close, firefox.exe
ExitApp ; finaliza o script.
}	

else ; Botão Solicitar identificado.

{
file := FileOpen("c:\SinanFTP\log\SinanFTP.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Formulário preenchido. O botão 'Solicitar' foi identificado. `r`n"
file.Write(TestString)
file.Close()
Sleep, 3000

MouseMove FoundX+50, FoundY+10
Sleep, 2000
MouseClick, left, FoundX+50, FoundY+10

file := FileOpen("c:\SinanFTP\log\SinanFTP.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Botão 'Solicitar' clicado. `r`n"
file.Write(TestString)
file.Close()

file := FileOpen("c:\SinanFTP\log\SinanFTP.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------O formulário foi enviado. Aguardando retorno de aceitação da solicitação.`r`n"
file.Write(TestString)
file.Close()

Sleep, 10000
}	

if WinExist("SINAN") ; Foca na janela do SINAN.
{
WinActivate
}

; Procura pela mensagem que confirma que a solicitação do arquivo foi efetuada.
ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, c:\SinanFTP\img\sol_efetuada.bmp

if ErrorLevel = 2
{
file := FileOpen("c:\SinanFTP\log\SinanFTP.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Falha na identificação da efetivação da solicitação. `r`n"
file.Write(TestString)
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Finalizando processo SinanFTP. `r`n"
file.Write(TestString)
file.Close()

Sleep 3000
RunWait, autotask.exe, c:\SinanFTP\exe, max ; como o processo falhou, agenda uma nova tarefa.
Sleep 3000
RunWait, log_close.bat, c:\SinanFTP\bat, max ; finaliza e renomeia o log.
Sleep 3000

Process, close, firefox.exe
ExitApp ; finaliza o script.
}	

else if ErrorLevel = 1
{
file := FileOpen("c:\SinanFTP\log\SinanFTP.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------A mensagem da efetivação da solicitação não foi identificada na tela. `r`n"
file.Write(TestString)
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Finalizando processo SinanFTP. `r`n"
file.Write(TestString)
file.Close()

Sleep 3000
RunWait, autotask.exe, c:\SinanFTP\exe, max ; como o processo falhou, agenda uma nova tarefa.
Sleep 3000
RunWait, log_close.bat, c:\SinanFTP\bat, max ; finaliza e renomeia o log.
Sleep 3000

Process, close, firefox.exe
ExitApp ; finaliza o script.
}	

else ; Solicitação efetuada com sucesso!

{
file := FileOpen("c:\SinanFTP\log\SinanFTP.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Solicitação efetuada com sucesso. `r`n"
file.Write(TestString)
file.Close()
Sleep, 10000
}	

; Cria arquivo txt temporário com informação do ano e tipo de agravo.
if a_index = 1
{
file := FileOpen("c:\SinanFTP\auxx\tempsolicit.txt", "w")
TestString10 := "dengue `r`n"
TestString20 := cAnoAtual
file.Write(TestString10)
file.Write(TestString20)
file.Close()
Sleep, 2000

file := FileOpen("c:\SinanFTP\log\SinanFTP.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Criado arquivo de texto com informação do ano e tipo de agravo da solicitação. `r`n"
file.Write(TestString)
file.Close()
Sleep, 5000
}

else

{
file := FileOpen("c:\SinanFTP\auxx\tempsolicit.txt", "w")
TestString10 := "dengue `r`n"
TestString20 := cAnoPassado
file.Write(TestString10)
file.Write(TestString20)
file.Close()
Sleep, 2000

file := FileOpen("c:\SinanFTP\log\SinanFTP.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Criado arquivo de texto com informação do ano e tipo de agravo da solicitação. `r`n"
file.Write(TestString)
file.Close()
Sleep, 5000
}

file := FileOpen("c:\SinanFTP\log\SinanFTP.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString30 := TimeString "-------Tipo de agravo solicitado:dengue. `r`n"
TestString40 := TimeString "-------Ano (periodo solicitado no formulário):" TestString20 ". `r`n"
file.Write(TestString30)
file.Write(TestString40)
file.Close()

; Inicio dos procedimentos para copiar a tela para o bloco de notas.

; Verifica se o arquivo "temptext0.txt" existe. Se sim, deleta e cria um novo.
if FileExist("c:\SinanFTP\auxx\temptext0.txt")
FileDelete, c:\SinanFTP\auxx\temptext0.txt
Sleep, 3000
file := FileOpen("c:\SinanFTP\auxx\temptext0.txt", "w")
file.Close()
Sleep, 2000

Send ^a
Sleep, 3000
Send ^c
Run, Notepad.exe /A "c:\SinanFTP\auxx\temptext0.txt"
Sleep, 5000
if WinExist("temptext0.txt") ; Foca no bloco de notas.
{
WinMaximize
}
Sleep, 3000
Send ^v
Sleep, 3000
Send ^s
Sleep, 3000
Send !{F4}
Sleep, 1000
if WinExist("SINAN") ; Foca na janela do SINAN.
{
WinActivate
}
Sleep, 1000

file := FileOpen("c:\SinanFTP\log\SinanFTP.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Texto da tela copiado para o arquivo 'temptext0.txt'. `r`n"
file.Write(TestString)
file.Close()
Sleep, 3000

Gosub, Desmarca ; clica em uma área na tela para desmarcar o texto selecionado.

if WinExist("SINAN") ; Foca na janela do SINAN.
{
WinActivate
}

Sleep, 5000

RunWait, learquivotxt.exe solic, c:\SinanFTP\exe, hide ; cria o arquivo "solicitacoes.dbf" que registra as solicitações geradas.

file := FileOpen("c:\SinanFTP\log\SinanFTP.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Criado arquivo 'solicitacoes.dbf' que registra as solicitações geradas. `r`n"
file.Write(TestString)
file.Close()

Sleep, 5000

; A próxima chave fecha o loop.
}

if WinExist("SINAN") ; Foca na janela do SINAN.
{
WinActivate
}

Gosub, Consulta ; Rotina para acessar o módulo de consulta dos arquivos DBF solicitados.

Loop ; inicia um loop.
{
; Inicio dos procedimentos para copiar a tela para o bloco de notas.

; Verifica se o arquivo "temptext1.txt" existe. Se sim, deleta e cria um novo.
if FileExist("c:\SinanFTP\auxx\temptext1.txt")
FileDelete, c:\SinanFTP\auxx\temptext1.txt
Sleep, 3000
file := FileOpen("c:\SinanFTP\auxx\temptext1.txt", "w")
file.Close()
Sleep, 2000

Send ^a
Sleep, 3000
Send ^c
Run, Notepad.exe /A "c:\SinanFTP\auxx\temptext1.txt"
Sleep, 5000
if WinExist("temptext1.txt") ; Foca no bloco de notas.
{
WinMaximize
}
Sleep, 3000
Send ^v
Sleep, 3000
Send ^s
Sleep, 3000
Send !{F4}
Sleep, 1000

if WinExist("SINAN") ; Foca na janela do SINAN.
{
WinActivate
}

file := FileOpen("c:\SinanFTP\log\SinanFTP.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Texto da tela copiado para o arquivo 'temptext1.txt'. `r`n"
file.Write(TestString)
file.Close()
Sleep, 3000

Gosub, Desmarca ; clica em uma área na tela para desmarcar o texto selecionado.

if WinExist("SINAN") ; Foca na janela do SINAN.
{
WinActivate
}

Sleep, 1000
RunWait, learquivotxt.exe consul, c:\SinanFTP\exe, hide ; cria o arquivo "totalsol.dbf" que registra as solicitações geradas e outras informações.

file := FileOpen("c:\SinanFTP\log\SinanFTP.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Cria o arquivo 'totalsol.dbf' com as solicitações geradas e outras informações. `r`n"
file.Write(TestString)
file.Close()

Sleep, 5000
RunWait, join.exe, c:\SinanFTP\exe, hide ; Junta as informações do arquivo "solicitacoes.dbf" ao arquivo "totalsol.dbf".

file := FileOpen("c:\SinanFTP\log\SinanFTP.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Junta as informações do arquivo 'solicitacoes.dbf' ao arquivo 'totalsol.dbf'. `r`n"
file.Write(TestString)
file.Close()

Sleep, 5000
RunWait, download.exe verify, c:\SinanFTP\exe, hide ; Verifica se existem solicitações que ainda estão sendo processadas.

file := FileOpen("c:\SinanFTP\log\SinanFTP.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Verificado se existem solicitações que ainda estão sendo processadas. `r`n"
file.Write(TestString)
file.Close()

Sleep, 5000

file := FileOpen("c:\SinanFTP\log\SinanFTP.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Acessando os dados do arquivo 'download.ini' para verificar se solicitações foram todas processadas. `r`n"
file.Write(TestString)
file.Close()

Sleep, 3000

; Acessa os dados do arquivo "download.ini"
IniRead, OutputVar2, c:\SinanFTP\auxx\download.ini, DADOS, filename
cFileNameIs = %OutputVar2%
IniRead, OutputVar2, c:\SinanFTP\auxx\download.ini, DADOS, position
cPositionIs = %OutputVar2%

; Se o valor dos dados na chave filename e position for "processando...", acessa o módulo de consulta novamente.
if (cFileNameIs = "processando..." or cPositionIs = "processando...")
{
file := FileOpen("c:\SinanFTP\log\SinanFTP.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------As solicitações não foram todas processadas. Acessando o módulo de consulta de exportações de novo. `r`n"
file.Write(TestString)
file.Close()
Gosub, Consulta ;roda o label para acessar o módulo de Exportação e depois a função Consultar exportação DBF repetidamente.
continue
}

else

{
file := FileOpen("c:\SinanFTP\log\SinanFTP.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------As solicitações foram todas processadas. Passando para o próximo estágio. `r`n"
file.Write(TestString)
file.Close()

break
}

} ;fecha o loop.

Loop ; inicia outro loop, dessa vez para realizar o download dos arquivos.
{
file := FileOpen("c:\SinanFTP\log\SinanFTP.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Procura pelas solicitações disponíveis para download. `r`n"
file.Write(TestString)
file.Close()

RunWait, download.exe in, c:\SinanFTP\exe, hide ; Procura pelas solicitações disponíveis para download.

Sleep, 5000

; Acessa os dados do arquivo "download.ini"
IniRead, OutputVar2, c:\SinanFTP\auxx\download.ini, DADOS, filename
cFileNameIs = %OutputVar2%
IniRead, OutputVar2, c:\SinanFTP\auxx\download.ini, DADOS, position
cPositionIs = %OutputVar2%

; Se o valor dos dados na chave filename e position for "000000", significa que não há mais arquivos para download.
if (cFileNameIs = "000000" and cPositionIs = "000000")
{
file := FileOpen("c:\SinanFTP\log\SinanFTP.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Todos os arquivos disponíveis para download foram baixados. `r`n"
file.Write(TestString)
file.Close()
break
}

Sleep, 5000

; Acessa os dados do arquivo "download.ini" e passa para as variáveis públicas valores como
; o nome do arquivo para fazer o download e a posição dele na tela do SINAN Online.

file := FileOpen("c:\SinanFTP\log\SinanFTP.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Passa para as variáveis o nome do arquivo a ser baixado e a posição do mesmo na tela. `r`n"
file.Write(TestString)
file.Close()

IniRead, OutputVar2, c:\SinanFTP\auxx\download.ini, DADOS, filename
cFileNameIs = %OutputVar2%

if (argui = "deng") ; escolhe a pasta onde o arquivo será salvo caso o argumento escolhido seja Dengue.
{
cFileNameFull = c:\SinanFTP\tmp\deng\%cFileNameIs%DBF.zip
}
if (argui = "chik") ; escolhe a pasta onde o arquivo será salvo caso o argumento escolhido seja Chikungunya.
{
cFileNameFull = c:\SinanFTP\tmp\chik\%cFileNameIs%DBF.zip
}

IniRead, OutputVar2, c:\SinanFTP\auxx\download.ini, DADOS, position
cPositionIs = %OutputVar2%
IniRead, OutputVar2, c:\SinanFTP\auxx\download.ini, DADOS, registros
cRegistros = %OutputVar2%
IniRead, OutputVar2, c:\SinanFTP\auxx\download.ini, DADOS, status
cStatus = %OutputVar2%

file := FileOpen("c:\SinanFTP\log\SinanFTP.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString60 := TimeString "-------Informações do arquivo para download: `r`n"
TestString70 := TimeString "-------Nome do arquivo:" cFileNameFull ". `r`n"
TestString75 := TimeString "-------Posição do arquivo:" cPositionIs ". `r`n"
TestString80 := TimeString "-------Número de registros:" cRegistros ". `r`n"
TestString90 := TimeString "-------Status:" cStatus ". `r`n"
file.Write(TestString60)
file.Write(TestString70)
file.Write(TestString75)
file.Write(TestString80)
file.Write(TestString90)
file.Close()

; Escolhe as coordenadas para clicar no link de acordo a posição do arquivo na tela do SINAN Online.
; A capacidade é de clicar no máximo em 10 links diferentes.

if cPositionIs = 1
{
IniRead, OutputVar3, c:\SinanFTP\set\SetSinanFTP.ini, POSICAO, PosX1
nX = %OutputVar3%
IniRead, OutputVar3, c:\SinanFTP\set\SetSinanFTP.ini, POSICAO, PosY1
nY = %OutputVar3%
}

if cPositionIs = 2
{
IniRead, OutputVar3, c:\SinanFTP\set\SetSinanFTP.ini, POSICAO, PosX2
nX = %OutputVar3%
IniRead, OutputVar3, c:\SinanFTP\set\SetSinanFTP.ini, POSICAO, PosY2
nY = %OutputVar3%
}

if cPositionIs = 3
{
IniRead, OutputVar3, c:\SinanFTP\set\SetSinanFTP.ini, POSICAO, PosX3
nX = %OutputVar3%
IniRead, OutputVar3, c:\SinanFTP\set\SetSinanFTP.ini, POSICAO, PosY3
nY = %OutputVar3%
}

if cPositionIs = 4
{
IniRead, OutputVar3, c:\SinanFTP\set\SetSinanFTP.ini, POSICAO, PosX4
nX = %OutputVar3%
IniRead, OutputVar3, c:\SinanFTP\set\SetSinanFTP.ini, POSICAO, PosY4
nY = %OutputVar3%
}

if cPositionIs = 5
{
IniRead, OutputVar3, c:\SinanFTP\set\SetSinanFTP.ini, POSICAO, PosX5
nX = %OutputVar3%
IniRead, OutputVar3, c:\SinanFTP\set\SetSinanFTP.ini, POSICAO, PosY5
nY = %OutputVar3%
}

if cPositionIs = 6
{
IniRead, OutputVar3, c:\SinanFTP\set\SetSinanFTP.ini, POSICAO, PosX6
nX = %OutputVar3%
IniRead, OutputVar3, c:\SinanFTP\set\SetSinanFTP.ini, POSICAO, PosY6
nY = %OutputVar3%
}

if cPositionIs = 7
{
IniRead, OutputVar3, c:\SinanFTP\set\SetSinanFTP.ini, POSICAO, PosX7
nX = %OutputVar3%
IniRead, OutputVar3, c:\SinanFTP\set\SetSinanFTP.ini, POSICAO, PosY7
nY = %OutputVar3%
}

if cPositionIs = 8
{
IniRead, OutputVar3, c:\SinanFTP\set\SetSinanFTP.ini, POSICAO, PosX8
nX = %OutputVar3%
IniRead, OutputVar3, c:\SinanFTP\set\SetSinanFTP.ini, POSICAO, PosY8
nY = %OutputVar3%
}

if cPositionIs = 9
{
IniRead, OutputVar3, c:\SinanFTP\set\SetSinanFTP.ini, POSICAO, PosX9
nX = %OutputVar3%
IniRead, OutputVar3, c:\SinanFTP\set\SetSinanFTP.ini, POSICAO, PosY9
nY = %OutputVar3%
}

if cPositionIs = 10
{
IniRead, OutputVar3, c:\SinanFTP\set\SetSinanFTP.ini, POSICAO, PosX10
nX = %OutputVar3%
IniRead, OutputVar3, c:\SinanFTP\set\SetSinanFTP.ini, POSICAO, PosY10
nY = %OutputVar3%
}

file := FileOpen("c:\SinanFTP\log\SinanFTP.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Escolhida as coordenadas na tela para baixar o arquivo. `r`n"
file.Write(TestString)
file.Close()

; Movimenta o cursor para a posição do link e depois clica nele.
Sleep, 3000
MouseMove, nX, nY ; valor default.
Sleep, 5000
MouseClick, left, nX, nY ; valor default.

Sleep, 5000

if WinExist("Abrir") ; Foca na janela para abrir ou salvar o arquivo.
{
WinActivate
file := FileOpen("c:\SinanFTP\log\SinanFTP.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Janela para salvar o arquivo foi identificada... `r`n"
file.Write(TestString)
file.Close()
}

else

{
file := FileOpen("c:\SinanFTP\log\SinanFTP.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------A janela para salvar o arquivo não foi identificada. `r`n"
file.Write(TestString)
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Finalizando processo SinanFTP. `r`n"
file.Write(TestString)
file.Close()

Sleep 3000
RunWait, autotask.exe, c:\SinanFTP\exe, max ; como o processo falhou, agenda uma nova tarefa.
Sleep 3000
RunWait, log_close.bat, c:\SinanFTP\bat, max ; finaliza e renomeia o log.
Sleep 3000

Process, close, firefox.exe
ExitApp ; finaliza o script.
}

Sleep, 6000

; Procedimentos para salvar o arquivo ao invés de abrí-lo.
Send !d
Sleep 3000
Send {Enter}
Sleep, 5000

if WinExist("Salvar arquivo como") ; Escolhe local para salvar o arquivo.
{
WinActivate
file := FileOpen("c:\SinanFTP\log\SinanFTP.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Escolhendo o local para salvar o arquivo... `r`n"
file.Write(TestString)
file.Close()
}
else

{
file := FileOpen("c:\SinanFTP\log\SinanFTP.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------A janela do local para salvar o arquivo não foi identificada. `r`n"
file.Write(TestString)
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Finalizando processo SinanFTP. `r`n"
file.Write(TestString)
file.Close()

Sleep 3000
RunWait, autotask.exe, c:\SinanFTP\exe, max ; como o processo falhou, agenda uma nova tarefa.
Sleep 3000
RunWait, log_close.bat, c:\SinanFTP\bat, max ; finaliza e renomeia o log.
Sleep 3000

Process, close, firefox.exe
ExitApp ; finaliza o script.
}

; Na janela "Salvar arquivo como", salva o arquivo com o nome e diretório adequados.
Sleep, 7000
Send {Del}
Sleep, 4000

SendInput %cFileNameFull%

Sleep, 4000
Send {Tab 3}
Sleep, 2000
Send {Enter}
Sleep, 5000

; Há vezes que o ENTER não salva o arquivo. Nesses casos, caso isso ocorra, este script detecta que a janela
; ainda está aberta e salva o arquivo usando a tecla de atalho ALT+l.
if WinExist("Salvar arquivo como") 
{
WinActivate
Send !l
}

; Configura o tempo de espera para realizar o download desse arquivo antes de fazer o download do próximo.
IniRead, OutputVar7, c:\SinanFTP\set\SetSinanFTP.ini, TEMPO, Tempo
nTempo = %OutputVar7%
nTempo *= 60000
Sleep %nTempo%

; Procura no diretório se o arquivo foi salvo.
if FileExist(cFileNameFull)
{
file := FileOpen("c:\SinanFTP\log\SinanFTP.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------O arquivo baixado foi salvo. `r`n"
file.Write(TestString)
file.Close()
; Marca no arquivo "totalsol.dbf" que o download foi bem sucedido e o arquivo foi salvo no local apropriado.
RunWait, download.exe out, c:\SinanFTP\exe, hide
IniWrite, %argui% , c:\SinanFTP\auxx\download.ini, DADOS, modo
}

Sleep, 5000

} ; fecha o loop.

Sleep, 5000

file := FileOpen("c:\SinanFTP\log\SinanFTP.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Todas as etapas foram finalizadas. Fim do script 'baixaDBFx'. `r`n"
file.Write(TestString)
file.Close()

Process, close, firefox.exe

; Roda o script unzipping.exe
if (argui = "deng") ; argumento deng.
{
RunWait, unzipping.exe deng, c:\SinanFTP\exe ; Descompacta os arquivos que foram baixados.
}
if (argui = "chik") ; argumento chik.
{
RunWait, unzipping.exe chik, c:\SinanFTP\exe ; Descompacta os arquivos que foram baixados.
}

Sleep, 5000

; Roda o script merge2.exe.
if (argui = "deng") ; argumento deng.
{
RunWait, merge2.exe deng, c:\SinanFTP\exe ; Reduz a quantidade de campos dos arquivos baixados e os funde em um só, se for o caso.
}
if (argui = "chik") ; argumento chik.
{
RunWait, merge2.exe chik, c:\SinanFTP\exe ; Reduz a quantidade de campos dos arquivos baixados e os funde em um só, se for o caso.
}

Sleep 5000

; Roda o script fill.exe
; Esse script só roda quando o argumento é 'deng'. Para arquivos de Chikungunya esse script não se aplica.

if (argui = "deng") ; argumento deng.
{
RunWait, fill.exe deng, c:\SinanFTP\exe ; Procura registros vazios no campo dt_digita.
}

Sleep, 5000

; Roda o script testFTP2.bat 

if (argui = "deng") ; argumento deng.
{
RunWait, testFTP2.bat deng, c:\SinanFTP\bat ; Testa a conexão de FTP.
}

if (argui = "chik") ; argumento chik.
{
RunWait, testFTP2.bat chik, c:\SinanFTP\bat ; Testa a conexão de FTP.
}

Sleep 5000

; Roda o script send2.bat
if (argui = "deng") ; argumento deng.
{
RunWait, send2.bat deng, c:\SinanFTP\bat ; Envia o arquivo dengon.dbf para o outro servidor usando o protocolo FTP.
}
if (argui = "chik") ; argumento deng.
{
RunWait, send2.bat chik, c:\SinanFTP\bat ; Envia o arquivo chikon.dbf para o outro servidor usando o protocolo FTP.
}

Sleep, 5000

; Roda o script compare.bat

if (argui = "deng") ; argumento deng.
{
RunWait, compare.bat deng, c:\SinanFTP\bat ; Testa se o arquivo gerado foi enviado corretamente pelo FTP.
}
if (argui = "chik") ; argumento deng.
{
RunWait, compare.bat chik, c:\SinanFTP\bat ; Testa se o arquivo gerado foi enviado corretamente pelo FTP.
}

Sleep, 5000

ExitApp

; =============================================================================================================

; Código com os labels do programa.

; Label para acessar o módulo de Exportação e depois a função Consultar exportação DBF repetidamente.
Consulta:

Sleep, 10000

;procura pelo módulo "Exportação" no SINAN Online.
ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, c:\SinanFTP\img\export.bmp

if ErrorLevel = 2
{
file := FileOpen("c:\SinanFTP\log\SinanFTP.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Falha na identificação do módulo 'Exportação'. `r`n"
file.Write(TestString)
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Finalizando processo SinanFTP. `r`n"
file.Write(TestString)
file.Close()

Sleep 3000
RunWait, autotask.exe, c:\SinanFTP\exe, max ; como o processo falhou, agenda uma nova tarefa.
Sleep 3000
RunWait, log_close.bat, c:\SinanFTP\bat, max ; finaliza e renomeia o log.
Sleep 3000

Process, close, firefox.exe
ExitApp ; finaliza o script.
}	

else if ErrorLevel = 1
{
file := FileOpen("c:\SinanFTP\log\SinanFTP.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------O módulo 'Exportação' não foi identificado na tela. `r`n"
file.Write(TestString)
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Finalizando processo SinanFTP. `r`n"
file.Write(TestString)
file.Close()

Sleep 3000
RunWait, autotask.exe, c:\SinanFTP\exe, max ; como o processo falhou, agenda uma nova tarefa.
Sleep 3000
RunWait, log_close.bat, c:\SinanFTP\bat, max ; finaliza e renomeia o log.
Sleep 3000

Process, close, firefox.exe
ExitApp ; finaliza o script.
}	

else ; Módulo exportação identificado.

{
file := FileOpen("c:\SinanFTP\log\SinanFTP.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Módulo 'exportação' identificado. `r`n"
file.Write(TestString)
file.Close()
sleep, 3000

MouseMove FoundX+20, FoundY+5
sleep, 2000
MouseClick, left, FoundX+20, FoundY+5

file := FileOpen("c:\SinanFTP\log\SinanFTP.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Módulo 'exportação' foi clicado no menu suspenso. `r`n"
file.Write(TestString)
file.Close()
}	

if WinExist("SINAN") ; Foca na janela do SINAN.
{
WinActivate
}

;procura pelo item "Consultar exportações DBF.
ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, c:\SinanFTP\img\consultar.bmp

if ErrorLevel = 2
{
file := FileOpen("c:\SinanFTP\log\SinanFTP.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Falha na identificação do item 'Consultar exportações DBF'. `r`n"
file.Write(TestString)
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Finalizando processo SinanFTP. `r`n"
file.Write(TestString)
file.Close()

Sleep 3000
RunWait, autotask.exe, c:\SinanFTP\exe, max ; como o processo falhou, agenda uma nova tarefa.
Sleep 3000
RunWait, log_close.bat, c:\SinanFTP\bat, max ; finaliza e renomeia o log.
Sleep 3000

Process, close, firefox.exe
ExitApp ; finaliza o script.
}	

else if ErrorLevel = 1
{
file := FileOpen("c:\SinanFTP\log\SinanFTP.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------O item 'Consultar exportações DBF' não foi identificado na tela. `r`n"
file.Write(TestString)
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Finalizando processo SinanFTP. `r`n"
file.Write(TestString)
file.Close()

Sleep 3000
RunWait, autotask.exe, c:\SinanFTP\exe, max ; como o processo falhou, agenda uma nova tarefa.
Sleep 3000
RunWait, log_close.bat, c:\SinanFTP\bat, max ; finaliza e renomeia o log.
Sleep 3000

Process, close, firefox.exe
ExitApp ; finaliza o script.
}	

else ; Função Consultar exportações DBF foi identificada.

{
file := FileOpen("c:\SinanFTP\log\SinanFTP.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------O item 'Consultar exportações DBF' foi identificado. `r`n"
file.Write(TestString)
file.Close()
sleep, 3000

MouseMove FoundX+20, FoundY+5
sleep, 2000
MouseClick, left, FoundX+20, FoundY+5

file := FileOpen("c:\SinanFTP\log\SinanFTP.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------O item 'Consultar exportações DBF' foi clicado no menu suspenso. `r`n"
file.Write(TestString)
file.Close()
}	

if WinExist("SINAN") ; Foca na janela do SINAN.
{
WinActivate
}

Sleep, 7000
;procura pela imagem "link" para atestar que o módulo de consulta foi acessado.
ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, c:\SinanFTP\img\link.bmp

if ErrorLevel = 2
{
file := FileOpen("c:\SinanFTP\log\SinanFTP.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Falha na identificação de acesso ao módulo de consulta. `r`n"
file.Write(TestString)
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Finalizando processo SinanFTP. `r`n"
file.Write(TestString)
file.Close()

Sleep 3000
RunWait, autotask.exe, c:\SinanFTP\exe, max ; como o processo falhou, agenda uma nova tarefa.
Sleep 3000
RunWait, log_close.bat, c:\SinanFTP\bat, max ; finaliza e renomeia o log.
Sleep 3000

Process, close, firefox.exe
ExitApp ; finaliza o script.
}	

else if ErrorLevel = 1
{
file := FileOpen("c:\SinanFTP\log\SinanFTP.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Acesso ao módulo de consulta não foi identificado na tela. `r`n"
file.Write(TestString)
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Finalizando processo SinanFTP. `r`n"
file.Write(TestString)
file.Close()

Sleep 3000
RunWait, autotask.exe, c:\SinanFTP\exe, max ; como o processo falhou, agenda uma nova tarefa.
Sleep 3000
RunWait, log_close.bat, c:\SinanFTP\bat, max ; finaliza e renomeia o log.
Sleep 3000

Process, close, firefox.exe
ExitApp ; finaliza o script.
}	

else ; Confirma identificação de acesso ao módulo de consulta.

{
file := FileOpen("c:\SinanFTP\log\SinanFTP.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Módulo de consulta das exportações DBF acessado.`r`n"
file.Write(TestString)
file.Close()
}	

return

; =============================================================================================================

; Label para desmarcar as seleções feitas.
Desmarca:

Sleep, 3000

;procura por uma área do texto que não seja um botão ou link e que não seja alterada pela seleção (CTRL+A).
ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, c:\SinanFTP\img\area_neutra.bmp

if ErrorLevel = 2
{
file := FileOpen("c:\SinanFTP\log\SinanFTP.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Falha na identificação da área neutra. `r`n"
file.Write(TestString)
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Finalizando processo SinanFTP. `r`n"
file.Write(TestString)
file.Close()

Sleep 3000
RunWait, autotask.exe, c:\SinanFTP\exe, max ; como o processo falhou, agenda uma nova tarefa.
Sleep 3000
RunWait, log_close.bat, c:\SinanFTP\bat, max ; finaliza e renomeia o log.
Sleep 3000

Process, close, firefox.exe
ExitApp ; finaliza o script.
}	

else if ErrorLevel = 1
{
file := FileOpen("c:\SinanFTP\log\SinanFTP.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------A área neutra não foi identificada na tela. `r`n"
file.Write(TestString)
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Finalizando processo SinanFTP. `r`n"
file.Write(TestString)
file.Close()

Sleep 3000
RunWait, autotask.exe, c:\SinanFTP\exe, max ; como o processo falhou, agenda uma nova tarefa.
Sleep 3000
RunWait, log_close.bat, c:\SinanFTP\bat, max ; finaliza e renomeia o log.
Sleep 3000

Process, close, firefox.exe
ExitApp ; finaliza o script.
}	

else ; Módulo exportação identificado.

{
file := FileOpen("c:\SinanFTP\log\SinanFTP.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Area neutra identificada. Desmarcando o texto da tela...`r`n"
file.Write(TestString)
file.Close()
sleep, 3000
MouseMove FoundX+20, FoundY+5
sleep, 2000
MouseClick, left, FoundX+20, FoundY+5
}	

if WinExist("SINAN") ; Foca na janela do SINAN.
{
WinActivate
}

return

; =============================================================================================================