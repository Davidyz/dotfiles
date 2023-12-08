#NoEnv
#SingleInstance Force

SendMode Input
DetectHiddenWindows, on
SetWinDelay, 0

#b::
; run firefox
    ff := WinExist("ahk_exe firefox.exe")
    if (ff) 
    {
        active := WinActive("ahk_id " ff)
        if (active)
            WinMinimize, ahk_id %active%
        else
            WinActivate, ahk_id %ff%
    }
    else
        Run, firefox.exe ,,Max
return

#Enter::
    terminal := WinExist("ahk_exe WindowsTerminal.exe")
    if (terminal) 
    {
        active := WinActive("ahk_id " terminal)
        if (active)
            WinMinimize, ahk_id %active%
        else
            WinActivate, ahk_id %terminal%
    }
    else
        Run, wt.exe ,,Max
return