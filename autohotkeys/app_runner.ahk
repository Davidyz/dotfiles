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
    WinShow, ahk_exe firefox.exe
return

#Enter::
EnvGet, path, Path ; Get the value of the PATH variable
Loop, Parse, path, `; ; Loop through each path in the PATH variable
{
    If FileExist(A_LoopField "\wezterm-gui.exe") ; Check if wezterm is in the current path
    {
        Run, % A_LoopField "\wezterm-gui.exe" ; Run wezterm
        WinWait, ahk_exe wezterm.exe ; Wait for the window to appear
        WinMaximize ; Maximize the window
        DllCall("SetWindowPos", "uint", WinExist("A"), "uint", 0, "int", 0, "int", 0, "int", 0, "int", 0, "uint", 0x10) ; Set the window on the top without activating it
        return ; Exit the loop
    }
    If FileExist(A_LoopField "\wt.exe") ; Check if windows terminal is in the current path
    {
        Run, % A_LoopField "\wt.exe" ; Run windows terminal
        WinWait, ahk_exe wt.exe ; Wait for the window to appear
        WinMaximize ; Maximize the window
        DllCall("SetWindowPos", "uint", WinExist("A"), "uint", 0, "int", 0, "int", 0, "int", 0, "int", 0, "uint", 0x10) ; Set the window on the top without activating it
        return ; Exit the loop
    }
}
return

