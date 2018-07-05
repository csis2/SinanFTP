#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; SinanMail - versao 1.0 - 21/06/2018
; Script para enviar e-mail relatando o resultado do processo do SinanFTP.

; ajuste de ambiente
DetectHiddenWindows, off
DetectHiddenText, on
CoordMode, Screen  ;
SetTitleMatchMode 2
SetTitleMatchMode Slow

; importando bibliotecas de criptografia;
#Include Crypt.ahk
#Include CryptConst.ahk
#Include CryptFoos.ahk

; Lê no arquivo de configuração se há permissão para trabalhar com acesso a rede proxy.
IniRead, OutputVar33, c:\SinanFTP\set\SetSinanFTP2.ini, PROXY, Usa?
if (OutputVar33 = "true")
{
RunWait, auth_trap.exe, c:\SinanFTP\exe ; Autentica o acesso a rede proxy caso o pedido de autenticação apareça.
}

; Lista de variáveis globais.
GLOBAL cLoginMail := "" ; guarda o login para acessar o SINAN Online.
GLOBAL cSenhaMail := "" ; guarda a senha para acessar o SINAN Online.
GLOBAL cDestMail := "" ; armazena o(s) destinatário(s) do e-mail.
GLOBAL cArgui2 := "" ; Armazena o argumento na variavel global 'cArgui2'.
GLOBAL cArgui3 := "" ; Armazena o argumento na variavel global 'cArgui3'.

cArgui2 = %1% ; 
cArgui3 = %2% ; 

if (cArgui2 <> "deng" and cArgui2 <> "chik")
{
msgbox O argumento usado: %cArgui2%, não é valido.
ExitApp ; se o argumento não foi validado, finaliza o script.
}

if (cArgui3 <> "error" and cArgui3 <> "ok")
{
msgbox O argumento usado: %cArgui3%, não é valido.
ExitApp ; se o argumento não foi validado, finaliza o script.
}

; Lê no arquivo de configuração se há permissão para usar o serviço de e-mail.
IniRead, OutputVar33, c:\SinanFTP\set\SetSinanFTP2.ini, E-MAIL, Usa?
if (OutputVar33 = "false")
{
msgbox Você não autorizou o uso do serviço de e-mail.
msgbox Acesse o programa "config.exe" e faça o ajuste necessário.
ExitApp 
}

; Lê o login do e-mail, a senha do e-mail e os destinatários no arquivo "SetSinanFTP2.ini" e os coloca em variáveis.
IniRead, OutputVar5, c:\SinanFTP\set\SetSinanFTP2.ini, E-MAIL, Login
cLoginMail = %OutputVar5%
IniRead, OutputVar, c:\SinanFTP\set\SetSinanFTP2.ini, E-MAIL, Pass
decrypted_string := Crypt.Encrypt.StrDecrypt(OutputVar,"B65C8825FB47B72A8A15EF85E48C0C8BD5C50D51",5,1)
cSenhaMail = %decrypted_string%
IniRead, OutputVar6, c:\SinanFTP\set\SetSinanFTP2.ini, E-MAIL, Dest
cDestMail = %OutputVar6%

file := FileOpen("c:\SinanFTP\mail\SinanFTPMail.log", "w")
file.Close()
file := FileOpen("c:\SinanFTP\mail\SinanFTPMail.log", "a")
TestString := "************************************************************************************************************`r`n"
file.Write(TestString)
TestString := "*                                                                                                          *`r`n"
file.Write(TestString)
TestString := "*                                          Arquivo de log SinanFTPMail                                     *`r`n"
file.Write(TestString)
TestString := "*                                                                                                          *`r`n"
file.Write(TestString)
TestString := "************************************************************************************************************`r`n"
file.Write(TestString)

FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Comeca o processo SinanFTPMail. `r`n"
file.Write(TestString)
file.Close()

