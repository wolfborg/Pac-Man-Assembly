;Title: Pacman in Assembly
;Contributors: Jordan Williams, Derek Chaplin, Cam Mielbye
INCLUDE Irvine/Irvine32.inc

.data
BigDotTime dd ?
EatGhostsFlag db 0
StartTime dd ?
EndGameFlag db 0
DotsGoneFlag db 246
PortalFlag db 0
MoveTimeStart dd 0
CollisionFlag db 0
UPARROW BYTE 48h
DOWNARROW BYTE 50h
LEFTARROW BYTE 4Bh
RIGHTARROW BYTE 4Dh
PacPosX db 26
PacPosY db 23
;GhostArray db 0Ch,23,14,0Bh,25,14,0Dh,28,14,0Eh,30,14
PacPosLastX db 2
PacPosLastY db 0
PacSymLast db '<'
PacCollVal dw 1
PacCollValLast dw 2
PacCollPos dw 657
ScoreX db 63
ScoreY db 4
Score dw 0
NoMoreFruit dd 0
FruitTime dd 0
boardArray  db '############################', ;28 per row
			   '#............##............#', 
			   '#.####.#####.##.#####.####.#', 
			   '#o####.#####.##.#####.####o#',
			   '#.####.#####.##.#####.####.#', 
			   '#..........................#', 
			   '#.####.##.########.##.####.#', 
			   '#.####.##.########.##.####.#',	;This is used for collision.
			   '#......##....##....##......#',
			   '######.##### ## #####.######', 
			   '######.##### ## #####.######'
		    db '######.##          ##.######',
			   '######.## ######## ##.######', 
			   '######.## #      # ##.######', 
			   '      .   #      #   .      ', 
			   '######.## #      # ##.######',	;It is a little hard to read but its the 
			   '######.## ######## ##.######', 
			   '######.##          ##.######', 
			   '######.## ######## ##.######', 
			   '######.## ######## ##.######',
			   '#............##............#' 
		   db  '#.####.#####.##.#####.####.#', 
			   '#.####.#####.##.#####.####.#', 
			   '#o..##.......  .......##..o#',	;same as the map below.
			   '###.##.##.########.##.##.###', 
			   '###.##.##.########.##.##.###', 
			   '#......##..........##......#', 
			   '#.##########.##.##########.#',
			   '#.##########.##.##########.#', 
			   '#..........................#', 
			   '############################'
