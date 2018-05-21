#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; Auth_trap versão 1.0 - CSIS Software, abril 2018.
; Aplicativo para capturar a tela de login e senha da rede proxy e preencher os campos de acordo com o que
; foi estipulado no programa config.exe do SinanFTP.

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

; variáveis globais;
GLOBAL cLoginProxyConfig := ""
GLOBAL cSenhaProxyConfig := ""

; Lê no arquivo de configuração se há permissão para trabalhar com acesso ao PC utilizando login e senha.
IniRead, OutputVar33, c:\SinanFTP\set\SetSinanFTP2.ini, PROXY, Usa?
if (OutputVar33 <> "true")
{
msgbox Você não concedeu permissão para trabalhar com a rede proxy do PC.
msgbox Acesse o programa "config.exe" e faça o ajuste necessário.
ExitApp
}

; Lê o login e a senha no arquivo de configuração e os coloca em variáveis.
if (OutputVar33 = "true")
{
IniRead, OutputVar5, c:\SinanFTP\set\SetSinanFTP2.ini, PROXY, Login
cLoginProxyConfig = %OutputVar5%
IniRead, OutputVar, c:\SinanFTP\set\SetSinanFTP2.ini, PROXY, Pass
decrypted_string := Crypt.Encrypt.StrDecrypt(OutputVar,"B65C8825FB47B72A8A15EF85E48C0C8BD5C50D51",5,1)
cSenhaProxyConfig = %decrypted_string%
}

; Fecha os processos que estão utilizando o Firefox.
Process, close, firefox.exe

Run, "http://www.google.com.br" ; Abre o navegador e acessa o site do Google para realizar os testes.

Sleep 60000 ; aguarda um minuto pelas próximas instruções.

if WinExist("Autenticação solicitada") ; Foca na janela de autenticação, se houver.
{
WinActivate
gosub auth
}

if WinExist("Google") ; Foca na página inicial do Google.
{
WinActivate
SendInput a
}

Sleep 30000

if WinExist("Autenticação solicitada") ; Foca na janela de autenticação, se houver.
{
WinActivate
gosub auth
}

if WinExist("Google") ; Foca na página inicial do Google.
{
WinActivate
SendInput u
}

Sleep 30000

if WinExist("Autenticação solicitada") ; Foca na janela de autenticação, se houver.
{
WinActivate
gosub auth
}

if WinExist("Google") ; Foca na página inicial do Google.
{
WinActivate
SendInput t
}

Sleep 30000

if WinExist("Autenticação solicitada") ; Foca na janela de autenticação, se houver.
{
WinActivate
gosub auth
}

; Fecha os processos que estão utilizando o Firefox.
Process, close, firefox.exe

ExitApp ; finaliza o script.

auth:
Sleep 1000
Send %cLoginProxyConfig%
Sleep 1000
Send {Tab}
Send %cSenhaProxyConfig%
Sleep 1000
Send {Tab}
Sleep 1000
Send {Enter}
return
