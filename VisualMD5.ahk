
If !pToken := Gdip_Startup()
{
	MsgBox, 48, gdiplus error!, Gdiplus failed to start. Please ensure you have gdiplus on your system
	ExitApp
}
; On exiting the program we will go to Exit subroutine to clean up any resources
OnExit, Exit
Gui, +E0x80000 -Caption +OwnDialogs +Owner +AlwaysOnTop +hwndGui1
Gui, Show
hbm := CreateDIBSection(255, 255)
hdc := CreateCompatibleDC()
obm := SelectObject(hdc, hbm)
G := Gdip_GraphicsFromHDC(hdc)
Gdip_SetSmoothingMode(G, 4)

pBrush := Gdip_BrushCreateSolid(0xdd000000), pPen := Gdip_CreatePen(0x22ffffff, 2)
Gdip_FillRectangle(G, pBrush, 1, 1, 255, 255)

txt:="小梦喵"
clipboard:=MD5(txt, StrLen(txt))

getMD5array(txt)
x:=[]
y:=[]
Loop, 16
{
	x[A_Index]:="0x" SubStr(array[A_Index], 1, 2)
	x[A_Index]+=0
	y[A_Index]:="0x" SubStr(array[A_Index], 16, 2)
	y[A_Index]+=0
}

Loop, 16
{
	Gdip_DrawEllipse(G, pPen, x[A_Index]-2, y[A_Index]-2, 4, 4)
}

Loop, 15
{
	Gdip_DrawLine(G, pPen, x[A_Index], y[A_Index], x[A_Index+1], y[A_Index+1])
}
; Gdip_TextToGraphics(G, txt, "y35p Centre cbbffffff r4 s40","造字工房悦黑体验版特细体",255,255)
Gdip_TextToGraphics(G, txt, "y40p Centre cbbffffff r4 s40","叶根友刀锋黑草",255,255)
; Gdip_TextToGraphics(G, txt, "y35p Centre cbbffffff r4 s40","微软雅黑",255,255)
UpdateLayeredWindow(Gui1, hdc, 0, 0, 255, 255)
OnMessage(0x201, "WM_LBUTTONDOWN")
Return


Esc::
Exit:
GuiClose:
Gdip_Shutdown(pToken)
ExitApp


getMD5array(txt)
{
	global array
	array:=[]
	oldMD5:=txt
	Loop, 20
	{
		array[A_Index]:=MD5(oldMD5, StrLen(oldMD5))
		oldMD5:=array[A_Index]
	}
}

WM_LBUTTONDOWN()
{
	PostMessage, 0xA1, 2
}
