DoKey	proto	:DWORD

.data
szNameDefault	db	"H!X // RED",0
szPressGen		db	"Press generate to get your serial !",0
TooLong			db	"Your name is too long !",0
TooShort		db	"Your name is too short !",0

szAboutText		db	"Some Application X.X",13,10
				db	"-======================-",13,10
				db	"Keygenned by : H!X // RED",13,10
				db	"Protection : RSA-128",13,10
				db	"-======================-",13,10
				db	"Special thanks to",13,10
				db	"Tiara",13,10
				db	"You're my soul",13,10
				db	"-======================-",13,10,0
				
Format			db	"%u",0

.data?
NameBuffer	db	100 dup(?)
FinalSerial	db	100 dup(?)
NameLen		dd	?
_rand		dd	?

.code
DoKey	proc	hWnd:DWORD
;put your algo here!
invoke GetTickCount
mov _rand,eax
mov eax,NameLen
lea ebx,NameBuffer
mov edx,012345678h
xor ecx,ecx

@@:
mov cl,byte ptr ds:[eax+ebx-1]
xor cl,078h
not cl
add cl,088h
imul edx,ecx
add edx,_rand
dec eax
jnz @b

add edx,087654321h
neg edx

push edx
push offset Format
push offset FinalSerial
call wsprintf

invoke SetDlgItemText,hWnd,EditSerial,addr FinalSerial
invoke SetClipboard,addr FinalSerial
invoke RtlZeroMemory,addr NameBuffer,sizeof NameBuffer
invoke RtlZeroMemory,addr FinalSerial,sizeof FinalSerial

	Ret
DoKey EndP