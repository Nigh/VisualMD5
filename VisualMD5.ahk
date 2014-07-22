#NoEnv

If !pToken := Gdip_Startup()
{
	MsgBox, 48, gdiplus error!, Gdiplus failed to start. Please ensure you have gdiplus on your system
	ExitApp
}
; On exiting the program we will go to Exit subroutine to clean up any resources
OnExit, Exit
Gui, +E0x80000 -Caption +OwnDialogs +Owner +AlwaysOnTop +hwndGui1
Gui, Show

width:=256
height:=256

hbm := CreateDIBSection(width, height)
hdc := CreateCompatibleDC()
obm := SelectObject(hdc, hbm)
G := Gdip_GraphicsFromHDC(hdc)
Gdip_SetSmoothingMode(G, 4)

pBrush := Gdip_BrushCreateSolid(0xdd000000), pPen := Gdip_CreatePen(0x22ffffff, 2)
; Gdip_FillRectangle(G, pBrush, 1, 1, 255, 255)
Gdip_FillEllipse(G, pBrush, 0, 0, 256, 256)

txt:="彦君"
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
	pos:={x:x[A_Index]-2,y:y[A_Index]-2}
	pos:=rect2circle(pos,127)

	; Gdip_DrawEllipse(G, pPen, x[A_Index]-2, y[A_Index]-2, 4, 4)
	Gdip_DrawEllipse(G, pPen, pos.x, pos.y, 4, 4)
}

Loop, 15
{
	pos1:={x:x[A_Index],y:y[A_Index]}
	pos1:=rect2circle(pos1,127)
	pos2:={x:x[A_Index+1],y:y[A_Index+1]}
	pos2:=rect2circle(pos2,127)

	; Gdip_DrawLine(G, pPen, x[A_Index], y[A_Index], x[A_Index+1], y[A_Index+1])
	Gdip_DrawLine(G, pPen, pos1.x, pos1.y, pos2.x, pos2.y)
}
; Gdip_TextToGraphics(G, txt, "y35p Centre cbbffffff r4 s40","造字工房悦黑体验版特细体",255,255)
Gdip_TextToGraphics(G, txt, "y40p Centre cbbffffff r4 s60","叶根友刀锋黑草",255,255)
; Gdip_TextToGraphics(G, txt, "y35p Centre cbbffffff r4 s40","微软雅黑",255,255)
UpdateLayeredWindow(Gui1, hdc, 0, 0, width, height)
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

rect2circle(pos,R)
{
	angle:=ATan((R-pos.x)/(R-pos.y))
	Return, {x:R-cos(angle)*(R-pos.x),y:R-cos(angle)*(R-pos.y)}
}
