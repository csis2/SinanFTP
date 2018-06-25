#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; config.exe - versão 1.0 - CSIS Software.
; Configura os logins e senhas para utilização do SinanFTP.

; biblioteca para criptografia.
#Include Crypt.ahk
#Include CryptConst.ahk
#Include CryptFoos.ahk

; Variáveis globais
GLOBAL cString := ""

; Constroi a interface gráfica do usuário (GUI).
Gui, Margin, 1, 10
Gui, font, s9, MS sans serif
Gui, Add, Text, x10 y8 w300 h20, Forneça os dados abaixo para configurar o SinanFTP.
Gui, Add, Tab3, x10 y30 w280 h250, Acesso PC|E-mail|Sinan Online|Servidor Proxy

Gui, Tab, 1,
Gui, Add, Checkbox, x20 y50 w250 h50 vPC, Utilizar login e senha do PC para reagendar uma tarefa que falhou.
Gui, Add, Text, x20 y100 w250 h20, Digite o domínio da rede do PC.
Gui, Add, Edit, x20 y120 w250 h20 vPCDomain
Gui, Add, Text, x20 y145 w250 h20, Digite o login para acesso ao PC.
Gui, Add, Edit, x20 y160 w250 h20 vPCLogin
Gui, Add, Text, x20 y185 w320 h20, Digite a senha de acesso ao PC.
Gui, Add, Edit, x20 y200 w250 h20 vPCPass +password
Gui, Add, Text, x20 y225 w320 h20, Digite novamente a senha de acesso ao PC.
Gui, Add, Edit, x20 y240 w250 h20 vPCPass2 +password

Gui, Tab, 2,
Gui, Add, Checkbox, x20 y50 w250 h50 vMail, Utilizar uma conta do Gmail para enviar relatórios e avisos sobre as ações do SinanFTP.
Gui, Add, Text, x20 y100 w250 h20, Digite o login da conta de e-mail.
Gui, Add, Edit, x20 y120 w250 h20 vMailLogin
Gui, Add, Text, x20 y145 w250 h20, Digite a senha da conta de e-mail.
Gui, Add, Edit, x20 y160 w250 h20 vMailSenha +password
Gui, Add, Text, x20 y185 w320 h20, Digite novamente a senha da conta de e-mail.
Gui, Add, Edit, x20 y200 w250 h20 vMailSenha2 +password
Gui, Add, Text, x20 y225 w250 h20, Digite o(s) e-mail(s) de destino.
Gui, Add, Edit, x20 y240 w250 h20 vMailDest

Gui, Tab, 3,
Gui, Add, Text, x20 y60 w250 h20, Digite o login de acesso ao Sinan Online.
Gui, Add, Edit, x20 y80 w250 h20 vSinanLogin
Gui, Add, Text, x20 y105 w250 h20, Digite a senha de acesso ao Sinan Online.
Gui, Add, Edit, x20 y120 w250 h20 vSinanSenha +password
Gui, Add, Text, x20 y145 w320 h20, Digite novamente a senha de acesso ao Sinan Online.
Gui, Add, Edit, x20 y160 w250 h20 vSinanSenha2 +password

Gui, Tab, 4,
Gui, Add, Checkbox, x20 y60 w320 h20 vRedeProxy, Utilizo servidor proxy para acesso à Internet.
Gui, Add, Text, x20 y85 w250 h20, Digite o login de autenticação da rede Proxy.
Gui, Add, Edit, x20 y105 w250 h20 vProxyLogin
Gui, Add, Text, x20 y130 w250 h20, Digite a senha de autenticação da rede Proxy.
Gui, Add, Edit, x20 y150 w250 h20 vProxySenha +password
Gui, Add, Text, x20 y175 w320 h20, Digite novamente a senha de autenticação.
Gui, Add, Edit, x20 y195 w250 h20 vProxySenha2 +password

Gui, Tab
Gui, Add, Button, x190 y290 w100 h28 0x8000 gVerifica, &OK
Gui, Add, Button, x80 y290 w100 h28 0x8000 gCancela, &Cancela

Gui, Show

return

;*************************************************************************************************************************

; label para checar os valores passados pelo usuario.
Verifica:

Gui,Submit, Nohide

; Verifica se a caixa de checagem da aba "Servidor Proxy" está marcada e a caixa de texto do login esta preenchida.
IF (RedeProxy) && (ProxyLogin == "")
{
msgbox O login de autenticação da rede Proxy não foi preenchido.
return
}

; Verifica se a caixa de checagem da aba "Servidor Proxy" está marcada e se a caixa de texto da primeira senha esta preenchida.
IF (RedeProxy) && (ProxySenha == "")
{
msgbox A senha de autenticação da rede Proxy não foi preenchida.
return
}

