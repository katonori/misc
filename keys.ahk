#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

SCREEN_WIDTH  := A_ScreenWidth
SCREEN_HEIGHT := A_ScreenHeight
TILE_WIDTH_LEFT := A_ScreenWidth/2
X_CENTER_MARGIN := 60
X_RIGHT_MARGIN := 30 
TILE_HEIGHT_FULL := A_ScreenHeight * 0.95
TILE_BORDER_X := TILE_WIDTH_LEFT + X_CENTER_MARGIN
TILE_WIDTH_RIGHT := SCREEN_WIDTH - TILE_BORDER_X - X_RIGHT_MARGIN
AltTabMenu := false

IME_SET(SetSts, WinTitle="A")    {
	ControlGet,hwnd,HWND,,,%WinTitle%
	if	(WinActive(WinTitle))	{
		ptrSize := !A_PtrSize ? 4 : A_PtrSize
	    VarSetCapacity(stGTI, cbSize:=4+4+(PtrSize*6)+16, 0)
	    NumPut(cbSize, stGTI,  0, "UInt")   ;	DWORD   cbSize;
		hwnd := DllCall("GetGUIThreadInfo", Uint,0, Uint,&stGTI)
	             ? NumGet(stGTI,8+PtrSize,"UInt") : hwnd
	}

    return DllCall("SendMessage"
          , UInt, DllCall("imm32\ImmGetDefaultIMEWnd", Uint,hwnd)
          , UInt, 0x0283  ;Message : WM_IME_CONTROL
          ,  Int, 0x006   ;wParam  : IMC_SETOPENSTATUS
          ,  Int, SetSts) ;lParam  : 0 or 1
}

MoveMouseCursorToFocusedWindow()
{
    WinGetPos, _xpos, _ypos, _width, _height, A
    _xpos_r := _width/2
    _ypos_r := _height/2
    _xpos_a := _xpos + _width/2
    _ypos_a := _ypos + _height/2
    MouseMove _xpos_r,_ypos_r,0,
    WinGetTitle, win_title, A
	SplashImage,,B1 FM14 W400 X%_xpos_a% Y%_ypos_a%,, %win_title%
    SetTimer, RemoveSplash, 2000
    Return
}

RemoveSplash:
    SetTimer, RemoveSplash, Off
	SplashImage,off
    Return

ExtendWindow(diff_w, diff_h)
{
    WinGetPos,_X,_Y,_W,_H,A
    _W := _W + diff_w
    _H := _H + diff_h
    WinMove,A,,_X,_Y,_W,_H
    return
}

MoveKeyCursor(direction)
{
    switch direction {
        case "u": {
            If GetKeyState("Shift", "P") {
                SendInput {Blind}+{Up}
            }
            else {
                SendInput {Up}
            }
        }
        case "d": {
            If GetKeyState("Shift", "P") {
                SendInput {Blind}+{Down}
            }
            else {
                SendInput {Down}
            }
        }
        case "l": {
            If GetKeyState("Shift", "P") {
                SendInput {Blind}+{Left}
            }
            else {
                SendInput {Left}
            }
        }
        case "r": {
            If GetKeyState("Shift", "P") {
                SendInput {Blind}+{Right}
            }
            else {
                SendInput {Right}
            }
        }
        case "e": {
            If GetKeyState("Shift", "P") {
                SendInput {Blind}+{End}
            }
            else {
                SendInput {End}
            }
        }
        case "h": {
            If GetKeyState("Shift", "P") {
                SendInput {Blind}+{Home}
            }
            else {
                SendInput {Home}
            }
        }
    }
}

