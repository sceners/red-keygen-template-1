.686
.model flat,stdcall
option casemap:none

PNGBTN	=	1

include	Includes.inc
include Graphic\bmpbutn.asm
include	DoKey.inc

.code
start:
invoke GetModuleHandle,NULL
mov hInstance,eax

invoke LoadIcon,eax,200
mov hIcon,eax
invoke LoadCursor,hInstance,300
mov hCursor,eax

AllowSingleInstance addr szWinTitle			;dont allow make multiple window

invoke InitCommonControls
invoke DialogBoxParam,hInstance,MainDlg,0,addr MainProc,0
invoke ExitProcess,NULL

MainProc	proc	hWnd:DWORD, uMsg:DWORD, wParam:DWORD, lParam:DWORD
local	ps:PAINTSTRUCT

push hWnd
pop hWND

.if uMsg == WM_INITDIALOG
invoke SetWindowText,hWnd,addr szWinTitle
invoke SetDlgItemText,hWnd,EditName,addr szNameDefault
invoke SetDlgItemText,hWnd,EditSerial,addr szPressGen
invoke SetWindowPos,hWnd,HWND_TOPMOST,0,0,0,0,SWP_NOMOVE + SWP_NOSIZE
invoke LoadPng,500,addr sizeFrame
mov hIMG,eax
invoke CreatePatternBrush,hIMG
mov hBrush,eax
invoke ImageButton,hWnd,143,205,501,503,502,GenBtn		;custom image button (JPG,BMP,PNG) Left,Up,DownID,UpID,OverID
mov hGen,eax
invoke ImageButton,hWnd,213,205,601,603,602,AboutBtn	;custom image button (JPG,BMP,PNG) Left,Up,DownID,UpID,OverID
mov hAbout,eax
invoke ImageButton,hWnd,283,205,701,703,702,ExitBtn		;custom image button (JPG,BMP,PNG) Left,Up,DownID,UpID,OverID
mov hExit,eax
invoke CreateFontIndirect,addr TxtFont
mov hFont,eax
invoke GetDlgItem,hWnd,EditSerial
mov hSerial,eax
invoke SendMessage,eax,WM_SETFONT,hFont,1
invoke GetDlgItem,hWnd,EditName
mov hName,eax
invoke uFMOD_PlaySong,400,hInstance,XM_RESOURCE
invoke SendMessage,eax,WM_SETFONT,hFont,1
invoke SetLayeredWindowAttributes,hWnd,NULL,204,2
invoke GetWindowLong,hWnd,GWL_EXSTYLE 
or eax,WS_EX_LAYERED 
invoke SetWindowLong,hWnd,GWL_EXSTYLE,eax
invoke SetLayeredWindowAttributes,hWnd,TransColor,0,2
invoke ShowWindow,hWnd,SW_SHOW
invoke SetTimer,hWnd,222,40,addr FadeIn
invoke SetWindowLong,hName,GWL_WNDPROC,addr EditCustomCursor
mov OldWndProc,eax
invoke SetWindowLong,hSerial,GWL_WNDPROC,addr EditCustomCursor2
mov OldWndProc2,eax
invoke SetFocus,hGen

.elseif uMsg == WM_CTLCOLORDLG
return hBrush

.elseif uMsg == WM_PAINT
invoke BeginPaint,hWnd,addr ps
mov edi,eax
lea ebx,rect
assume ebx:ptr RECT
	
invoke GetClientRect,hWnd,ebx
invoke CreateSolidBrush,0
invoke FrameRect,edi,ebx,eax
invoke EndPaint,hWnd,addr ps

.elseif uMsg == WM_CTLCOLOREDIT || uMsg == WM_CTLCOLORSTATIC
invoke GetDlgCtrlID,lParam
.if eax == EditSerial
invoke SetBkMode,wParam,TRANSPARENT
invoke SetTextColor,wParam,00FFFFFFh
invoke SetBkColor,wParam,0h
invoke SetBrushOrgEx,wParam,-8,82,0		;change main image as input background X,Y,Z keep Z value 0
mov eax,hBrush
ret
.elseif eax == EditName
invoke SetBkMode,wParam,TRANSPARENT
invoke SetTextColor,wParam,00FFFFFFh
invoke SetBkColor,wParam,0h
invoke SetBrushOrgEx,wParam,-8,82,0		;change main image as input background X,Y,Z keep Z value 0
mov eax,hBrush
ret
.endif

