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

userInput BYTE ?
menuListM BYTE "Here are things I can do:" ,10,13
		 BYTE "1. Tell a joke", 10,13
		 BYTE "2. Give inspiration quote" ,10,13
		 BYTE "3. Set a timer", 10,13, 0
askForUserInputM BYTE 10,13,"Please input (1,2,or 3): ", 0
invalidInputM BYTE "Invalid Input, Please enter again",10,13,0


q1 BYTE "Don't judge each day by the harvest you reap but by the seeds that you plant.",10,13,0
q2 BYTE "Start by doing what's necessary; then do what's possible; and suddenly you are doing the impossible.",10,13,0
q3 BYTE "The best preparation for tomorrow is doing your best today.",10,13,0
q4 BYTE "If opportunity doesn't knock, build a door.",10,13,0
q5 BYTE "A champion is someone who gets up when he can't.",10,13,0

quotes DWORD q1,q2,q3,q4,q5

j1 BYTE "I'm not anti-social; I'm just not user friendly." ,10,13,0
j2 BYTE "We have enough youth—how about a fountain of smart?",10,13,0
j3 BYTE "A Programmer was walking out of door for work, his wife said “while you’re out, buy some milk”",10,13,0
   BYTE "and he never came home.",10,13,0
j4 BYTE "Boss: What is your address?",10,13
   BYTE "Me: 173.168.15.10", 10,13
   BYTE "Boss: No, your local address",10,13
   BYTE "Me: 127.0.01",10,13
   BYTE "Boss: I mean your physical address",10,13
   BYTE "Me: 29:01:38:62:31:58",10,13,0
j5 BYTE "I was so blind, my friend suggested learn programing, now I CSharp", 10,13,0

jokes DWORD j1,j2,j3,j4,j5




colon BYTE ":", 0
dash  BYTE "/", 0
sysTime SYSTEMTIME<>

.code
main PROC
 INVOKE SetConsoleTitle, ADDR titleStr
 mov   edx,OFFSET Welcome		
 call  WriteString
 call GetUsername
 mov edx, OFFSET Welcoming
 call  WriteString
 mov edx, Username
 call  WriteString
 call Crlf
 mov edx,OFFSET help
 call WriteString
 ;call PrintTime
 ;call PrintDate
 call PrintMenuList
 call PromtUserForInput

 ;call Timer
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

;-----------------------------------------------------
PrintMenuList PROC  
; 
; Receives: nothing
; Returns: nothing
;-----------------------------------------------------
	mov edx, OFFSET menuListM
	call WriteString
	ret	
PrintMenuList ENDP

;-----------------------------------------------------
PromtUserForInput PROC  
; This keep asking for user input until esc is pressed
;
; Receives: nothing
; Returns: nothing
;-----------------------------------------------------
startLoop:
	mov edx, OFFSET askForUserInputM
	call WriteString
	call ReadInt

	cmp eax, 9
	je endLoop

	cmp eax, 1
	je getJoke

	cmp eax, 2
	je getQuote

	cmp eax, 3
	je getTimer

	jmp askAgain

getJoke:
	call GetAJoke
	jmp startLoop
getQuote:
	call GetAQuote
	jmp startLoop
getTimer:
	call Timer
	jmp startLoop

askAgain:
	mov edx, OFFSET invalidInputM
	call WriteString
	jmp startLoop
endLoop:
	ret
promtUserForInput ENDP

;-------------
GetAJoke PROC
	mov eax, 5
	call RandomRange		  ;generate random number from 0 - 4
	
	mov edx,[jokes + 4*eax]  ; get random jokes and print out
	call WriteString
	
	ret
GetAJoke ENDP

;--------------
GetAQuote PROC
	mov eax, 5
	call RandomRange		  ;generate random number from 0 - 4
	
	mov edx,[quotes + 4*eax]  ; get random quotes and print out
	call WriteString
	
	ret
GetAQuote ENDP


;--------------
PrintTime PROC
;--------------
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
 ret 8

PrintTime ENDP

;--------------
PrintDate PROC
;--------------
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

;----------
Timer PROC
;----------
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