GetNextKeyAndRunCmd()
{
    global TILE_WIDTH_LEFT
    global TILE_WIDTH_RIGHT
    global TILE_BORDER_X
    Input _Key, L1
    switch _Key {
        case "1": {
            WinGetPos,_X,_Y,_W,_H,A
            WinMove,A,,60,0,TILE_WIDTH_LEFT,1070
        }
        case "2": {
            WinGetPos,_X,_Y,_W,_H,A
            WinMove,A,,60,1080,TILE_WIDTH_LEFT,1070
        }
        case "3": {
            WinGetPos,_X,_Y,_W,_H,A
            WinMove,A,,TILE_BORDER_X,0,TILE_WIDTH_RIGHT,1070
        }
        case "4": {
            WinGetPos,_X,_Y,_W,_H,A
            WinMove,A,,TILE_BORDER_X,1080,TILE_WIDTH_RIGHT,1070
        }
        case "5": {
            WinGetPos,_X,_Y,_W,_H,A
            WinMove,A,,60,0,TILE_WIDTH_LEFT,2100
        }
        case "6": {
            WinGetPos,_X,_Y,_W,_H,A
            WinMove,A,,TILE_BORDER_X,0,TILE_WIDTH_RIGHT,2100
        }
        case "p": WinSet, AlwaysOnTop, TOGGLE, A
        case "s": SendInput, ^!{s}
        case "r": Reload
    }
    return
}

GetNextKeyAndResizeWindow()
{
    global TILE_WIDTH_LEFT
    global TILE_WIDTH_RIGHT
    global TILE_HEIGHT_FULL
    global TILE_BORDER_X
    Input _Key, L1
    switch _Key {
        case "1": {
            WinGetPos,_X,_Y,_W,_H,A
            WinMove,A,,60,0,TILE_WIDTH_LEFT,1070
            MoveMouseCursorToFocusedWindow()
        }
        case "q": {
            WinGetPos,_X,_Y,_W,_H,A
            WinMove,A,,60,1080,TILE_WIDTH_LEFT,1070
            MoveMouseCursorToFocusedWindow()
        }
        case "2": {
            WinGetPos,_X,_Y,_W,_H,A
            WinMove,A,,TILE_BORDER_X,0,TILE_WIDTH_RIGHT,1070
            MoveMouseCursorToFocusedWindow()
        }
        case "w": {
            WinGetPos,_X,_Y,_W,_H,A
            WinMove,A,,TILE_BORDER_X,1080,TILE_WIDTH_RIGHT,1070
            MoveMouseCursorToFocusedWindow()
        }
        case "3": {
            WinGetPos,_X,_Y,_W,_H,A
            WinMove,A,,60,0,TILE_WIDTH_LEFT,TILE_HEIGHT_FULL
            MoveMouseCursorToFocusedWindow()
        }
        case "4": {
            WinGetPos,_X,_Y,_W,_H,A
            WinMove,A,,TILE_BORDER_X,0,TILE_WIDTH_RIGHT,TILE_HEIGHT_FULL
            MoveMouseCursorToFocusedWindow()
        }
    }
    return
}

Insert:: Return
^h:: Send,{BS}
^M:: SendInput, {Enter}
+Esc:: SendInput, {``}

;;;
;;; date
;;;
::;d;::
FormatTime,TimeString,,yyyyMMdd
Send,%TimeString%
Return

::;d/;::
FormatTime,TimeString,,yyyy/MM/dd
Send,%TimeString%
Return

::;d-;::
FormatTime,TimeString,,yyyy-MM-dd
Send,%TimeString%
Return

#q::
<^g::
<^q::
    GetNextKeyAndRunCmd()
    return

#w::
<^w::
    GetNextKeyAndResizeWindow()
    return

;
; Window focus
;
FocusWindow()
{
    Input Key, CL1
    switch Key {
        case "c": WinActivate,ahk_exe chrome.exe
        case "b": WinActivate,ahk_exe msedge.exe
        case "f": WinActivate,ahk_exe WinSCP.exe
        case "m": WinActivate,ahk_class mintty
        case "t": WinActivate,ahk_exe Teams.exe
        case "w": WinActivate,Cygwin ahk_class mintty
        case "E": WinActivate,ahk_class TablacusExplorer
        case "e": WinActivate,ahk_exe explorer.exe
        case "s": WinActivate,ahk_exe slack.exe
        case "x": WinActivate,ahk_class XLMAIN
        case "o": WinActivate,ahk_exe OUTLOOK.EXE
        case "v": WinActivate,ahk_class Vim
        case "p": WinActivate,ahk_class PPTFrameClass
        case "r": WinActivate,ahk_exe mstsc.exe
        case "i": WinActivate,ahk_exe iexplore.exe
        case "n": WinActivate,ahk_class ApplicationFrameWindow
        case "d": {
            if WinExist("SuperPuTTY ahk_exe SuperPutty.exe") {
                WinActivate  ; Uses the last found window.
                Sleep 100
                WinActivate  ; Uses the last found window.
                MouseClick ,Left
            }
        }
        default:
            ;; do nothing
            return
    }
    MoveMouseCursorToFocusedWindow() ;; move cursor
    return
}
!^f::
    FocusWindow()
    return