row1  db "# # # # # # # # # # # # # # # # # # # # # # # # # # # #    ___________________ ",0
row2  db "# . . . . . . . . . . . . # # . . . . . . . . . . . . #   |                   |",0  
row3  db "# . # # # # . # # # # # . # # . # # # # # . # # # # . #   |  <Current Score>  |",0  
row4  db "# o # # # # . # # # # # . # # . # # # # # . # # # # o #   |                   |",0  
row5  db "# . # # # # . # # # # # . # # . # # # # # . # # # # . #   |    -              |",0  ;64 for current score
row6  db "# . . . . . . . . . . . . . . . . . . . . . . . . . . #   |___________________|",0  
row7  db "# . # # # # . # # . # # # # # # # # . # # . # # # # . #   |                   |",0  
row8  db "# . # # # # . # # . # # # # # # # # . # # . # # # # . #   |   <Past Scores>   |",0  
row9  db "# . . . . . . # # . . . . # # . . . . # # . . . . . . #   |                   |",0  
row10 db "# # # # # # . # # # # #   # #   # # # # # . # # # # # #   |   1:              |",0  ;64 for past scores
row11 db "# # # # # # . # # # # #   # #   # # # # # . # # # # # #   |   2:              |",0  
row12 db "# # # # # # . # #                     # # . # # # # # #   |   3:              |",0  
row13 db "# # # # # # . # #   # # # - - # # #   # # . # # # # # #   |   4:              |",0  
row14 db "# # # # # # . # #   #             #   # # . # # # # # #   |   5:              |",0  
row15 db "            .       #             #       .               |   6:              |",0  
row16 db "# # # # # # . # #   #             #   # # . # # # # # #   |   7:              |",0  
row17 db "# # # # # # . # #   # # # # # # # #   # # . # # # # # #   |   8:              |",0  
row18 db "# # # # # # . # #                     # # . # # # # # #   |   9:              |",0  
row19 db "# # # # # # . # #   # # # # # # # #   # # . # # # # # #   |  10:              |",0 
row20 db "# # # # # # . # #   # # # # # # # #   # # . # # # # # #   |  11:              |",0  
row21 db "# . . . . . . . . . . . . # # . . . . . . . . . . . . #   |  12:              |",0  
row22 db "# . # # # # . # # # # # . # # . # # # # # . # # # # . #   |  13:              |",0  
row23 db "# . # # # # . # # # # # . # # . # # # # # . # # # # . #   |  14:              |",0  
row24 db "# o . . # # . . . . . . .     . . . . . . . # # . . o #   |  15:              |",0  
row25 db "# # # . # # . # # . # # # # # # # # . # # . # # . # # #   |___________________|",0  
row26 db "# # # . # # . # # . # # # # # # # # . # # . # # . # # #   |                   |",0  
row27 db "# . . . . . . # # . . . . . . . . . . # # . . . . . . #   |   <High Score>    |",0 
row28 db "# . # # # # # # # # # # . # # . # # # # # # # # # # . #   |                   |",0 
row29 db "# . # # # # # # # # # # . # # . # # # # # # # # # # . #   |    -              |",0  ;64 for High score
row30 db "# . . . . . . . . . . . . . . . . . . . . . . . . . . #   |                   |",0 
row31 db "# # # # # # # # # # # # # # # # # # # # # # # # # # # #   |___________________|",0 
LinePos dd 0
PrintX db 0
PrintY db 0
PrintPacX db 0
PrintPacY db 0
PrintPacSym db '<'
TopBorDelay dd 5
StarMess BYTE "Starring:",0
PacMess BYTE "Pacman",0
ClrMess BYTE "            ",0
DirKeyMess BYTE "Use the ARROW keys to move Pacman",0
Clyde BYTE "Clyde",0
Pinky BYTE "Pinky",0
Inky BYTE "Inky",0
Blinky BYTE "Blinky",0
PacmanTitle1  db "#########    #######   #########  #       #   #######   #         #",0
PacmanTitle2  db "#        #  #       #  #          ##     ##  #       #  ##        #",0
PacmanTitle3  db "#        #  #       #  #          # #   # #  #       #  # #       #",0
PacmanTitle4  db "#        #  #       #  #          #  # #  #  #       #  #  #      #",0
PacmanTitle5  db "#        #  #       #  #          #   #   #  #       #  #   #     #",0
PacmanTitle6  db "#########   #########  #          #       #  #########  #    #    #",0
PacmanTitle7  db "#           #       #  #          #       #  #       #  #     #   #",0
PacmanTitle8  db "#           #       #  #          #       #  #       #  #      #  #",0
PacmanTitle9  db "#           #       #  #          #       #  #       #  #       # #",0
PacmanTitle10 db "#           #       #  #          #       #  #       #  #        ##",0
PacmanTitle11 db "#           #       #  #########  #       #  #       #  #         #",0

.code
main PROC
	Call Randomize
	;CALL StartScreen
	CALL CLRSCR
	CALL PrintBoard
	CALL SpawnGhosts
	mov eax, 1000
	CALL Delay

	mov eax, 0
	CALL GetMSeconds
	mov StartTime,eax

	Game:
		Call Movements
		CALL CheckFruit
		CALL CheckEndGame
		CALL CheckTime
		CMP EndGameFlag, 1
		jne Game

exit
main ENDP

PrintBoard PROC
	mov eax, 15
	CALL SetTextColor
	mov ecx, 31
	mov edx, OFFSET row1 - 80

BoardLoop:
	
	ADD edx, 80
	CALL writestring
	CALL CRLF

	Loop BoardLoop

	mov dl, PacPosX
	mov dh, PacPosY
	CALL GoTOXY
	mov eax, 14
	CALL SetTextColor
	mov al, '<'
	CALL writechar

RET 
PrintBoard ENDP

.data
GhostColors db 0Ch, 0Bh, 0Dh, 0Eh
GhostXs db 23, 25, 28, 30
GhostYs db 14, 14, 14, 14
GhostCollisions dd 349, 349, 349, 349
GhostDirs db 0, 0, 0, 0
GhostSpawn db 1, 1, 1, 1	;used to check if Ghost is in spawn zone

.code
SpawnGhosts PROC USES eax ecx edx esi
	mov eax, 0
	mov ecx, 4
	mov esi, 0

	Spawn:
		mov al, GhostColors[esi]
		Call SetTextColor
		mov dl, GhostXs[esi]
		mov dh, GhostYs[esi]
		Call GotoXY
		mov al, 'G'
		Call WriteChar
		inc esi
		loop Spawn

	ret
SpawnGhosts ENDP

CheckGhostSpawnZone PROC USES eax ebx edx
	mov al, GhostSpawn[esi]
	cmp eax, 1
	je Spawn
	jmp ToEnd