file := FileOpen("c:\SinanFTP\mail\SinanFTPMail.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Primeiro argumento usado:" cArgui2 ". `r`n"
file.Write(TestString)
file.Close()

file := FileOpen("c:\SinanFTP\mail\SinanFTPMail.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Segundo argumento usado:" cArgui3 ". `r`n"
file.Write(TestString)
file.Close()

Run, https://accounts.google.com/signin/v2/identifier?sacu=1&scc=1&continue=https`%3A`%2F`%2Fmail.google.com`%2Fmail`%2F&hl=en&service=mail&ss=1&ltmpl=default&rm=false&flowName=GlifWebSignIn&flowEntry=ServiceLogin" ; Abre o navegador e acessa o Gmail.

Sleep 25000 ; aguarda 25 segundos pelas próximas instruções.

; gera o PID (process identifier) do Firefox e analisa se ele foi aberto pelo comando Run.
Process, exist, firefox.exe ;
NewPID = %ErrorLevel% 
if NewPID = 0
{
file := FileOpen("c:\SinanFTP\mail\SinanFTPMail.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------O navegador Firefox nao foi aberto. `r`n"
file.Write(TestString)
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Finalizando o script SinanFTPMail. `r`n"
file.Write(TestString)
file.Close()
ExitApp ; finaliza o script.
}
else
{
IfWinExist, ahk_pid %NewPID%
WinActivate
file := FileOpen("c:\SinanFTP\mail\SinanFTPMail.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------O navegador Firefox foi aberto. `r`n"
file.Write(TestString)
file.Close()
}

; testa se o Gmail está logado ou não.
if WinExist("Entrada") ; testa se o Gmail está logado.
{
file := FileOpen("c:\SinanFTP\mail\SinanFTPMail.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Aplicacao Gmail identificada. `r`n"
file.Write(TestString)
file.Close()

WinActivate
WinMaximize
file := FileOpen("c:\SinanFTP\mail\SinanFTPMail.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Janela do Firefox maximizada. `r`n"
file.Write(TestString)
file.Close()
}
else
{
Sleep 5000
SendInput %cLoginMail%
Sleep 1000
Send {Enter}
Sleep 7000
SendInput %cSenhaMail%
Sleep 1000
Send {Enter}
Sleep 16000
}

if WinExist("Entrada") ; testa se o Gmail está logado.
{
file := FileOpen("c:\SinanFTP\mail\SinanFTPMail.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Aplicacao Gmail identificada. `r`n"
file.Write(TestString)
file.Close()

WinActivate
WinMaximize
file := FileOpen("c:\SinanFTP\mail\SinanFTPMail.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Janela do Firefox maximizada. `r`n"
file.Write(TestString)
file.Close()
}

file := FileOpen("c:\SinanFTP\mail\SinanFTPMail.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Inicio da edicao do e-mail. `r`n"
file.Write(TestString)
file.Close()

; Escreve o texto que será enviado pelo e-mail.
; Acessa o editor de e-mail 
Send c
Sleep 6000
Send %cDestMail%
Sleep 5000
Send {Tab}
Sleep 1000
Send {Tab}
Sleep 1000
if (cArgui3 = "error")
{
Send Mensagem do SinanFTP - ERRO.
}
else
{
Send Mensagem do SinanFTP.
}
Sleep 1000
Send {Tab}
Sleep 1000

if (cArgui2 = "deng" and cArgui3 = "error")
{
Send A geração do arquivo dengon.dbf falhou.
Sleep 1000
Send {Enter}
Sleep 1000
Send Será necessário gerar e enviar o arquivo manualmente.
Sleep 1000
Send {Enter}
Send Mensagem gerada automaticamente. Não é preciso responder.
Sleep 1000
Send {Enter}
Sleep 5000
}

if (cArgui2 = "deng" and cArgui3 = "ok")
{
Send A geração do arquivo dengon.dbf foi bem sucedida.
Sleep 1000
Send {Enter}
Sleep 1000
Send O arquivo foi enviado por FTP.
Sleep 1000
Send {Enter}
Sleep 1000
Send Mensagem gerada automaticamente. Não é preciso responder.
Sleep 1000
Send {Enter}
Sleep 5000
}

if (cArgui2 = "chik" and cArgui3 = "error")
{
Send A geração do arquivo chikon.dbf falhou.
Sleep 1000
Send {Enter}
Sleep 1000
Send Será necessário gerar e enviar o arquivo manualmente.
Sleep 1000
Send {Enter}
Send Mensagem gerada automaticamente. Não é preciso responder.
Sleep 1000
Send {Enter}
Sleep 5000
}

if (cArgui2 = "chik" and cArgui3 = "ok")
{
Send A geração do arquivo chikon.dbf foi bem sucedida.
Sleep 1000
Send {Enter}
Sleep 1000
Send O arquivo foi enviado por FTP.
Sleep 1000
Send {Enter}
Sleep 1000
Send Mensagem gerada automaticamente. Não é preciso responder.
Sleep 1000
Send {Enter}
Sleep 5000
}

; Procura pelo icone "Anexar" usando o ImageSearch. 
Sleep, 10000

ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, c:\SinanFTP\img\anexar.png

if ErrorLevel = 2
{
file := FileOpen("c:\SinanFTP\mail\SinanFTPMail.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Falha na identificação do icone Anexar. `r`n"
file.Write(TestString)
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Finalizando o script SinanMail. `r`n"
file.Write(TestString)
file.Close()
Sleep 3000

Sleep 3000
RunWait, log_close2.bat, c:\SinanFTP\bat, max ; finaliza e renomeia o log.
Sleep 3000

Process, close, firefox.exe
ExitApp ; finaliza o script.
}	

else if ErrorLevel = 1
{
file := FileOpen("c:\SinanFTP\mail\SinanFTPMail.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------O icone Anexar não foi identificado na tela. `r`n"
file.Write(TestString)
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Finalizando o script SinanMail. `r`n"
file.Write(TestString)
file.Close()
Sleep 3000

Sleep 3000
RunWait, log_close2.bat, c:\SinanFTP\bat, max ; finaliza e renomeia o log.
Sleep 3000

Process, close, firefox.exe
ExitApp ; finaliza o script.
}	

else ; Icone "Anexar" identificado.

{
file := FileOpen("c:\SinanFTP\mail\SinanFTPMail.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Icone Anexar foi identificado. `r`n"
file.Write(TestString)
file.Close()
sleep, 3000

MouseMove FoundX+10, FoundY+5
sleep, 2000
MouseClick, left, FoundX+10, FoundY+5

file := FileOpen("c:\SinanFTP\mail\SinanFTPMail.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Icone Anexar foi clicado. `r`n"
file.Write(TestString)
file.Close()
}	

Sleep 12000

; Anexa o arquivo de log do SinanFTP salvo na subpasta "deng".
if (cArgui2 = "deng")
{
Send c:\SinanFTP\tmp\deng\SinanFTP.log
}

; Anexa o arquivo de log do SinanFTP salvo na subpasta "chik".
if (cArgui2 = "chik")
{
Send c:\SinanFTP\tmp\chik\SinanFTP.log
}

Sleep 6000

Send {Enter}

Sleep 15000

; Envia o e-mail e fecha o firefox.

Send ^{Enter}
Sleep 15000
Send ^+Q

file := FileOpen("c:\SinanFTP\mail\SinanFTPMail.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Email enviado. Finalizando script. `r`n"
file.Write(TestString)
file.Close()
RunWait, log_close2.bat, c:\SinanFTP\bat, max ; finaliza e renomeia o log.
Sleep 5000
ExitApp
