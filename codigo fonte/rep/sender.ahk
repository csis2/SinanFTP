#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; ajuste de ambiente
DetectHiddenWindows, off
DetectHiddenText, on
CoordMode, Screen  ;
SetTitleMatchMode 2
SetTitleMatchMode Slow  

; Lista de variáveis globais.
GLOBAL cLogin2 := "sinannetgo" ; guarda o login para acessar o SINAN Online.
GLOBAL cSenha2 := "sinan15935" ; guarda a senha para acessar o SINAN Online.

file := FileOpen("c:\SinanFTP\mail\SinanMail.log", "w")
file.Close()
file := FileOpen("c:\SinanFTP\mail\SinanMail.log", "a")
TestString := "************************************************************************************************************`r`n"
file.Write(TestString)
TestString := "*                                                                                                          *`r`n"
file.Write(TestString)
TestString := "*                                          Arquivo de log SinanMail                                        *`r`n"
file.Write(TestString)
TestString := "*                                                                                                          *`r`n"
file.Write(TestString)
TestString := "************************************************************************************************************`r`n"
file.Write(TestString)

FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Começa o processo SinanMail. `r`n"
file.Write(TestString)
file.Close()

Run, "https://www.google.com/gmail/" ; Abre o navegador e acessa o Gmail.

Sleep 25000 ; aguarda 25 segundos pelas próximas instruções.

; gera o PID (process identifier) do Firefox e analisa se ele foi aberto pelo comando Run.
Process, exist, firefox.exe ;
NewPID = %ErrorLevel% 
if NewPID = 0
{
file := FileOpen("c:\SinanFTP\mail\SinanMail.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------O navegador Firefox não foi aberto. `r`n"
file.Write(TestString)
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Finalizando processo SinanMail. `r`n"
file.Write(TestString)
file.Close()
ExitApp ; finaliza o script.
}
else
{
IfWinExist, ahk_pid %NewPID%
WinActivate
file := FileOpen("c:\SinanFTP\mail\SinanMail.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------O navegador Firefox foi aberto. `r`n"
file.Write(TestString)
file.Close()
}

if WinExist("Gmail") ; testa se o site do Gmail foi carregado no navegador.
{
file := FileOpen("c:\SinanFTP\mail\SinanMail.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Aplicação Gmail identificada. `r`n"
file.Write(TestString)
file.Close()
WinActivate
}

else 

{
file := FileOpen("c:\SinanFTP\mail\SinanMail.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Aplicação Gmail não foi identificada. `r`n"
file.Write(TestString)
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Finalizando processo SinanMail. `r`n"
file.Write(TestString)
file.Close()
Process, close, firefox.exe
ExitApp ; finaliza o script.
}	

if WinExist("Gmail") ; Foca na janela do Gmail e maximiza a janela.
{
WinActivate
WinMaximize
file := FileOpen("c:\SinanFTP\mail\SinanMail.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Janela do Firefox maximizada. `r`n"
file.Write(TestString)
file.Close()
}

Sleep, 1000

; Lê o login e a senha no arquivo "SetSinanFTP.ini" e os coloca em variáveis.
IniRead, OutputVar5, c:\SinanFTP\set\SetSinanFTP.ini, EMAIL, Login
cLogin2 = %OutputVar5%
IniRead, OutputVar6, c:\SinanFTP\set\SetSinanFTP.ini, EMAIL, Senha
cSenha2 = %OutputVar6%

Sleep, 1000

; Preenche os campos login e senha do Gmail.
Sendinput %cLogin2%
Sleep 10000
Send {Enter}
Sleep 5000
Sendinput %cSenha2%
Sleep 5000
Send {Enter}

Sleep 10000

if WinExist("endemias.go") ; testa se o acesso ao Gmail foi permitido.
{
file := FileOpen("c:\SinanFTP\mail\SinanMail.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Acesso ao Gmail permitido. `r`n"
file.Write(TestString)
file.Close()
WinActivate
}

else 

{
file := FileOpen("c:\SinanFTP\mail\SinanMail.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Acesso ao Gmail não foi permitido. `r`n"
file.Write(TestString)
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Finalizando processo SinanMail. `r`n"
file.Write(TestString)
file.Close()
Process, close, firefox.exe
ExitApp ; finaliza o script.
}	