Spawn:
	cmp esi, 0
	je RedSpawn
	cmp esi, 1
	je BlueSpawn
	cmp esi, 2
	je PinkSpawn
	cmp esi, 3
	je OrangeSpawn

ToSpawn:
	mov dl, GhostXs[esi]
	mov dh, GhostYs[esi]
	Call GotoXY
	mov al, ' '
	Call WriteChar

	mov GhostYs[esi], 11
	mov GhostXs[esi], 26
	
	mov bl, EatGhostsFlag
	cmp bl, 1
	je BlueGhost

	mov al, GhostColors[esi]
	Call SetTextColor

Continue:
	mov dl, GhostXs[esi]
	mov dh, GhostYs[esi]
	Call GotoXY
	mov al, 'G'
	Call WriteChar
	
	mov GhostSpawn[esi], 0
	mov GhostCollisions[esi*(type GhostCollisions)], 321
	jmp ToEnd

RedSpawn:
	Call GetMSeconds
	sub eax, StartTime
	cmp eax, 10000
	jge ToSpawn
BlueSpawn:
	Call GetMSeconds
	sub eax, StartTime
	cmp eax, 15000
	jge ToSpawn
PinkSpawn:
	Call GetMSeconds
	sub eax, StartTime
	cmp eax, 20000
	jge ToSpawn
OrangeSpawn:
	Call GetMSeconds
	sub eax, StartTime
	cmp eax, 25000
	jge ToSpawn
	jmp ToEnd

BlueGhost:
	mov al, 9
	Call SetTextColor
	jmp Continue

ToEnd:
	ret
CheckGhostSpawnZone ENDP

;directions: 0 = up  1 = down  2 = left  3 = right
GhostMove PROC USES eax ebx ecx edx esi
	mov eax, 0
	mov ecx, 4
	mov edx, 0
	mov esi, 0

	Move:
		mov al, GhostSpawn[esi]
		cmp al, 1
		je SpawnTime
		jmp RegularMove
		
	SpawnTime:
		Call CheckGhostSpawnZone
		jmp EndLoop

	RegularMove:
		;empty old spot
		mov dl, GhostXs[esi]
		mov dh, GhostYs[esi]
		Call GotoXY
		mov al, ' '
		Call WriteChar

		;set new spot
		Call GhostNextMove

		;print in new spot
		mov dl, GhostXs[esi]
		mov dh, GhostYs[esi]
		Call GotoXY

		mov bl, EatGhostsFlag
		cmp bl, 1
		je BlueGhost

		mov al, GhostColors[esi]
		Call SetTextColor

	Continue:
		mov al, 'G'
		Call WriteChar

	EndLoop:
		inc esi
		loop Move
		jmp ToEnd

BlueGhost:
	mov al, 9
	Call SetTextColor
	jmp Continue

ToEnd:
	Call GhostCollideCheck
	ret

GhostMove ENDP

.data
DirAvailable db 0,0,0,0

.code
GhostNextMove PROC USES eax ecx edx
	Call GhostDirCheck
	mov al, GhostDirs[esi]
	cmp al, 0
	je MoveUp
	cmp al, 1
	je MoveDown
	cmp al, 2
	je MoveLeft
	cmp al, 3
	je MoveRight

MoveUp:
	sub GhostCollisions[esi*(type GhostCollisions)], 28
	sub GhostYs[esi], 1
	jmp ToEnd
MoveDown:
	add GhostCollisions[esi*(type GhostCollisions)], 28
	add GhostYs[esi], 1
	jmp ToEnd
MoveLeft:
	sub GhostCollisions[esi*(type GhostCollisions)], 1
	sub GhostXs[esi], 2
	jmp ToEnd
MoveRight:
	add GhostCollisions[esi*(type GhostCollisions)], 1
	add GhostXs[esi], 2

ToEnd:
	ret
GhostNextMove ENDP

GhostDirCheck PROC USES eax ebx ecx edx edi
	mov DirAvailable[0], 0
	mov DirAvailable[1], 0
	mov DirAvailable[2], 0
	mov DirAvailable[3], 0

	mov eax, 0
	mov edi, 0
	mov edx, 0

	mov al, GhostDirs[esi]
	cmp al, 0
	je CheckUp
	cmp al, 1
	je CheckDown
	cmp al, 2
	je CheckLeft
	cmp al, 3
	je CheckRight

CheckUp:
	mov edi, GhostCollisions[esi*(type GhostCollisions)]
	sub edi, 28
	mov al, boardArray[edi]
	cmp al, '#'
	je ChangeDir
	jmp ToEnd