; Verifica se a caixa de checagem da aba "Servidor Proxy" está marcada e se a caixa de texto da segunda senha esta preenchida.
IF (RedeProxy) && (ProxySenha2 == "")
{
msgbox A senha de autenticação da rede Proxy não foi redigitada.
return
}

; Verifica se a caixa de checagem da aba "Servidor Proxy" está marcada e se a primeira senha e a segunda senha são iguais.
IF (RedeProxy) && (ProxySenha <> ProxySenha2)
{
msgbox As senhas digitadas para autenticação da rede Proxy são diferentes uma da outra.
return
}

; Verifica se a caixa de checagem da aba "Servidor Proxy" está marcada e se a primeira senha e a segunda senha tem tamanhos iguais.
IF (RedeProxy) && (StrLen(ProxySenha) <> StrLen(ProxySenha2))
{
msgbox As senhas digitadas para autenticação da rede Proxy tem tamanhos diferentes uma da outra.
return
}

;*************************************************************************************************************************

; Verifica se a caixa de checagem da aba "E-mail" está marcada e a caixa de texto do login esta preenchida.
IF (Mail) && (MailLogin == "")
{
msgbox O login da conta de e-mail não foi preenchido.
return
}

; Verifica se a caixa de checagem da aba "E-mail" está marcada e se a caixa de texto da primeira senha esta preenchida.
IF (Mail) && (MailSenha == "")
{
msgbox A senha da conta de e-mail não foi digitada.
return
}

; Verifica se a caixa de checagem da aba "E-mail" está marcada e se a caixa de texto da segunda senha esta preenchida.
IF (Mail) && (MailSenha2 == "")
{
msgbox A senha da conta de e-mail não foi redigitada.
return
}

; Verifica se a caixa de checagem da aba "E-mail" está marcada e se a primeira senha e a segunda senha são iguais.
IF (Mail) && (MailSenha <> MailSenha2)
{
msgbox As senhas digitadas da conta de e-mail são diferentes uma da outra.
return
}

; Verifica se a caixa de checagem da aba "E-mail" está marcada e se a primeira senha e a segunda senha tem tamanhos iguais.
IF (Mail) && (StrLen(MailSenha) <> StrLen(MailSenha2))
{
msgbox As senhas digitadas da conta de e-mail tem tamanhos diferentes uma da outra.
return
}

; Verifica se a caixa de texto do(s) destinatario(s) do e-mail está preenchida.
IF (Mail) && (MailDest == "")
{
msgbox A caixa de texto do(s) destinatário(s) do e-mail não foi preenchido.
return
}

;*************************************************************************************************************************

; Verifica na aba "Sinan Online" se a caixa de texto do login esta preenchida.
IF (SinanLogin == "")
{
msgbox O login do Sinan Online não foi digitado.
return
}

; Verifica na aba "Sinan Online" se a caixa de texto da senha esta preenchida. 
IF (SinanSenha == "")
{
msgbox A senha do Sinan Online não foi digitada.
return
}

; Verifica na aba "Sinan Online" se a senha foi redigitada.
IF (SinanSenha2 == "")
{
msgbox A senha do Sinan Online não foi redigitada.
return
}

; Verifica na aba "Sinan Online" se a primeira senha e a segunda senha são iguais.
IF (SinanSenha <> SinanSenha2)
{
msgbox As senhas digitadas do Sinan Online são diferentes uma da outra.
return
}

; Verifica na aba "Sinan Online" se a primeira senha e a segunda senha tem tamanhos iguais.
IF (StrLen(SinanSenha) <> StrLen(SinanSenha2))
{
msgbox As senhas digitadas do Sinan Online tem tamanhos diferentes uma da outra.
return
}

;*************************************************************************************************************************

; Verifica se a caixa de checagem da aba "Acesso PC" está marcada e a caixa de texto de login esta preenchida.
IF (PC) && (PCLogin == "")
{
msgbox O login de acesso ao PC não foi digitado.
return
}

; Verifica se a caixa de checagem da aba "Acesso PC" está marcada e se a caixa de texto da primeira senha esta preenchida.
IF (PC) && (PCPass == "")
{
msgbox A senha de acesso ao PC não foi digitada.
return
}

; Verifica se a caixa de checagem da aba "Acesso PC" está marcada e se a caixa de texto da segunda senha esta preenchida.
IF (PC) && (PCPass2 == "")
{
msgbox A senha de acesso ao PC não foi redigitada.
return
}

; Verifica se a caixa de checagem da aba "Acesso PC" está marcada e se a primeira senha e a segunda senha são iguais.
IF (PC) && (PCPass <> PCPass2)
{
msgbox As senhas digitadas para acesso ao PC são diferentes uma da outra.
return
}

