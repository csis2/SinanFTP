#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

Run, https://accounts.google.com/signin/v2/identifier?sacu=1&scc=1&continue=https`%3A`%2F`%2Fmail.google.com`%2Fmail`%2F&hl=en&service=mail&ss=1&ltmpl=default&rm=false&flowName=GlifWebSignIn&flowEntry=ServiceLogin