.elseif uMsg == WM_COMMAND
mov eax,wParam
mov edx,eax
shr edx,16
and eax,0ffffh
.if edx == BN_CLICKED
.if eax == GenBtn
invoke GetDlgItemText,hWnd,EditName,addr NameBuffer,sizeof NameBuffer
.if eax > 20
invoke SetDlgItemText,hWnd,EditSerial,addr TooLong
.elseif eax < 4
invoke SetDlgItemText,hWnd,EditSerial,addr TooShort
.else
mov NameLen,eax
invoke DoKey,hWnd
.endif
.elseif eax == AboutBtn
invoke InitCommonControls
invoke DialogBoxParam,hInstance,AboutDlg,hWnd,addr AboutProc,0
.elseif eax == ExitBtn
invoke SetTimer,hWnd,333,20,addr FadeOut
.endif
.elseif edx == EN_CHANGE
.if eax == EditName
invoke GetDlgItemText,hWnd,EditName,addr NameBuffer,sizeof NameBuffer
.if eax > 20
invoke SetDlgItemText,hWnd,EditSerial,addr TooLong
.elseif eax < 4
invoke SetDlgItemText,hWnd,EditSerial,addr TooShort
.else
mov NameLen,eax
invoke DoKey,hWnd
.endif
.endif
.endif

.elseif uMsg == WM_RBUTTONDOWN
invoke SetCursor,hCursor

.elseif uMsg==WM_LBUTTONDOWN
invoke SetCursor,hCursor
mov MoveDlg,TRUE
invoke SetCapture,hWnd
invoke GetCursorPos,addr OldPos
		
.elseif uMsg==WM_MOUSEMOVE		
invoke SetCursor,hCursor
.if MoveDlg==TRUE
invoke GetWindowRect,hWnd,addr Rect
invoke GetCursorPos,addr NewPos
mov eax,NewPos.x
mov ecx,eax
sub eax,OldPos.x
mov OldPos.x,ecx
add eax,Rect.left
mov ebx,NewPos.y
mov ecx,ebx
sub ebx,OldPos.y
mov OldPos.y,ecx
add ebx,Rect.top
mov ecx,Rect.right
sub ecx,Rect.left
mov edx,Rect.bottom
sub edx,Rect.top
invoke MoveWindow,hWnd,eax,ebx,ecx,edx,TRUE
.endif

.elseif uMsg==WM_LBUTTONUP
invoke SetCursor,hCursor
mov MoveDlg,FALSE
invoke ReleaseCapture

.elseif uMsg == WM_LBUTTONDBLCLK
invoke SetCursor,hCursor

.elseif uMsg == WM_LBUTTONUP
invoke SetCursor,hCursor

.elseif uMsg == WM_RBUTTONDBLCLK
invoke SetCursor,hCursor

.elseif uMsg == WM_RBUTTONDOWN
invoke SetCursor,hCursor

.elseif uMsg == WM_RBUTTONUP
invoke SetCursor,hCursor

.elseif uMsg == WM_MOUSEMOVE
invoke SetCursor,hCursor

.elseif uMsg == WM_MBUTTONDBLCLK
invoke SetCursor,hCursor

.elseif uMsg == WM_MBUTTONDOWN
invoke SetCursor,hCursor

.elseif uMsg == WM_MBUTTONUP
invoke SetCursor,hCursor

.elseif uMsg == WM_CLOSE
invoke DeleteObject,hIMG
invoke DeleteObject,hBrush
invoke uFMOD_PlaySong,0,0,0
invoke EndDialog,hWnd,0
.endif

xor eax,eax
	Ret
MainProc EndP

EditCustomCursor	proc	hWnd:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD
	
.if uMsg==WM_SETCURSOR
invoke SetCursor,hCursor
.else
invoke CallWindowProc,OldWndProc,hWnd,uMsg,wParam,lParam
ret
.endif
	
xor eax,eax
ret
	
	Ret
EditCustomCursor EndP

EditCustomCursor2	proc	hWnd:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD
	
.if uMsg==WM_SETCURSOR
invoke SetCursor,hCursor
.else
invoke CallWindowProc,OldWndProc2,hWnd,uMsg,wParam,lParam
ret
.endif
	
xor eax,eax
ret
	
	Ret
EditCustomCursor2 EndP

LoadPng proc ID:DWORD,pSize:DWORD
local pngInfo:PNGINFO

