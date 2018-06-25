#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; Escritor versão 1.0
; CSIS Software
; 19/02/2018

GLOBAL argui2 := "" ; armazena o argumento.

argui2 = %1% ; Armazena o argumento na variavel global 'argui2'.

; Coloca o argumento dentro do arquivo de log com a data e a hora.
file := FileOpen("c:\SinanFTP\log\SinanFTP.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------" argui2 "`r`n"
file.Write(TestString)
file.Close()