CheckDown:
	mov edi, GhostCollisions[esi*(type GhostCollisions)]
	add edi, 28
	mov al, boardArray[edi]
	cmp al, '#'
	je ChangeDir
	jmp ToEnd
CheckLeft:
	mov edi, GhostCollisions[esi*(type GhostCollisions)]
	sub edi, 1
	mov al, boardArray[edi]
	cmp al, '#'
	je ChangeDir
	jmp ToEnd
CheckRight:
	mov edi, GhostCollisions[esi*(type GhostCollisions)]
	add edi, 1
	mov al, boardArray[edi]
	cmp al, '#'
	je ChangeDir
	jmp ToEnd

ChangeDir:
CheckAvailable:
	mov edi, GhostCollisions[esi*(type GhostCollisions)]
	sub edi, 28
	mov al, boardArray[edi]
	cmp al, '#'
	jne DirAvailableUp
Continue1:
	mov edi, GhostCollisions[esi*(type GhostCollisions)]
	add edi, 28
	mov al, boardArray[edi]
	cmp al, '#'
	jne DirAvailableDown
Continue2:
	mov edi, GhostCollisions[esi*(type GhostCollisions)]
	sub edi, 1
	mov al, boardArray[edi]
	cmp al, '#'
	jne DirAvailableLeft
Continue3:
	mov edi, GhostCollisions[esi*(type GhostCollisions)]
	add edi, 1
	mov al, boardArray[edi]
	cmp al, '#'
	jne DirAvailableRight
	jmp ToChoice

DirAvailableUp:
	mov DirAvailable[0], 1
	jmp Continue1
DirAvailableDown:
	mov DirAvailable[1], 1
	jmp Continue2
DirAvailableLeft:
	mov DirAvailable[2], 1
	jmp Continue3
DirAvailableRight:
	mov DirAvailable[3], 1

ToChoice:
	mov ebx, 0
	mov eax, 0
	mov ecx, 1

	DirChoice:
		mov eax, 4
		mov ebx, 0
		Call RandomRange
		mov bl, DirAvailable[eax]
		cmp bl, 1
		je ChoiceEnd
		inc ecx
		loop DirChoice

ChoiceEnd:
	mov GhostDirs[esi], al
ToEnd:
	ret
GhostDirCheck ENDP

Movements PROC
	mov eax, 150	;delay in milliseconds, smaller = faster game
	mov ecx, 1

	Speed:	
		Call Delay
		je Movement
		inc ecx
		loop Speed

	Movement:
	Call PacMove
	Call GhostMove

	ret
Movements ENDP

MoveInput PROC USES edx
	Call readkey

	ret
MoveInput ENDP

PacMove PROC
	mov eax, 14
	Call SetTextColor

	mov dl, PacPosX
	mov dh, PacPosY
	CALL GoToXY
	mov eax, 0
	CALL MoveInput

	CMP ah, UPARROW
	je DeltaUp
	CMP ah, DOWNARROW
	je DeltaDown
	CMP ah, LEFTARROW
	je DeltaLeft
	CMP ah, RIGHTARROW
	je DeltaRight
	jmp DeltaLast

	DeltaUp:
		mov PacCollVal, -28
		CALL PacmanCollision
		CMP CollisionFlag, 1
		je Moved
		mov dh, PacPosY
		mov dl, PacPosX
		CALL GoToXY
		mov al, 20h
		CALL writechar
		dec PacPosY
		mov dh, PacPosY
		CALL GoToXY
		mov PacSymLast, 'v'
		mov al, 'v'
		CALL writechar
		mov PacPosLastY, -1
		mov PacPosLastX, 0		
		jmp Moved
	
	DeltaDown:
		mov PacCollVal, 28
		CALL PacmanCollision
		CMP CollisionFlag, 1
		je Moved
		mov dh, PacPosY
		mov dl, PacPosX
		CALL GoToXY
		mov al, 20h
		CALL writechar
		inc PacPosY
		mov dh, PacPosY
		CALL GoToXY
		mov PacSymLast, '^'
		mov al, '^'
		CALL writechar
		mov PacPosLastY, 1
		mov PacPosLastX, 0
		jmp Moved

	DeltaLeft:
		mov PacCollVal, -1
		CALL PacmanCollision
		CALL PortalCheck
		CMP PortalFlag, 1
		je Moved
		CMP CollisionFlag, 1
		je Moved
		mov dh, PacPosY
		mov dl, PacPosX
		CALL GoToXY
		mov al, 20h
		CALL writechar
		SUB PacPosX, 2
		mov dl, PacPosX
		CALL GoToXY
		mov PacSymLast, '>'
		mov al, '>'
		CALL writechar
		mov PacPosLastY, 0
		mov PacPosLastX, -2
		jmp Moved
	
	DeltaRight:
		mov PacCollVal, 1
		CALL PacmanCollision
		CALL PortalCheck
		CMP PortalFlag, 1
		je Moved
		CMP CollisionFlag, 1
		je Moved
		mov dh, PacPosY
		mov dl, PacPosX
		CALL GoToXY
		mov al, 20h
		CALL writechar
		ADD PacPosX,2
		mov dl, PacPosX
		CALL GoToXY
		mov PacSymLast, '<'
		mov al, '<'
		CALL writechar
		mov PacPosLastY, 0
		mov PacPosLastX, 2
		jmp Moved
	
	DeltaLast:
		CALL PacmanCollision
		CALL PortalCheck
		CMP PortalFlag, 1
		je Moved
		CMP CollisionFlag, 1
		je Moved
		mov dl, PacPosX
		mov dh, PacPosY
		CALL GoToXY
		mov al, 20h
		CALL writechar
		add dl, PacPosLastX
		add dh, PacPosLastY
		mov PacPosX, dl
		mov PacPosY, dh
		CALL GoToXY
		mov al, PacSymLast
		CALL writechar

