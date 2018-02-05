SECTION .data
	StringPtr 	db 	"Hello, World!", 10, 0
	STRINGLEN 	equ $- StringPtr

SECTION .bss

SECTION .text
	global _start:

	print:
		mov eax, 4
		mov ebx, 1
		mov ecx, StringPtr
		mov edx, STRINGLEN
		int 80h
		ret

	_start:
		mov eax, print
		call eax

		mov eax, 1
		mov ebx, 0
		int 80h


