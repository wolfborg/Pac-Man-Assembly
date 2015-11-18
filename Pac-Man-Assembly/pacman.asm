;Title
;Contributors
INCLUDE Irvine/Irvine32.inc
.data
CollisionFlag db 0
DirMov BYTE 48h,50h,4Bh,4Dh
PacPosX db 26
PacPosY db 23
GhostArray db 0Ch,23,14,0Bh,25,14,0Dh,28,14,0Eh,30,14
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

	mov ecx, 500
	TestMove:
		CALL PacMove
		Loop TestMove
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

SpawnGhosts PROC USES eax ecx edx
	mov eax, 0
	mov ecx, 4
	mov esi, offset GhostArray

	Spawn:
		mov al, [esi]
		Call SetTextColor
		mov dl, [esi+1]
		mov dh, [esi+2]
		Call GotoXY
		mov al, 'G'
		Call WriteChar

		add esi, 3
		loop Spawn
	
	;reset Pac-Man's color
	mov eax, 14
	CALL SetTextColor

	ret
SpawnGhosts ENDP

PacMove PROC
	mov dl, PacPosX
	mov dh, PacPosY
	CALL GoToXY
	mov eax, 0
	CALL readchar
	CMP ah, DirMov[0]
	je DeltaUp
	CMP ah, DirMov[1]
	je DeltaDown
	CMP ah, DirMov[2]
	je DeltaLeft
	CMP ah, DirMov[3]
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

END main