Moved:
mov PortalFlag, 0

Call GhostCollideCheck
RET
PacMove ENDP

PrintCurrentScore PROC
	mov edx, 0
	mov eax, 0
	mov dl, ScoreX
	mov dh, ScoreY
	CALL GoToXY
	mov ax, Score
	call writedec
RET
PrintCurrentScore endp

PacmanCollision PROC USES ebx
	mov ebx, 0
	mov bx, PacCollPos
	add bx, PacCollVal
	CMP boardArray[bx], '#'
	je HitWall
	CMP boardArray[bx], '.'
	je HitDotSmall
	CMP boardArray[bx], 'o'
	je HitDotBig
	CMP boardArray[bx], 'F'
	je HitFruit
	mov CollisionFlag, 0
	JMP ExitProc

	HitWall:
		mov CollisionFlag, 1
		call PrintCurrentScore
		JMP ExitProcWall

	HitDotSmall:
		add Score, 10 
		call PrintCurrentScore
		dec DotsGoneFlag
		mov CollisionFlag, 0
		JMP ExitProc

	HitDotBig:
		add Score, 50 
		call PrintCurrentScore
		dec DotsGoneFlag
		mov CollisionFlag, 0
		mov eax, 0
		CALL GetMSeconds
		mov BigDotTime, eax
		mov EatGhostsFlag, 1
		CALL BigDotEffect
		JMP ExitProc

	HitFruit:
		add Score, 200 
		call PrintCurrentScore
		mov dh, 23
		mov dl, 28
		CALL GoToXY
		mov al, ' '
		mov boardArray[658], 0
		mov CollisionFlag, 0
		JMP ExitProc

ExitProc:
mov PacCollPos, bx
mov boardArray[bx],0
ExitProcWall:
RET
PacmanCollision ENDP

GhostCollideCheck PROC USES eax ebx ecx edx esi
	mov eax, 0
	mov ebx, 0
	mov ecx, 4
	mov esi, 0

	CollideCheck:
		mov eax, GhostCollisions[esi*(type GhostCollisions)]
		mov bx, PacCollPos
		cmp eax, ebx
		je KillPacMan
		inc esi
		loop CollideCheck
	jmp ToEnd

KillPacman:
	;Call CLRSCR
	exit

ToEnd:
	ret
GhostCollideCheck ENDP

PortalCheck PROC
	
	CMP PacPosX, 0
	je PortalLeft
	CMP PacPosX, 54
	je PortalRight
	jmp EndPortal

	PortalRight:
			mov dh, PacPosY
			mov dl, PacPosX
			CALL GoToXY
			mov al, 20h
			CALL writechar
			mov PacPosX, 2
			mov PacCollPos,393
			mov PacCollVal, 1
			mov dl, PacPosX
			CALL GoToXY
			mov PortalFlag, 1
			mov PacSymLast, '<'
			mov al, '<'
			CALL writechar
			mov PacPosLastY, 0
			mov PacPosLastX, 2
			jmp EndPortal
	
	PortalLeft:
			mov dh, PacPosY
			mov dl, PacPosX
			CALL GoToXY
			mov al, 20h
			CALL writechar
			mov PacPosX, 52
			mov PacCollPos,418
			mov PacCollVal, -1
			mov dl, PacPosX
			CALL GoToXY
			mov PortalFlag, 1
			mov PacSymLast, '>'
			mov al, '>'
			CALL writechar
			mov PacPosLastY, 0
			mov PacPosLastX, -2
			

