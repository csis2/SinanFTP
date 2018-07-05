;
; AutoHotkey Version: 1.0.48.5
; Language:       English
; Platform:       Win9x/NT
; Author:         BoltOfTom <tom.steadman11@gmail.com>
;
; Script Function:
; Continually display location of the mouse and pixel underneath,
;             by using ToolTip.
;
 
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
 
#SingleInstance Force
if 0 ; screen coordinates
  coord=screen
else
  coord=relative
sleep, 1000
CoordMode, ToolTip, %coord%
CoordMode, Pixel, %coord%
CoordMode, Mouse, %coord%
CoordMode, Caret, %coord%
CoordMode, Menu, %coord%
TrayTip, Mouse Location, Ctrl+Alt+S: Start Application`nF7: Reload Application`nF8: Exit Application`nMode: %coord%, 20, 1 ; Alerts user of hotkeys that they can use.
return
 
Refresh:
MouseGetPos, x, y
PixelGetColor, cBGR, %x%, %y%,, Alt
WinGetPos,,, w, h, A
ToolTip,Location: %x% x %y%`nBGR: %cBGR%`nWindow Size: %w% x %h%
Return
 
^!s:: ; Ctrl + Alt + S
SetTimer, Refresh, 75 ; Waits 75 ms before refreshing.
return
F7::Reload ; Reloads Application
F8::ExitApp ; Terminates Application
