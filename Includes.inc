include	windows.inc
include	kernel32.inc
include	user32.inc
include	gdi32.inc
include	ufmod.inc
include	comctl32.inc
include	winmm.inc
include	masm32.inc
include macros.inc
include	ole32.inc
include oleaut32.inc

includelib	kernel32.lib
includelib	user32.lib
includelib	gdi32.lib
includelib	uFMOD.lib
includelib	comctl32.lib
includelib	winmm.lib
includelib	ole32.lib
includelib  oleaut32.lib
includelib	masm32.lib

include Graphic\BmpFrom.inc
include Graphic\image.inc
includelib Graphic\image.lib

include	Graphic\pnglib.inc
includelib	Graphic\pnglib.lib

MainProc		   proto:DWORD,:DWORD,:DWORD,:DWORD
AboutProc		   proto:DWORD,:DWORD,:DWORD,:DWORD
LoadPng			   proto:DWORD,:DWORD
SetClipboard	   proto:DWORD
FadeIn			   proto
FadeOut			   proto
EditCustomCursor   proto:DWORD,:DWORD,:DWORD,:DWORD
EditCustomCursor2  proto:DWORD,:DWORD,:DWORD,:DWORD

AllowSingleInstance MACRO lpTitle
        invoke FindWindow,NULL,lpTitle
        cmp eax, 0
        je @F
          push eax
          invoke ShowWindow,eax,SW_RESTORE
          pop eax
          invoke SetForegroundWindow,eax
          mov eax, 0
          ret
        @@:
      ENDM
      
.const
MainDlg		=	100
AboutDlg	=	111
EditName	=	101
EditSerial	=	102
GenBtn		=	301
AboutBtn	=	302
ExitBtn		=	303
AboutText	=	222

.data
Transparency		dd 0
TransColor			COLORREF	0FFFFFFFh
sizeFrame			dd	?,?
sizeFrame2			dd	?,?
MoveDlg				BOOL		?
OldPos				POINT		<>
NewPos				POINT		<>
Rect				RECT		<>
rect				RECT		<>
rect2				RECT		<>
handle				dd				?

TxtFont		LOGFONT <-12,0,0,0,FW_NORMAL,FALSE,FALSE,FALSE,0,3,2,1,34,"Verdana">
AboutFont	LOGFONT <-9,0,0,0,FW_NORMAL,FALSE,FALSE,FALSE,0,3,2,1,34,"Tahoma">

szWinTitle	db	"RED Key Generator",0

.data?
hInstance	dd	?
hIcon		dd	?
hCursor		dd	?
hSerial		dd	?
hName		dd	?
hGen		dd	?
hExit		dd	?
hAbout		dd	?
hWND		dd	?
hIMG		dd	?
hBrush		dd	?
hAboutBg	dd	?
hAboutBrush	dd	?
hFont		dd	?
OldWndProc	dd	?
OldWndProc2	dd	?
ModHandle	dd	?