EndPortal:
RET
PortalCheck ENDP

StartScreen PROC

	mov eax, 15
	CALL SetTextColor
	CALL PrintPacPos
	inc PrintPacX
	mov eax,500
	CALL Delay
	mov al, 218
	CALL PrintBorPos
	inc PrintX
	CALL PrintPacPos
	inc PrintPacX

	mov ecx, 78
	SideOne:
		CALL PrintPacPos
		inc PrintPacX
		mov al, 196
		CALL PrintBorPos
		inc PrintX
		mov eax, TopBorDelay
		CALL Delay
		Loop SideOne

	mov al, 191
	CALL writechar
	inc PrintY
	add PrintPacY,2
	dec PrintPacX
	mov PrintPacSym, '^'
	CALL PrintPacPos

	mov ecx, 13
	SideTwoU:
		CALL PrintPacPos
		inc PrintPacY
		mov al, 179
		CALL PrintBorPos
		inc PrintY
		mov eax, TopBorDelay
		CALL Delay
		Loop SideTwoU

	mov al, 180
	CALL PrintBorPos
	inc PrintY
	inc PrintPacY

	mov ecx, 7
	SideTwoM:
		CALL PrintPacPos
		inc PrintPacY
		mov al, 179
		CALL PrintBorPos
		inc PrintY
		mov eax, TopBorDelay
		CALL Delay
		Loop SideTwoM

		mov al, 180
	CALL PrintBorPos
	inc PrintY
	inc PrintPacY

	mov ecx, 6
	SideTwoL:
		CALL PrintPacPos
		inc PrintPacY
		mov al, 179
		CALL PrintBorPos
		inc PrintY
		mov eax, TopBorDelay
		CALL Delay
		Loop SideTwoL

	mov al, 217
	CALL PrintBorPos
	dec PrintX
	dec PrintPacX
	dec PrintPacY
	mov PrintPacSym, '>'
	CALL PrintPacPos
	dec PrintPacX

	mov ecx, 78
	SideThree:
		CALL PrintPacPos
		dec PrintPacX
		mov al, 196
		CALL PrintBorPos
		dec PrintX
		mov eax, TopBorDelay
		CALL Delay
		Loop SideThree
	
	mov al, 192
	CALL PrintBorPos
	dec PrintY
	dec PrintPacY
	inc PrintPacX
	mov PrintPacSym, 'v'
	CALL PrintPacPos
	dec PrintPacY

	mov ecx, 6
	SideFourL:
		CALL PrintPacPos
		dec PrintPacY
		mov al, 179
		CALL PrintBorPos
		dec PrintY
		mov eax, TopBorDelay
		CALL Delay
		Loop SideFourL

	mov al, 195
	CALL PrintBorPos
	dec PrintY
	
	mov ecx, 7
	SideFourM:
		CALL PrintPacPos
		dec PrintPacY
		mov al, 179
		CALL PrintBorPos
		dec PrintY
		mov eax, TopBorDelay
		CALL Delay
		Loop SideFourM

	mov al, 195
	CALL PrintBorPos
	dec PrintY
	dec PrintPacY

	mov ecx, 13
	SideFourU:
		CALL PrintPacPos
		dec PrintPacY
		mov al, 179
		CALL PrintBorPos
		dec PrintY
		mov eax, TopBorDelay
		CALL Delay
		Loop SideFourU

	mov PrintPacY, 14
	mov PrintPacX, 1
	mov PrintPacSym, '<'
	CALL PrintPacPos
	add PrintPacY, 8
	CALL PrintPacPos
	inc PrintPacX
	mov PrintX, 1
	mov PrintY, 22
	 
	mov ecx, 77
	TwoLines:
		mov al, 196
		CALL PrintBorPos
		sub PrintY, 8
		CALL PrintBorPos
		inc PrintX
		add PrintY, 8
		CALL PrintPacPos
		sub PrintPacY, 8
		CALL PrintPacPos
		add PrintPacY, 8
		inc PrintPacX
		mov eax, TopBorDelay
		CALL Delay
		Loop TwoLines

	mov al, 196
	CALL PrintBorPos
	sub PrintY, 8
	CALL PrintBorPos
	CALL PrintTitle
RET
StartScreen ENDP

PrintPacPos PROC

	mov dh, PrintPacY
	mov dl, PrintPacX
	mov al, PrintPacSym
	CALL GoToXY
	CALL writechar

RET
PrintPacPos ENDP

PrintBorPos PROC

	mov dh, PrintY
	mov dl, PrintX
	CALL GoToXY
	CALL writechar

RET
PrintBorPos ENDP

