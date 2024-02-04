
!t:: ; ALT+T
Return

^![:: ; CTRL+ALT+[
WinMove, A,, 0, A_ScreenHeight / 2, A_ScreenWidth / 2, A_ScreenHeight / 2
Return

^!]:: ; CTRL+ALT+]
WinMove, A,, A_ScreenWidth / 2, A_ScreenHeight / 2, A_ScreenWidth / 2, A_ScreenHeight / 2
Return

!Left:: ; ALT+Left
WinMove, A,, 0, 0, A_ScreenWidth / 2, A_ScreenHeight
Return

!Right:: ; ALT+Right
WinMove, A,, A_ScreenWidth / 2, 0, A_ScreenWidth / 2, A_ScreenHeight
Return

!{:: ; ALT+{
WinMove, A,, 0, 0, A_ScreenWidth / 2, A_ScreenHeight / 2
Return

!}:: ; ALT+}
WinMove, A,, A_ScreenWidth / 2, 0, A_ScreenWidth / 2, A_ScreenHeight / 2
Return
