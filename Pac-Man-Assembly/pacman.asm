;Title
;Contributors
INCLUDE Irvine/Irvine32.inc
.data
DirMov BYTE 'w','s','a','d'
PacPosX db 26
PacPosY db 23
PacPosLast db 1,0
PacSymLast db '<'
boardArray  db '############################', 
			   '#............##............#', 
			   '#.####.#####.##.#####.####.#', 
			   '#o####.#####.##.#####.####o#',
			   '#.####.#####.##.#####.####.#', 
			   '#..........................#', 
			   '#.####.##.########.##.####.#', 
			   '#.####.##.########.##.####.#'	;This is used for collision.
			db '#......##....##....##......#',
			   '######.##### ## #####.######', 
			   '######.##### ## #####.######', 
			   '######.##          ##.######',
			   '######.## ######## ##.######', 
			   '######.## #      # ##.######', 
			   '      .   #      #   .      ', 
			   '######.## #      # ##.######'	;It is a little hard to read but its the 
			db '######.## ######## ##.######', 
			   '######.##          ##.######', 
			   '######.## ######## ##.######', 
			   '######.## ######## ##.######',
			   '#............##............#', 
			   '#.####.#####.##.#####.####.#', 
			   '#.####.#####.##.#####.####.#', 
			   '#o..##.......  .......##..o#'	;same as the map below.
			db '###.##.##.########.##.##.###', 
			   '###.##.##.########.##.##.###', 
			   '#......##..........##......#', 
			   '#.##########.##.##########.#',
			   '#.##########.##.##########.#', 
			   '#..........................#', 
			   '############################'
row1  db "# # # # # # # # # # # # # # # # # # # # # # # # # # # #",0
row2  db "# . . . . . . . . . . . . # # . . . . . . . . . . . . #",0  
row3  db "# . # # # # . # # # # # . # # . # # # # # . # # # # . #",0  
row4  db "# o # # # # . # # # # # . # # . # # # # # . # # # # o #",0  
row5  db "# . # # # # . # # # # # . # # . # # # # # . # # # # . #",0  
row6  db "# . . . . . . . . . . . . . . . . . . . . . . . . . . #",0  
row7  db "# . # # # # . # # . # # # # # # # # . # # . # # # # . #",0  
row8  db "# . # # # # . # # . # # # # # # # # . # # . # # # # . #",0  
row9  db "# . . . . . . # # . . . . # # . . . . # # . . . . . . #",0  
row10 db "# # # # # # . # # # # #   # #   # # # # # . # # # # # #",0  
row11 db "# # # # # # . # # # # #   # #   # # # # # . # # # # # #",0  
row12 db "# # # # # # . # #                     # # . # # # # # #",0  
row13 db "# # # # # # . # #   # # # - - # # #   # # . # # # # # #",0  
row14 db "# # # # # # . # #   #             #   # # . # # # # # #",0  
row15 db "            .       #             #       .            ",0  
row16 db "# # # # # # . # #   #             #   # # . # # # # # #",0  
row17 db "# # # # # # . # #   # # # # # # # #   # # . # # # # # #",0  
row18 db "# # # # # # . # #                     # # . # # # # # #",0  
row19 db "# # # # # # . # #   # # # # # # # #   # # . # # # # # #",0 
row20 db "# # # # # # . # #   # # # # # # # #   # # . # # # # # #",0  
row21 db "# . . . . . . . . . . . . # # . . . . . . . . . . . . #",0  
row22 db "# . # # # # . # # # # # . # # . # # # # # . # # # # . #",0  
row23 db "# . # # # # . # # # # # . # # . # # # # # . # # # # . #",0  
row24 db "# o . . # # . . . . . . .     . . . . . . . # # . . o #",0  
row25 db "# # # . # # . # # . # # # # # # # # . # # . # # . # # #",0  
row26 db "# # # . # # . # # . # # # # # # # # . # # . # # . # # #",0  
row27 db "# . . . . . . # # . . . . . . . . . . # # . . . . . . #",0 
row28 db "# . # # # # # # # # # # . # # . # # # # # # # # # # . #",0 
row29 db "# . # # # # # # # # # # . # # . # # # # # # # # # # . #",0 
row30 db "# . . . . . . . . . . . . . . . . . . . . . . . . . . #",0 
row31 db "# # # # # # # # # # # # # # # # # # # # # # # # # # # #",0   

.code
main PROC
	
	mov eax, 15
	CALL SetTextColor
	CALL PrintBoard
	mov ecx, 50
	TestMove:
		CALL PacMove
		Loop TestMove


exit
main ENDP

PrintBoard PROC

mov ecx, 31
mov edx, OFFSET row1 - 56

BoardLoop:

	ADD edx, 56
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

	;mov eax, 15
	;CALL SetTextColor
	;mov dl, 1
	;mov dh, 31
	;CALL GoTOXY
RET 
PrintBoard ENDP

PacMove PROC
	mov dl, PacPosX
	mov dh, PacPosY
	CALL GoToXY
	mov eax, 0
	CALL readchar
	CMP al, DirMov[0]
	je DeltaUp
	CMP al, DirMov[1]
	je DeltaDown
	CMP al, DirMov[2]
	je DeltaLeft
	CMP al, DirMov[3]
	je DeltaRight
	jmp DeltaLast

	DeltaUp:
		mov al, 20h
		CALL writechar
		dec PacPosY
		mov dh, PacPosY
		CALL GoToXY
		mov PacSymLast, 'v'
		mov al, 'v'
		CALL writechar
		mov PacPosLast[1], -1 
		mov PacPosLast[0], 0		
		jmp Moved
	
	DeltaDown:
		mov al, 20h
		CALL writechar
		inc PacPosY
		mov dh, PacPosY
		CALL GoToXY
		mov PacSymLast, '^'
		mov al, '^'
		CALL writechar
		mov PacPosLast[1], 1 
		mov PacPosLast[0], 0
		jmp Moved
	
	DeltaLeft:
		mov al, 20h
		CALL writechar
		SUB PacPosX, 2
		mov dl, PacPosX
		CALL GoToXY
		mov PacSymLast, '>'
		mov al, '>'
		CALL writechar
		mov PacPosLast[1], 0
		mov PacPosLast[0], -1
		jmp Moved
	
	DeltaRight:
		mov al, 20h
		CALL writechar
		ADD PacPosX,2
		mov dl, PacPosX
		CALL GoToXY
		mov PacSymLast, '<'
		mov al, '<'
		CALL writechar
		mov PacPosLast[1], 0
		mov PacPosLast[0], 1
		jmp Moved
	
	DeltaLast:
		mov al, 20h
		CALL writechar
		mov dl, PacPosX
		mov dh, PacPosY
		add dl, PacPosLast[0]
		add dh, PacPosLast[1]
		mov PacPosX, dl
		mov PacPosY, dh
		CALL GoToXY
		mov al, PacSymLast
		CALL writechar

Moved:
RET
PacMove ENDP

END main