; Verifica se a caixa de checagem da aba "Acesso PC" está marcada e se a primeira senha e a segunda senha tem tamanhos iguais.
IF (PC) && (StrLen(PCPass) <> StrLen(PCPass2))
{
msgbox As senhas digitadas para acesso ao PC tem tamanhos diferentes uma da outra.
return
}

;*************************************************************************************************************************

IF (RedeProxy)
{
; Lê o login e a senha da aba "Servidor Proxy" e as transferem para o arquivo SetSinanFTP2.ini.
IniWrite, true, c:\SinanFTP\set\SetSinanFTP2.ini, PROXY, Usa?
IniWrite, %ProxyLogin%, c:\SinanFTP\set\SetSinanFTP2.ini, PROXY, Login
hash := Crypt.Encrypt.StrEncrypt(ProxySenha,"B65C8825FB47B72A8A15EF85E48C0C8BD5C50D51",5,1) ; encripta a string usando encriptação AES_128
IniWrite, % hash, c:\SinanFTP\set\SetSinanFTP2.ini, PROXY, Pass
}

IF (Mail)
{
; Lê o login e a senha da aba "E-mail" e as transferem para o arquivo SetSinanFTP2.ini.
IniWrite, true, c:\SinanFTP\set\SetSinanFTP2.ini, E-MAIL, Usa?
IniWrite, %MailLogin%, c:\SinanFTP\set\SetSinanFTP2.ini, E-MAIL, Login
hash := Crypt.Encrypt.StrEncrypt(MailSenha,"B65C8825FB47B72A8A15EF85E48C0C8BD5C50D51",5,1) ; encripta a string usando encriptação AES_128
IniWrite, % hash, c:\SinanFTP\set\SetSinanFTP2.ini, E-MAIL, Pass
IniWrite, %MailDest%, c:\SinanFTP\set\SetSinanFTP2.ini, E-MAIL, Dest
}

IF (PC)
{
; Lê o login e a senha da aba "Acesso PC" e as transferem para o arquivo SetSinanFTP2.ini. ;
IniWrite, true, c:\SinanFTP\set\SetSinanFTP2.ini, ACESSO PC, Usa?
IniWrite, %PCDomain%, c:\SinanFTP\set\SetSinanFTP2.ini, ACESSO PC, Domain
IniWrite, %PCLogin%, c:\SinanFTP\set\SetSinanFTP2.ini, ACESSO PC, Login
hash := Crypt.Encrypt.StrEncrypt(PCPass,"B65C8825FB47B72A8A15EF85E48C0C8BD5C50D51",5,1) ; encripta a string usando encriptação AES_128
IniWrite, % hash, c:\SinanFTP\set\SetSinanFTP2.ini, ACESSO PC, Pass
}

; Lê o login e a senha da aba "Sinan Online" e as transferem para o arquivo SetSinanFTP2.ini.
IniWrite, %SinanLogin%, c:\SinanFTP\set\SetSinanFTP2.ini, SINAN ONLINE, Login
hash := Crypt.Encrypt.StrEncrypt(SinanSenha,"B65C8825FB47B72A8A15EF85E48C0C8BD5C50D51",5,1) ; encripta a string usando encriptação AES_128
IniWrite, % hash, c:\SinanFTP\set\SetSinanFTP2.ini, SINAN ONLINE, Pass

; Reseta os valores contidos em RedeProxy, Mail e Acesso PC caso não tenham sido habilitados para uso no aplicativo config.exe.

IF ! (RedeProxy)
{
IniWrite, false, c:\SinanFTP\set\SetSinanFTP2.ini, PROXY, Usa?
IniWrite,%cString%,c:\SinanFTP\set\SetSinanFTP2.ini, PROXY, Login
IniWrite,%cString%,c:\SinanFTP\set\SetSinanFTP2.ini, PROXY, Pass
}
IF ! (Mail)
{
IniWrite, false, c:\SinanFTP\set\SetSinanFTP2.ini, E-MAIL, Usa?
IniWrite,%cString%,c:\SinanFTP\set\SetSinanFTP2.ini, E-MAIL, Login
IniWrite,%cString%,c:\SinanFTP\set\SetSinanFTP2.ini, E-MAIL, Pass
}
IF ! (PC)
{
IniWrite, false, c:\SinanFTP\set\SetSinanFTP2.ini, ACESSO PC, Usa?
IniWrite,%cString%,c:\SinanFTP\set\SetSinanFTP2.ini, ACESSO PC, Domain
IniWrite,%cString%,c:\SinanFTP\set\SetSinanFTP2.ini, ACESSO PC, Login
IniWrite,%cString%,c:\SinanFTP\set\SetSinanFTP2.ini, ACESSO PC, Pass
}

msgbox As configurações foram salvas.

;*************************************************************************************************************************

; label para cancelar a execução da aplicação.
Cancela:
ExitApp