invoke PNG_Init, addr pngInfo
invoke PNG_LoadResource, addr pngInfo, hInstance, ID
.if !eax
xor eax, eax
jmp @cleanup
.endif
invoke PNG_Decode, addr pngInfo
.if !eax
xor eax, eax
jmp @cleanup
.endif
invoke PNG_CreateBitmap, addr pngInfo, hWND, PNG_OUTF_AUTO, FALSE
.if	!eax
xor eax, eax
jmp @cleanup
.endif
mov edi,pSize
.if edi!=0
lea esi,pngInfo
movsd
movsd
.endif
	
@cleanup:
push eax	
invoke PNG_Cleanup, addr pngInfo
	
pop eax
ret

LoadPng endp

SetClipboard	proc	txtSerial:DWORD
local	sLen:DWORD
local	hMem:DWORD
local	pMem:DWORD
	
invoke lstrlen, txtSerial
inc eax
mov sLen, eax
invoke OpenClipboard, 0
invoke GlobalAlloc, GHND, sLen
mov hMem, eax
invoke GlobalLock, eax
mov pMem, eax
mov esi, txtSerial
mov edi, eax
mov ecx, sLen
rep movsb
invoke EmptyClipboard
invoke GlobalUnlock, hMem
invoke SetClipboardData, CF_TEXT, hMem
invoke CloseClipboard
	
ret

SetClipboard endp

FadeOut proc

sub Transparency,10
invoke SetLayeredWindowAttributes,hWND,TransColor,Transparency,2
cmp Transparency,0
jne @f
invoke SendMessage,hWND,WM_CLOSE,0,0
@@:
	Ret
FadeOut EndP

FadeIn proc

add Transparency,10
invoke SetLayeredWindowAttributes,hWND,TransColor,Transparency,2
cmp Transparency,230
jne @f
invoke KillTimer,hWND,222
@@:
	Ret
FadeIn EndP

AboutProc	proc	hWnd:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD
local ps:PAINTSTRUCT

.if uMsg == WM_INITDIALOG
invoke SetWindowPos,hWnd,HWND_TOPMOST,0,0,0,0,SWP_NOMOVE + SWP_NOSIZE
invoke LoadPng,900,addr sizeFrame2
mov hAboutBg,eax
invoke CreatePatternBrush,hAboutBg
mov hAboutBrush,eax
invoke CreateFontIndirect,addr AboutFont
mov hFont,eax
invoke GetDlgItem,hWnd,AboutText
invoke SendMessage,eax,WM_SETFONT,hFont,0
invoke SetDlgItemText,hWnd,AboutText,addr szAboutText

.elseif uMsg == WM_CTLCOLORDLG
return hAboutBrush

.elseif uMsg == WM_CTLCOLORSTATIC
invoke SetBkMode,wParam,TRANSPARENT
invoke SetTextColor,wParam,00FFFFFFh
invoke SetBkColor,wParam,0h
invoke GetStockObject,NULL_BRUSH
ret

.elseif uMsg == WM_PAINT
invoke BeginPaint,hWnd,addr ps
mov edi,eax
lea ebx,rect
assume ebx:ptr RECT
	
invoke GetClientRect,hWnd,ebx
invoke CreateSolidBrush,0
invoke FrameRect,edi,ebx,eax
invoke EndPaint,hWnd,addr ps

.elseif uMsg == WM_LBUTTONDOWN
invoke SetCursor,hCursor
invoke SendMessage,hWnd,WM_CLOSE,0,0

.elseif uMsg == WM_LBUTTONDBLCLK
invoke SetCursor,hCursor

.elseif uMsg == WM_LBUTTONUP
invoke SetCursor,hCursor

.elseif uMsg == WM_RBUTTONDBLCLK
invoke SetCursor,hCursor

.elseif uMsg == WM_RBUTTONDOWN
invoke SetCursor,hCursor

.elseif uMsg == WM_RBUTTONUP
invoke SetCursor,hCursor

.elseif uMsg == WM_MOUSEMOVE
invoke SetCursor,hCursor

.elseif uMsg == WM_MBUTTONDBLCLK
invoke SetCursor,hCursor

.elseif uMsg == WM_MBUTTONDOWN
invoke SetCursor,hCursor

.elseif uMsg == WM_MBUTTONUP
invoke SetCursor,hCursor

.elseif uMsg == WM_CLOSE
invoke EndDialog,hWnd,0
.endif

xor eax,eax
	Ret
AboutProc EndP
end start