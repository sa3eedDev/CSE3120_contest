INCLUDE Irvine32.inc
BUFMAX = 128 


.data
sun BYTE "SUNDAY ",0
mon BYTE "MONDAY ",0
tue BYTE "TUESDAY ",0
wed BYTE "WEDNESDAY ",0
thu BYTE "THURSDAY ",0
fri BYTE "FRIDAY ",0
sat BYTE "SATURDAY ",0
SetTimer BYTE "Set Timer: ",13,10,0
TimeUp   BYTE "Time is up",0
titleStr BYTE "Vine Virtual assistant",0
Welcome BYTE "Hello, my name is Byte your virtual assistent",13,10,0
UsernameM BYTE "What is your name?",13,10,0
Welcoming BYTE "Nice to meet you ", 0 
help BYTE "How can I help you?",13,10,0
Username DWORD ?
buffer   BYTE   BUFMAX+1 DUP(0)
bufSize  DWORD  ?

colon BYTE ":", 0
dash  BYTE "/", 0

sysTime SYSTEMTIME<>


.code
main PROC
 INVOKE SetConsoleTitle, ADDR titleStr
 ;mov   edx,OFFSET Welcome		
 ;call  WriteString
 ;call GetUsername
 ;mov edx, OFFSET Welcoming
 ;call  WriteString
 ;mov edx, Username
 ;call  WriteString
 ;call Crlf
 ;mov edx,OFFSET help
 ;call WriteString
 call PrintTime
 call PrintDate
 call Timer
 ;call math

 exit
main endp

;-----------------------------------------------------
GetUsername PROC 
;
; function that get username  
; 
; Receives: nothing
; Returns: nothing
;-----------------------------------------------------
	pushad
	mov	edx,OFFSET UsernameM	; display a prompt
	call	WriteString
	mov	ecx,BUFMAX		; maximum character count
	mov	edx,OFFSET buffer   ; point to the buffer
	call	ReadString         	; input the string
	mov Username, edx
	call	Crlf
	popad
	ret
GetUsername ENDP

PrintTime PROC

 push eax
 push edx

 INVOKE GetLocalTime, ADDR sysTime
 movzx eax, sysTime.wHour
 call WriteDec
 mov edx,OFFSET colon
 call WriteString
 movzx eax, sysTime.wMinute
 call WriteDec
 ;mov edx,OFFSET colon
 call WriteString
 movzx eax, sysTime.wSecond
 call WriteDec
 call Crlf
 
 pop edx
 pop eax
 ret

PrintTime ENDP

PrintDate PROC
 push edx

 INVOKE GetLocalTime, ADDR sysTime
 
 movzx edx,sysTime.wDayOfWeek
 cmp edx, 0
 je sunl
 cmp edx, 1
 je monl
 cmp edx, 2
 je tuel
 cmp edx, 3
 je wedl
 cmp edx, 4
 je thul
 cmp edx, 5
 je fril
 cmp edx, 6
 je satl

sunl:
 mov edx,OFFSET sun
 call WriteString
 jmp continue
 
monl:
 mov edx,OFFSET mon
 call WriteString
 jmp continue

tuel:
 mov edx,OFFSET tue
 call WriteString
 jmp continue

wedl:
 mov edx,OFFSET wed
 call WriteString
 jmp continue

thul:
 mov edx,OFFSET thu
 call WriteString
 jmp continue

fril:
 mov edx,OFFSET fri
 call WriteString
 jmp continue

satl:
 mov edx,OFFSET satl
 call WriteString
 


continue:

 movzx eax, sysTime.wMonth
 call WriteDec
 mov edx,OFFSET dash
 call WriteString

 movzx eax, sysTime.wDay
 call WriteDec
 call WriteString

 movzx eax, sysTime.wYear
 call WriteDec

 call Crlf

 pop edx
 ret
PrintDate ENDP

Timer PROC

 push edx
 push ecx
 push eax
 

 mov edx,OFFSET SetTimer
 call WriteString
 mov	ecx,BUFMAX		; maximum character count
 mov	edx,OFFSET buffer   ; point to the buffer
 call	ReadInt
 mov ebx, 60000
 mul ebx
 invoke sleep, eax

 INVOKE MessageBox, NULL, ADDR TimeUp, 
   ADDR TimeUp, MB_OK + MB_ICONINFORMATION 

 pop eax
 pop ecx
 pop edx
 ret
Timer ENDP


math PROC

 push ecx
 push edx
 
 mov	ecx,BUFMAX		; maximum character count
 mov	edx,OFFSET buffer   ; point to the buffer
 call	ReadString   
 .IF buffer[1] == "+"
	mov al, buffer[0]
	sub al, 48
	mov dl, buffer[2]
	sub dl, 48
	add al, dl
 .ELSEIF buffer[0] == "-"
	mov al, buffer[1]
	sub al, 48
	mov dl, buffer[3]
	sub dl, 48
	sub al, dl
 .ELSEIF buffer[1] == "-"
    mov al, buffer[0]
	sub al, 48
	mov dl, buffer[2]
	sub dl, 48
	sub al, dl
 .ENDIF
 call WriteDec

 pop edx
 pop ecx
 ret
math ENDP



end main