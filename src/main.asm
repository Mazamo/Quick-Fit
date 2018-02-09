SECTION .data
	StringPtr 	db 	"Hello, World!", 10, 0
	STRINGLEN 	equ $- StringPtr

SECTION .bss
	BufferPtr	resb	50000
	BufferLen	equ		50000

SECTION .text
	extern bufferInitialize
	extern bufferDestroy
	extern allocateData
	extern deallocateData


	global _start:

	_start:
		mov eax, BufferPtr
		mov ebx, BufferLen
		call bufferInitialize

		mov eax, 120
		call allocateData
		call deallocateData 
		
		mov eax, 1
		mov ebx, 0
		int 80h