;
; Application Specific
;
#IfWinActive ahk_class TablacusExplorer
+^a:: SendInput, {Alt down}{Left}{Alt Up}
+^s:: SendInput, {Alt down}{Right}{Alt Up}
#IfWinActive

#IfWinActive ahk_exe msedge.exe
+^n::
    SendInput, ^{l}
    Click, L, , 300, 200
    SendInput, {b}
    return
^n:: SendInput, {Down}
^p:: SendInput, {Up}
!1:: SendInput, +^{Tab}
!2:: SendInput, ^{Tab}
#IfWinActive

; onenote
#IfWinActive ahk_exe ApplicationFrameHost.exe
^k:: SendInput, {Shift down}{End}{Del}{Shift up}
#IfWinActive

#m:: WinMinimize, A
#z:: WinMinimize, A
!^z:: WinMinimize, A

; PrintScreen
^!q::  SendInput, {LWin Down}{PrintScreen}{LWin Up}
vkac:: SendInput, {LWin Down}{PrintScreen}{LWin Up}

XButton2::
    IfWinActive ahk_exe msedge.exe
    {
        SendInput, {Alt down}{Space}
        Sleep 100
        SendInput, {m}{Alt up}
    }
    Else
    {
        WinGetPos, xpos, ypos, width, height, A
        pos := width - 300
        Click,%pos%,20,0
    }
    return
+WheelDown::WheelRight
+WheelUp::WheelLeft

;; select text
#+j::
    Send, {LButton Down}
    MouseMove 100,0,0,R
    Send, {LButton Up}
    return

;;;;;;;;;;;;;;;
;;;; 無変換
;;;;;;;;;;;;;;;
vk1d & g:: SendInput, {Esc}
vk1d & x:: SendInput, {Del}
vk1d & h:: SendInput, {BS}
vk1d & z:: SendInput, {BS}
vk1d & v:: SendInput, {Shift Down}{Insert}{Shift Up}
vk1d & 1:: SendInput, {Home}
vk1d & 2:: SendInput, {End}
vk1d & f:: SendInput, {PgDn}
vk1d & b:: SendInput, {PgUp}
vk1d & p:: SendInput, {|}
vk1d & Down::
    WinGetPos,X,Y,W,H,A
    Y := Y + 200
    WinMove,A,,X,Y,W,H
    return
vk1d & Up::
    WinGetPos,X,Y,W,H,A
    Y := Y - 200
    WinMove,A,,X,Y,W,H
    return
vk1d & Right::
    WinGetPos,X,Y,W,H,A
    X := X + 200
    WinMove,A,,X,Y,W,H
    return
vk1d & Left::
    WinGetPos,X,Y,W,H,A
    X := X - 200
    WinMove,A,,X,Y,W,H
    return
