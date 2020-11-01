INCLUDE Irvine32.inc
BUFMAX = 128 
.data
Welcome BYTE "Hello, my name is Byte your virtual assistent",13,10,0
UsernameM BYTE "What is your name?",13,10,0
Welcoming BYTE "Nice to meet you ", 0 
Username DWORD ?
buffer   BYTE   BUFMAX+1 DUP(0)
bufSize  DWORD  ?


.code
main PROC

 mov   edx,OFFSET Welcome		
 call  WriteString
 call InputTheString
 mov edx, OFFSET Welcoming
 call  WriteString
 mov edx, Username
 call  WriteString

 exit
main endp

;-----------------------------------------------------
InputTheString PROC 
;
; Prompts user for a plaintext string. Saves the string 
; and its length.
; Receives: nothing
; Returns: nothing
;-----------------------------------------------------
	pushad
	mov	edx,OFFSET UsernameM	; display a prompt
	call	WriteString
	mov	ecx,BUFMAX		; maximum character count
	mov	edx,OFFSET buffer   ; point to the buffer
	call	ReadString         	; input the string
	mov	bufSize,eax        	; save the length
	mov Username, edx
	call	Crlf
	popad
	ret
InputTheString ENDP



end main