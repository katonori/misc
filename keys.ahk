#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

^h:: Send,{BS}
^Q:: Send,{Esc}

;
; Window focus
;
!^u:: WinActivate,ahk_class Chrome_WidgetWin_1
!^v:: WinActivate,ahk_class Vim
!^n:: WinActivate,Cygwin ahk_class mintty
!^m:: WinActivate,ahk_class mintty, ,Cygwin
!^i:: WinActivate,ahk_class mintty
!^t:: WinActivate,ahk_exe thunderbird.exe
+^w::
    ; Switch focus among the same class window
    WinGetClass, className, A
    WinActivateBottom, ahk_class %className%

;
; Mouse
;
; Up
#Up::
    MouseMove 0,-10,0,R
    return

; Down
#Down::
    MouseMove 0,10,0,R
    return

; Left
#Left::
    MouseMove -10,0,0,R
    return

; Right
#Right::
    MouseMove 10,0,0,R
    return

; Up fast
#^Up::
    MouseMove 0,-80,0,R
    return

; Down fast
#^Down::
    MouseMove 0,80,0,R
    return

; Left fast
#^Left::
    MouseMove -80,0,0,R
    return

; Right fast
#^Right::
    MouseMove 80,0,0,R
    return

; Left click
#[::
    MouseClick,left,,,,,D
    return
#[ Up::
    MouseClick,left,,,,,U
    return
; Left click
#Enter::
    MouseClick,left,,,,,D
    return
#Enter Up::
    MouseClick,left,,,,,U
    return
; Right click
#]::
    MouseClick ,Right
    return
; Wheel
+^p::
    Send,{WheelUp 3}
    return
+^n::
    Send,{WheelDown 3}
    return