PrintTitle PROC uses edx ecx
	
	mov edx, 0
	mov ecx, 11
	mov PrintX, 6
	mov PrintY, 2

	TitleLoop:
		mov dh, PrintY
		mov dl, PrintX
		CALL GoToXY
		CALL PrintLine
		inc PrintY
		add LinePos, 68
		CALL GoToXY
		mov eax, 50
		CALL Delay
		Loop TitleLoop
		
		CALL StarringAnimation
RET
PrintTitle ENDP

PrintLine PROC uses ecx
	mov eax, 14
	CALL SetTextColor
	mov ecx, 68
	mov esi, LinePos
	TitleLoop:
		mov al, PacmanTitle1[esi]
		CALL writechar
		inc esi
		Loop TitleLoop


RET
PrintLine ENDP

StarringAnimation PROC
	
	mov eax, 15
	CALL SetTextColor
	mov eax, 500
	CALL Delay
	mov edx, 0
	mov dh, 17
	mov dl, 36
	CALL GoToXY
	mov edx, OFFSET StarMess
	CALL writestring
	CALL Delay
	
	CALL GhostAnimations
	CALL PacAnimation
	CALL InputMessage

RET
StarringAnimation ENDP

PacAnimation PROC uses ecx
	
	mov eax, 15
	CALL SetTextColor
	mov dh, 18
	mov dl, 20
	mov al, 'o'
	CALL GoToXY
	CALL writechar
	mov eax, 14
	CALL SetTextColor
	mov dh, 17
	mov dl, 0
	CALL GoToXY
	mov al, " "
	CALL Writechar
	mov dh, 18
	mov dl, 0
	CALL GoToXY
	mov al, " "
	CALL Writechar
	mov dh, 19
	mov dl, 0
	CALL GoToXY
	mov al, " "
	CALL Writechar
	mov eax, 300
	CALL Delay
	mov dh, 18
	mov dl, 0
	CALL GoToXY
	mov al, "<"
	CALL Writechar
	mov eax, 500
	CALL Delay

	mov PrintX, 0
	mov PrintY, 18
	mov ecx,20
	MovingPacL:
		mov dh, PrintY
		mov dl, PrintX
		mov al, ' '
		CALL GoToXY
		CALL writechar
		inc PrintX
		mov dl, PrintX
		mov dh, PrintY
		mov al, '<'
		CALL GoToXY
		CALL writechar
		mov eax, 50
		CALL Delay
		Loop MovingPacL
	
	mov eax, 9
	CALL SetTextColor
	mov dh, 18
	mov dl, 39
	CALL GoToXY
	mov al, 'G'
	CALL writechar
	mov eax, 14
	CALL SetTextColor
	mov eax, 300
	CALL Delay

	mov ecx,19
	MovingPacR:
		mov dh, PrintY
		mov dl, PrintX
		mov al, ' '
		CALL GoToXY
		CALL writechar
		inc PrintX
		mov dl, PrintX
		mov dh, PrintY
		mov al, '<'
		CALL GoToXY
		CALL writechar
		mov eax, 50
		CALL Delay
		Loop MovingPacR

	mov ecx, 4
	SpinPac:
		mov dh, 18
		mov dl, 39
		CALL GoToXY
		mov eax, 50
		CALL Delay
		mov al, 'v'
		CALL writechar
		mov dh, 18
		mov dl, 39
		CALL GoToXY
		mov eax, 50
		CALL Delay
		mov al, '>'
		CALL writechar
		mov dh, 18
		mov dl, 39
		CALL GoToXY
		mov eax, 50
		CALL Delay
		mov al, '^'
		CALL writechar
		mov dh, 18
		mov dl, 39
		CALL GoToXY
		mov eax, 50
		CALL Delay
		mov al, '<'
		CALL writechar
		Loop SpinPac

	mov dh, 19
	mov dl, 37 
	CALL GoToXY
	mov edx, OFFSET PacMess
	mov eax, 700
	CALL Delay
	CALL writestring
	mov eax, 600
	CALL Delay

RET
PacAnimation ENDP

GhostAnimations PROC

	CALL BlinkyStar
	CALL PinkyStar
	CALL InkyStar
	CALL ClydeStar

RET
GhostAnimations ENDP 

BlinkyStar PROC

	mov eax, 12
	CALL SetTextColor
	mov dh, 19
	mov dl, 37
	CALL GoToXY
	mov edx, OFFSET ClrMess
	CALL writestring
	mov dh, 18
	mov dl, 39
	CALL GoToXY
	mov al, 'G'
	CALL writechar
	mov eax, 500
	mov dh, 19
	mov dl, 37
	CALL GoToXY
	mov eax, 500
	CALL Delay
	mov edx, OFFSET Blinky
	CALL writestring
	mov eax, 500
	CALL Delay

