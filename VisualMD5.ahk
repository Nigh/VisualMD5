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

; width:=256
; height:=256
R:=128
mode:="ellipse"	; {ellipse,rect}
length:=17

hbm := CreateDIBSection(2*R, 2*R)
hdc := CreateCompatibleDC()
obm := SelectObject(hdc, hbm)
G := Gdip_GraphicsFromHDC(hdc)
Gdip_SetSmoothingMode(G, 4)

pBrush := Gdip_BrushCreateSolid(0xdd000000), pPen := Gdip_CreatePen(0x22ffffff, 2)
if(mode="rect")
	Gdip_FillRectangle(G, pBrush, 1, 1, 2*R-1, 2*R-1)
else if(mode="ellipse")
	Gdip_FillEllipse(G, pBrush, 0, 0, 2*R, 2*R)

txt:="羡亦"
clipboard:=MD5(txt, StrLen(txt))

getMD5array(txt,array,length)
x:=[]
y:=[]
Loop, % length
{
	x[A_Index]:="0x" SubStr(array[A_Index], 1, 2)
	x[A_Index]+=0
	y[A_Index]:="0x" SubStr(array[A_Index], 16, 2)
	y[A_Index]+=0
}

; x.Insert(56)
; x.Insert(200)
; x.Insert(200)
; x.Insert(56)
; x.Insert(56)

; y.Insert(56)
; y.Insert(56)
; y.Insert(200)
; y.Insert(200)
; y.Insert(56)

Loop, % length
{
	pos:={x:x[A_Index]-2,y:y[A_Index]-2}
	if(mode="rect"){
		Gdip_DrawEllipse(G, pPen, pos.x, pos.y, 4, 4)
	}
	else if(mode="ellipse"){
		pos:=rect2circle2(pos,R)
		Gdip_DrawEllipse(G, pPen, pos.x-2, pos.y-2, 4, 4)
	}
	
}

Loop, % length-1
{
	pos1:={x:x[A_Index],y:y[A_Index]}
	; pos1:=rect2circle2({x:x[A_Index],y:y[A_Index]},R)
	pos2:={x:x[A_Index+1],y:y[A_Index+1]}
	; pos2:=rect2circle2({x:x[A_Index+1],y:y[A_Index+1]},R)

	if(mode="rect")
		Gdip_DrawLine(G, pPen, pos1.x, pos1.y, pos2.x, pos2.y)
	else if(mode="ellipse")
		DrawLineOnCircleTransform(G,pPen,pos1,pos2,R)

	; Gdip_DrawLine(G, pPen, pos1.x, pos1.y, pos2.x, pos2.y)
}
; Gdip_TextToGraphics(G, txt, "y35p Centre cbbffffff r4 s40","造字工房悦黑体验版特细体",255,255)
Gdip_TextToGraphics(G, txt, "y40p Centre cbbffffff r4 s60","叶根友刀锋黑草",255,255)
; Gdip_TextToGraphics(G, txt, "y35p Centre cbbffffff r4 s40","微软雅黑",255,255)
UpdateLayeredWindow(Gui1, hdc, 0, 0, 2*R, 2*R)
OnMessage(0x201, "WM_LBUTTONDOWN")
Return


Esc::
Exit:
GuiClose:
Gdip_Shutdown(pToken)
ExitApp


getMD5array(txt,Byref array,length)
{
	array:=[]
	oldMD5:=txt
	Loop, % length
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

rect2circle2(pos,R)
{
	pos.x:=pos.x-R
	pos.y:=pos.y-R
	p:=abs(pos.x)>abs(pos.y) ? pos.x : pos.y
	p/=(pos.x**2+pos.y**2)**0.5
	pos.x*=abs(p)
	pos.y*=abs(p)
	Return, {x:R+pos.x,y:R+pos.y}
}

DrawLineOnCircleTransform(Byref G,Byref pPen,pos1,pos2,R)
{
	LL:=Round(((pos1.x-pos2.x)**2+(pos1.y-pos2.y)**2)**0.5)
	; Msgbox, % LL
	outPosOld:=rect2circle2({x:pos1.x,y:pos1.y},R)
	Loop, % LL
	{
		outPos:=rect2circle2({x:((-pos1.x+pos2.x)*A_Index/LL+pos1.x),y:((-pos1.y+pos2.y)*A_Index/LL+pos1.y)},R)
		; outPos:={x:((-pos1.x+pos2.x)*A_Index/LL+pos1.x),y:((-pos1.y+pos2.y)*A_Index/LL+pos1.y)}
		Gdip_DrawLine(G, pPen, outPosOld.x, outPosOld.y, outPos.x, outPos.y)
		outPosOld:=outPos
	}
}
