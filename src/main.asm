; Source name				: main.asm
; Executuble name			: QuickFit 
; Version					: 1.0
; Created date				: 10/02/2018
; Last update				: 11/02/2018
; Author					: Nick de Visser
; Description				: Main logic for the QuickFit logic.

SECTION .data
	BlockMessage 		db 	10, "This block is %d bytes in size.", 10, 0
	AllocMessage		db  "%d. This block is allocted and contains the following: %s", 10, 0
	AllocEmptyMessage	db  "%d. This block is allocted and contains no data.", 10, 0
	FreeMessage			db 	"%d. This block is free.", 10, 0

SECTION .bss
	BufferPtr	resb	50000		; Pointer to the buffer's memory range. 
	BufferLen	equ $- BufferPtr	; Size of the buffer.

SECTION .text
	extern bufferInitialize			
	extern bufferDestroy
	extern allocateData
	extern deallocateData
	extern getIndex
	extern printElements

	extern ListOnePtr
	extern ListTwoPtr
	extern ListThreePtr
	extern ListFourPtr
	extern ListFivePtr
	extern ListSixPtr

	extern printf

	global main

	;-----------------------------------------------------------------------------
	; Print a memory block structure. This method is system dependent and 
	; relies on Linux dependant syscalls. -- Last update 11/02/2018
	;
	; Parameters:
	; 	EAX: Pointer to the memory block structure that is displayed
	; 	EBX: Index of the memory block in the list
	;	ESI: Block size of the printed blocks.
	;
	; Return:
	; 	None
	;-----------------------------------------------------------------------------
	printMemoryBlock:
		pushad

		cmp eax, 0
		je .donePrinting

		inc ebx

		pushad
		push esi
		push BlockMessage
		call printf
		add esp, 8
		popad

		cmp dword [eax], 0
		je .printFreeBlock
		jmp .printAllocatedBlock

	.printAllocatedBlock:
		mov eax, [eax + 4]

		cmp dword [eax], 0
		je .printAllocatedEmptyBlock
		
		push eax 
		push ebx
		push AllocMessage
		call printf
		add esp, 12

		jmp .donePrinting

	.printAllocatedEmptyBlock:
		push ebx
		push AllocEmptyMessage
		call printf
		add esp, 8

		jmp .donePrinting

	.printFreeBlock:
		push ebx
		push FreeMessage
		call printf
		add esp, 8

	.donePrinting:
		popad
		ret
		
	;--------------------------------------------------------------------------
	; Main logic. This method is sytem depent and relies on Linux dependant
	; syscalls.
	;--------------------------------------------------------------------------
	main:
		push ebp
		mov ebp, esp

		mov eax, BufferPtr				; Move the address of the buffer into eax.
		mov ebx, BufferLen				; Move the size of the buffer into ebx.
		call bufferInitialize			; Create and initialize the memory buffer.

		mov eax, 120					; Specify a 120 byte block.
		call allocateData				; Allocate the memory region.

		mov eax, 140
		call allocateData

		mov eax, 10
		call allocateData

		mov eax, 40
		call allocateData

		; Print all of the existing memory blocks:
		mov ebx, printMemoryBlock
	
		mov eax, [ListOnePtr]
		mov esi, 5
		call printElements

		mov eax, [ListTwoPtr]
		mov esi, 10
		call printElements
	
		mov eax, [ListThreePtr]
		mov esi, 20
		call printElements

		mov eax, [ListFourPtr]
		mov esi, 40
		call printElements
	
		mov eax, [ListFivePtr]
		mov esi, 60
		call printElements

		mov eax, [ListSixPtr]
		mov esi, 160
		call printElements
		
		call bufferDestroy

		mov esp, ebp
		pop ebp
		ret