; num
vk1d & u:: SendInput, {1}
vk1d & i:: SendInput, {2}
vk1d & o:: SendInput, {3}
vk1d & j:: SendInput, {4}
vk1d & k:: SendInput, {5}
vk1d & l:: SendInput, {6}
vk1d & m:: SendInput, {7}
vk1d & ,:: SendInput, {8}
vk1d & .:: SendInput, {9}
vk1d & `;:: SendInput, {0}
; cursor
vk1d & a:: SendInput, {Left}
vk1d & s:: SendInput, {Down}
vk1d & d:: SendInput, {Right}
vk1d & w:: SendInput, {Up}
vk1d & q:: SendInput, {PgUp}
vk1d & e:: SendInput, {PgDn}

;;;;;;;;;;;;;;;
;;;; LAlt
;;;;;;;;;;;;;;;
*~LAlt::Send {Blind}{vk07} ; map to "no mapping" to avoid focusing on the menubar

<!w:: MoveKeyCursor("u")
<!s:: MoveKeyCursor("d")
<!a:: MoveKeyCursor("l")
<!d:: MoveKeyCursor("r")
<!e:: MoveKeyCursor("e")
<!q:: MoveKeyCursor("h")

<!c:: SendInput, {Esc}
<!x:: SendInput, {Del}

;;;;;;;;;;;;;;;
;;; RAlt
;;;;;;;;;;;;;;;
*~RAlt::Send {Blind}{vk07} ; map to "no mapping" to avoid focusing on the menubar

>!j:: IME_SET(1)
>!k:: IME_SET(0)
>!u:: SendInput, {F10}{Enter}    ;;; hankaku
>!o:: SendInput, {F10}{Enter}    ;;; hankaku
>!l:: SendInput, {F10}{Enter}    ;;; hankaku
>!i:: SendInput, {F7}{Enter}     ;;; カタカナ
>!q:: SendInput, {|}
; symbol
>!t:: SendInput, {~}
>!b:: SendInput, {``}
>!p:: SendInput, {|}
>!n:: SendInput, {&}
>!Space:: SendInput, {vkf2}

;;
;; Numpad
;;
NumpadEnter:: SendInput, {Esc}
NumpadSub:: SendInput, {Home}
NumpadAdd:: SendInput, {End}
NumpadDel:: SendInput, {F5}

NumpadPgDn:: SendInput, {Right}
NumpadEnd:: SendInput, {Left}
NumpadDown:: SendInput, {Down}
NumpadClear:: SendInput, {Up}
NumpadRight:: SendInput, {PgDn}
NumpadLeft:: SendInput, {PgUp}

NumpadHome:: SendInput, +^{Tab}
NumpadPgUp:: SendInput, ^{Tab}
NumpadUp:: SendInput, ^w
NumpadDiv:: SendInput, ^!s

;;
;; Numpad(NumLocked)
;;
Numpad3:: SendInput, {Right}
Numpad1:: SendInput, {Left}
Numpad2:: SendInput, {Down}
Numpad5:: SendInput, {Up}
Numpad6:: SendInput, {PgDn}
Numpad4:: SendInput, {PgUp}

;
; Horizontal Scroll
;
#IfWinActive, ahk_exe POWERPNT.EXE
~Lshift & WheelUp::ComObjActive("PowerPoint.Application").ActiveWindow.SmallScroll(0,0,0,10)
~Lshift & WheelDown::ComObjActive("PowerPoint.Application").ActiveWindow.SmallScroll(0,0,10,0)
#IfWinActive

#IfWinActive, ahk_exe EXCEL.EXE
~LShift & WheelUp:: ; Scroll left.
    SetScrollLockState, On
    SendInput {Left}
    SetScrollLockState, Off
    Return
~LShift & WheelDown:: ; Scroll right.
    SetScrollLockState, On
    SendInput {Right}
    SetScrollLockState, Off
#IfWinActive

; 同じアプリ内の次のウィンドウに切り替える
WIN_SameAppNext() {
    WinGetClass, className, A
    WinActivateBottom, ahk_class %className%
}
!Esc::WIN_SameAppNext()

WIN_SameAppPrev() {
    WinGet, thisWindowId, ID, A
    WinGetClass, thisWindowClass, ahk_id %thisWindowId%
    WinGet, allWindowIds, List, , , Program Manager
    Loop, %allWindowIds% {
        StringTrimRight, targetWindowId, allWindowIds%A_index%, 0
        WinGetClass, targetWindowClass, ahk_id %targetWindowId%
        if (thisWindowClass = targetWindowClass) {
            if (thisWindowId <> targetWindowId) {
                WinSet, Bottom, , ahk_id %thisWindowId%
                WinActivate, ahk_id %targetWindowId%
                break
            }
        }
    }
}
!+Esc::WIN_SameAppPrev()
