;Title
;Contributors
INCLUDE Irvine/Irvine32.inc
.data
PortalFlag db 0
MoveTimeStart dd 0
CollisionFlag db 0
UPARROW BYTE 48h
DOWNARROW BYTE 50h
LEFTARROW BYTE 4Bh
RIGHTARROW BYTE 4Dh
PacPosX db 26
PacPosY db 23
PacPosLastX db 2
PacPosLastY db 0
PacSymLast db '<'
PacCollVal dw 1
PacCollValLast dw 2
PacCollPos dw 657
boardArray  db '############################', 
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
row2  db "# . . . . . . . . . . . . # # . . . . . . . . . . . . #   |    < Scores >     |",0  
row3  db "# . # # # # . # # # # # . # # . # # # # # . # # # # . #   |    1:             |",0  ;67 is the position in each line where the score will be placed
row4  db "# o # # # # . # # # # # . # # . # # # # # . # # # # o #   |    2:             |",0  ;72 for the High score line
row5  db "# . # # # # . # # # # # . # # . # # # # # . # # # # . #   |    3:             |",0  
row6  db "# . . . . . . . . . . . . . . . . . . . . . . . . . . #   |    4:             |",0  
row7  db "# . # # # # . # # . # # # # # # # # . # # . # # # # . #   |    5:             |",0  
row8  db "# . # # # # . # # . # # # # # # # # . # # . # # # # . #   |    6:             |",0  
row9  db "# . . . . . . # # . . . . # # . . . . # # . . . . . . #   |    7:             |",0  
row10 db "# # # # # # . # # # # #   # #   # # # # # . # # # # # #   |    8:             |",0  
row11 db "# # # # # # . # # # # #   # #   # # # # # . # # # # # #   |    9:             |",0  
row12 db "# # # # # # . # #                     # # . # # # # # #   |   10:             |",0  
row13 db "# # # # # # . # #   # # # - - # # #   # # . # # # # # #   |   11:             |",0  
row14 db "# # # # # # . # #   #             #   # # . # # # # # #   |   12:             |",0  
row15 db "            .       #             #       .               |   13:             |",0  
row16 db "# # # # # # . # #   #             #   # # . # # # # # #   |   14:             |",0  
row17 db "# # # # # # . # #   # # # # # # # #   # # . # # # # # #   |   15:             |",0  
row18 db "# # # # # # . # #                     # # . # # # # # #   |   16:             |",0  
row19 db "# # # # # # . # #   # # # # # # # #   # # . # # # # # #   |   17:             |",0 
row20 db "# # # # # # . # #   # # # # # # # #   # # . # # # # # #   |   18:             |",0  
row21 db "# . . . . . . . . . . . . # # . . . . . . . . . . . . #   |   19:             |",0  
row22 db "# . # # # # . # # # # # . # # . # # # # # . # # # # . #   |   20:             |",0  
row23 db "# . # # # # . # # # # # . # # . # # # # # . # # # # . #   |   21:             |",0  
row24 db "# o . . # # . . . . . . .     . . . . . . . # # . . o #   |   22:             |",0  
row25 db "# # # . # # . # # . # # # # # # # # . # # . # # . # # #   |   23:             |",0  
row26 db "# # # . # # . # # . # # # # # # # # . # # . # # . # # #   |   24:             |",0  
row27 db "# . . . . . . # # . . . . . . . . . . # # . . . . . . #   |   25:             |",0 
row28 db "# . # # # # # # # # # # . # # . # # # # # # # # # # . #   |                   |",0 
row29 db "# . # # # # # # # # # # . # # . # # # # # # # # # # . #   |                   |",0 
row30 db "# . . . . . . . . . . . . . . . . . . . . . . . . . . #   |HIGH SCORE:        |",0 
row31 db "# # # # # # # # # # # # # # # # # # # # # # # # # # # #   |___________________|",0 

.code
main PROC
	CALL PrintBoard
	CALL SpawnGhosts

	mov ecx, 1
	Game:
		Call Movements

		inc ecx
		Loop Game

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
GhostDirs db 0, 0, 0, 0
GhostSpawn db 1, 1, 1, 1	;used to check if Ghost is in spawn zone

.code
SpawnGhosts PROC USES eax ecx esi
	mov eax, 0
	mov ecx, 4
	mov esi, 0

	Spawn:
		Call GhostUpdate
		inc esi
		loop Spawn
	
	mov eax, 14
	Call SetTextColor		;reset Pac-Man's color

	ret
SpawnGhosts ENDP

;Uses ESI value to update a ghost
GhostUpdate PROC
	mov al, GhostColors[esi]
	Call SetTextColor
	mov dl, GhostXs[esi]
	mov dh, GhostYs[esi]
	Call GotoXY
	mov al, 'G'
	Call WriteChar


ret
GhostUpdate ENDP

GhostMove PROC USES eax ecx edx esi
	mov eax, 0
	mov ecx, 4
	mov esi, 0

	Move:
		mov al, GhostSpawn[esi]
		cmp al, 1
		je SpawnMove

		mov eax, 0
		push esi

		;spawn
		SpawnMove:
			cmp esi, 0
			je RedSpawn
			cmp esi, 1
			je BlueSpawn
			cmp esi, 2
			je PinkSpawn
			cmp esi, 3
			je OrangeSpawn
			jmp RegularMove

		RedSpawn:
		inc GhostXs[esi]

		;Call GhostUpdate

		BlueSpawn:

		PinkSpawn:
		
		OrangeSpawn:


		;directions:
		;0 = up
		;1 = down
		;2 = left
		;3 = right

		RegularMove:

		loop Move

	Moved:
	mov eax, 14
	Call SetTextColor		;reset Pac-Man's color
	ret
GhostMove ENDP

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

MoveInput PROC
	push edx
	Call readkey
	pop edx

	ret
MoveInput ENDP

PacMove PROC
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
		dec PacPosY
		mov al, 20h
		CALL writechar
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
		inc PacPosY
		mov al, 20h
		CALL writechar
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
		SUB PacPosX, 2
		mov al, 20h
		CALL writechar
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
		ADD PacPosX,2
		mov al, 20h
		CALL writechar
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
		mov al, 20h
		CALL writechar
		mov dx, 0
		mov dl, PacPosX
		mov dh, PacPosY
		add dl, PacPosLastX
		add dh, PacPosLastY
		mov PacPosX, dl
		mov PacPosY, dh
		CALL GoToXY
		mov al, PacSymLast
		CALL writechar

Moved:
mov PortalFlag, 0
RET
PacMove ENDP

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
	mov CollisionFlag, 0
	JMP ExitProc

	HitWall:
		mov CollisionFlag, 1
		JMP ExitProcWall

	HitDotSmall:
		;add score to the variable
		mov CollisionFlag, 0
		JMP ExitProc

	HitDotBig:
		;add score to the variable
		mov CollisionFlag, 0
		JMP ExitProc

ExitProc:
mov PacCollPos, bx
ExitProcWall:
RET
PacmanCollision ENDP

PortalCheck PROC
	
	CMP PacPosX, 0
	je PortalLeft
	CMP PacPosX, 54
	je PortalRight
	jmp EndPortal

	PortalRight:
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

END main
