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
secMinHr BYTE "Seconds (s), min (m), hour (h): ",13,10,0
TimeUp   BYTE "Time is up",0
time     DWORD ?
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

 INVOKE SetConsoleTitle, ADDR titleStr ;change console title for looks
 ;mov   edx,OFFSET Welcome		     ;Welcome msg
 ;call  WriteString
 ;call GetUsername					 ;Get ther user's name
 ;mov edx, OFFSET Welcoming
 ;call  WriteString
 ;mov edx, Username
 ;call  WriteString
 ;call Crlf
 ;mov edx,OFFSET help
 ;call WriteString

 call PrintTime
 call PrintDate
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
	mov	edx,OFFSET UsernameM	     ; display a prompt
	call	WriteString
	mov	ecx,BUFMAX				     ; maximum character count
	call	ReadString				 ; input the string
	mov Username, edx				 ;store the username is a variable
	call	Crlf					 ;to end the line
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



PrintTime PROC
;
; Print the time of the system
;
;
;
;-----------------------------------------------------

 push eax
 push edx

 INVOKE GetLocalTime, ADDR sysTime   ;function used to fetch the system time 
 movzx eax, sysTime.wHour            ;Move the hour to eax to print it
 call WriteDec					     ;Call function write
 mov edx,OFFSET colon				 ;Print Colon to seperate hour from minutes
 call WriteString					 ;	
 movzx eax, sysTime.wMinute			 ;Move the min to eax to print it
 call WriteDec
 ;mov edx,OFFSET colon				 ;Don't need to do that again since it already there
 call WriteString
 movzx eax, sysTime.wSecond          ;Move the sec to eax to print it
 call WriteDec
 call Crlf
 
 ;pop the reg back
 pop edx
 pop eax
 ret 8

PrintTime ENDP



;-----------------------------------------------------
PrintDate PROC
;
; Print the day and the date
;
;
;
;-----------------------------------------------------

 push edx							 ;push the reg we going to use
 push eax


 INVOKE GetLocalTime, ADDR sysTime   ;function used to fetch the system time 
 
 movzx edx,sysTime.wDayOfWeek		 ;Move the day to edx
 cmp edx, 0							 ;Numbers used to tell us what day it is so we translate it to the end user in text	
 je sunl							 ;0 is Sunday and 6 is Saturday
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

sunl:							     ;Made a loop for everyday of the week
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
 mov edx,OFFSET sat
 call WriteString
 


continue:							 ;After printing the day we print the date

 movzx eax, sysTime.wMonth			 ;We move the month to eax to print
 call WriteDec
 mov edx,OFFSET dash
 call WriteString

 movzx eax, sysTime.wDay			 ;We move the day to eax to print
 call WriteDec
 call WriteString

 movzx eax, sysTime.wYear			 ;We move the year to eax to print
 call WriteDec

 call Crlf

 pop eax
 pop edx
 ret
PrintDate ENDP



;-----------------------------------------------------
Timer PROC
;
; Function sets a timer and print a message after
; the time is up.
;
;
;-----------------------------------------------------

;Push used registers

 push edx
 push ecx
 push eax
 push ebx
 

 mov edx,OFFSET SetTimer


 mov edx,OFFSET SetTimer		;Print the msg to user

 call WriteString
 call	ReadInt						 ;Read the input as an Int
 mov edx,OFFSET secMinHr			 ;Print the msg asking user want for hr, min, or sec
 call WriteString
 mov time, eax						 ;save eax in time beacuse ReadString will use eax
 mov	ecx,BUFMAX					 ; maximum character count
 mov	edx,OFFSET buffer			 ; point to the buffer
 call ReadString			
 mov eax, time						 ;Return time to eax for mult	
 cmp buffer, 's'					 ;See what user picked
 je sec
 cmp buffer, 'm'
 je min
 cmp buffer, 'h'
 je hr

sec:
 mov ebx, 1000						 ;1000 = 1sec
 mul ebx
 invoke sleep, eax					 ;put the program in sleep until time is up
 jmp message

min:
 mov ebx, 60000						 ;60000 = 1 min
 mul ebx
 invoke sleep, eax					 ;put the program in sleep until time is up
 jmp message


hr:
 mov ebx, 3600000					 ;3600000 = 1hr
 mul ebx
 invoke sleep, eax					 ;put the program in sleep until time is up

message:							 ;Display a box that the time is up
 INVOKE MessageBox, NULL, ADDR TimeUp, 
   ADDR TimeUp, MB_OK + MB_ICONINFORMATION 

									 ;Pop reg back	
 pop ebx
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