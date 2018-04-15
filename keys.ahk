#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

^h::
    Send,{BS}
    return
;
; Mouse Wheel
;
+^p::
    Send,{WheelUp 3}
    return
+^n::
    Send,{WheelDown 3}
    return
;
; WinActivate
;
!^u::
    WinActivate,ahk_class Chrome_WidgetWin_1
    return
!^v::
    WinActivate,ahk_class Vim
    return
!^n::
    WinActivate,Cygwin ahk_class mintty
    return
!^m::
    WinActivate,ahk_class mintty, ,Cygwin
    return
