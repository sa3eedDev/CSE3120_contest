INCLUDE Irvine32.inc
BUFMAX = 128 


.data
titleStr BYTE "Vine Virtual assistant",0
Welcome BYTE "Hello, my name is Byte your virtual assistent",13,10,0
UsernameM BYTE "What is your name?",13,10,0
Welcoming BYTE "Nice to meet you ", 0 
help BYTE "How can I help you?",13,10,0
Username DWORD ?
buffer   BYTE   BUFMAX+1 DUP(0)
bufSize  DWORD  ?

colon BYTE ":", 0

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
 ;call PrintTime
 call math

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
 mov edx,OFFSET colon
 call WriteString
 movzx eax, sysTime.wSecond
 call WriteDec
 call Crlf
 
 pop edx
 pop eax
 ret

PrintTime ENDP

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
 .ENDIF
 call WriteDec

 pop edx
 pop ecx
 ret
math ENDP



end main