RET
BlinkyStar ENDP

PinkyStar PROC

	mov eax, 13
	CALL SetTextColor
	mov dh, 19
	mov dl, 37
	CALL GoToXY
	mov edx, OFFSET ClrMess
	CALL writestring
	mov dh, 18
	mov dl, 39
	CALL GoToXY
	mov al, 'G'
	CALL writechar
	mov eax, 500
	mov dh, 19
	mov dl, 37
	CALL GoToXY
	mov eax, 500
	CALL Delay
	mov edx, OFFSET Pinky
	CALL writestring
	mov eax, 500
	CALL Delay

RET
PinkyStar ENDP

InkyStar PROC

	mov eax, 11
	CALL SetTextColor
	mov dh, 19
	mov dl, 37
	CALL GoToXY
	mov edx, OFFSET ClrMess
	CALL writestring
	mov dh, 18
	mov dl, 39
	CALL GoToXY
	mov al, 'G'
	CALL writechar
	mov eax, 500
	mov dh, 19
	mov dl, 38
	CALL GoToXY
	mov eax, 500
	CALL Delay
	mov edx, OFFSET Inky
	CALL writestring
	mov eax, 500
	CALL Delay

RET
InkyStar ENDP

ClydeStar PROC

	mov eax, 14
	CALL SetTextColor
	mov dh, 19
	mov dl, 37
	CALL GoToXY
	mov edx, OFFSET ClrMess
	CALL writestring
	mov dh, 18
	mov dl, 39
	CALL GoToXY
	mov al, 'G'
	CALL writechar
	mov eax, 500
	mov dh, 19
	mov dl, 37
	CALL GoToXY
	mov eax, 500
	CALL Delay
	mov edx, OFFSET Clyde
	CALL writestring
	mov eax, 500
	CALL Delay
	mov dh, 19
	mov dl, 37
	CALL GoToXY
	mov edx, OFFSET ClrMess
	CALL writestring

RET
ClydeStar ENDP

InputMessage PROC uses edx

mov eax, 15
CALL SetTextColor
mov dh,25
mov dl, 24
CALL GoToXY 
mov edx, OFFSET DirKeyMess
CALL writestring
mov dh,27
mov dl, 24
CALL GoToXY 
mov eax, 1750
CALL Delay
RET
InputMessage ENDP

CheckEndGame PROC

	CMP DotsGoneFlag, 0
	je EndGame
	jmp ContinueGame

	EndGame:
		mov EndGameFlag, 1

	ContinueGame:

RET
CheckEndGame ENDP

CheckFruit PROC
	
	CMP FruitTime, 1
	je YesFruit
	CMP DotsGoneFlag, 123
	jne NoFruit
	
	YesFruit:
		mov dh, 23
		mov dl, 28
		CALL GoToXY
		mov eax, 10
		CALL SetTextColor
		mov al, 235
		CALL writechar
		mov boardArray[658], 'F'
		mov eax, 14
		CALL SetTextColor
		mov NoMoreFruit, 1
		mov FruitTime, 2

NoFruit:
RET
CheckFruit ENDP

CheckTime PROC

	CALL GetMSeconds
	mov ebx, eax
	sub eax, StartTime
	sub ebx, BigDotTime

	CMP eax, 60000
	jge FruitFlag
	CMP ebx, 10000
	jge GhostRevert
	jmp DoneTime
	
	FruitFlag:
		CMP FruitTime, 2
		je DoneTime
		mov FruitTime, 1
		jmp DoneTime

	GhostRevert:
		mov EatGhostsFlag,0
		CALL BigDotEffect

DoneTime:
RET
CheckTime ENDP

BigDotEffect PROC USES esi ecx
	mov eax, 0
	mov esi, 0
	mov ecx, 4
	CMP EatGhostsFlag, 1
	je Edible
	jmp Deadly

	Edible:
		mov al, 9
		CALL SetTextColor
		mov al, 'G'
		mov dl, GhostXs[esi]
		mov dh, GhostYs[esi]
		CALL GoToXY
		CALL writechar
		inc esi
		Loop Edible

	jmp BigDotDone
		 
	Deadly:
		mov al, GhostColors[esi]
		CALL SetTextColor
		mov al, 'G'
		mov dl, GhostXs[esi]
		mov dh, GhostYs[esi]
		CALL GoToXY
		CALL writechar
		inc esi
		Loop Deadly
		
BigDotDone:
mov eax, 14
CALL SetTextColor
RET
BigDotEffect ENDP
END main