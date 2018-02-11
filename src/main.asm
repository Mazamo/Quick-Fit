; Source name				: main.asm
; Executuble name			: QuickFit 
; Version					: 1.0
; Created date				: 10/02/2018
; Last update				: 10/02/2018
; Author					: Nick de Visser
; Description				: Main logic for the QuickFit logic.

SECTION .data

SECTION .bss
	BufferPtr	resb	50000		; Pointer to the buffer's memory range. 
	BufferLen	equ $- BufferPtr	; Size of the buffer.

SECTION .text
	extern bufferInitialize			
	extern bufferDestroy
	extern allocateData
	extern deallocateData
	extern getIndex

	global _start
	
	;-----------------------------------------------------------------------------
	; Prints the state and content of a list's memory block elements.
	; -- Last update 10/02/2018
	;
	; Parameters:
	;	EAX: Pointer to the list from which the memory block elements are printed.
	;
	; Return:
	;	None
	;-----------------------------------------------------------------------------
	printBlocks:
		push ebx						; Store the used registers on the stack.
		push ecx

		cmp eax, 0						; Determine if eax is valid.
		je .donePrinting				; If eax is invalid leave the routine.
		
		mov ecx, eax					; Move the address of the linked list into ecx.
		mov ebx, 0						; Move the first index into ebx.

	.iterateThroughList:
		mov eax, ecx
		call getIndex		

		cmp eax, 0
		je .donePrinting
			
		call printValues
		inc ebx

		jmp .iterateThroughList

	.donePrinting:
		mov eax, ecx

		pop ecx
		pop ebx
		ret

	_start:
		mov eax, BufferPtr
		mov ebx, BufferLen
		call bufferInitialize

		mov eax, 120
		call allocateData

		mov eax, 120
		call allocateData

		call bufferDestroy

		mov eax, 1
		mov ebx, 0
		int 80h


