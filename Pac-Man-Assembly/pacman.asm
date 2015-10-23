;Title
;Contributors
INCLUDE Irvine/Irvine32.inc

.code
main PROC
	mov eax, 0
	Call WriteInt
	Call Crlf

	exit
main ENDP

END main