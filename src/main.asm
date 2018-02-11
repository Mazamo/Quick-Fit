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
		pushad							; Store all the registers on the stack.	

		cmp eax, 0						; Determine if eax is valid.
		je .donePrinting				; If eax is not valid leave the routine.

		inc ebx							; Increment ebx for a easier reading (not starting at 0 etc.).

		pushad							; Store all of the registers on the stack.
		push esi						; Push the size of the block on the call stack.
		push BlockMessage				; Push the BlockMessage on the call stack.
		call printf						; Printf the message.
		add esp, 8						; Adjust esp.
		popad							; Restore all the registers.

		cmp dword [eax], 0				; Determine if the memory block is allocated.
		je .printFreeBlock				; If the memory block is not allocated print the according message.
		jmp .printAllocatedBlock		; If the memory block is allocated print the according message.

	.printAllocatedBlock:
		mov eax, [eax + 4]				; Move the address of the writeable memory block into eax.

		cmp dword [eax], 0				; Determine if the block contains writable data.
		je .printAllocatedEmptyBlock	; If the block is empty (contains nullptrs).
		
		push eax						; Push the address of the memory block's writable data.
		push ebx						; Push the index of the block (+1) on the call stack
		push AllocMessage				; Push the message on the call stack.
		call printf						; Print the message.
		add esp, 12						; Adjust esp.

		jmp .donePrinting				; Leave the routine.

	.printAllocatedEmptyBlock:
		push ebx						; Push the index (+1) on the call stack.
		push AllocEmptyMessage			; Push the the message on the call stack.
		call printf						; Print the message.
		add esp, 8						; Adjust esp.

		jmp .donePrinting				; Leave the routine.

	.printFreeBlock:
		push ebx						; Push the index (+1) on the call stack.
		push FreeMessage				; Push the message on the call stack.
		call printf						; Print the message.
		add esp, 8						; Adjust esp.

	.donePrinting:
		popad							; Restore all the registers to their original values.
		ret
		
	;--------------------------------------------------------------------------
	; Main logic. This method is sytem depent and relies on Linux dependant
	; syscalls.
	;--------------------------------------------------------------------------
	main:
		push ebp						; Store the value of ebp on the stack.
		mov ebp, esp					; Move the initial value of esp into ebp.

		mov eax, BufferPtr				; Move the address of the buffer into eax.
		mov ebx, BufferLen				; Move the size of the buffer into ebx.
		call bufferInitialize			; Create and initialize the memory buffer.

		mov eax, 5						; Specify a 5 byte block.
		call allocateData				; Allocate the memory region.

		mov eax, 10						; Specify a 10 byte block.
		call allocateData				; Allocate the memory region.

		mov eax, 20						; Specify a 20 byte block.
		call allocateData				; Allocate the memory region.

		mov eax, 30						; Specify a 30 byte block.
		call allocateData				; Allocate the memory region.

		mov eax, 40						; Specify a 40 byte block.
		call allocateData				; Allocate the memory region.

		mov eax, 50						; Specify a 50 byte block.
		call allocateData				; Allocate the memory region.

		mov eax, 60						; Specify a 60 byte block.
		call allocateData				; Allocate the memory region.

		mov eax, 70						; Specify a 70 byte block.
		call allocateData				; Allocate the memory region.

		mov eax, 80						; Specify a 80 byte block.
		call allocateData				; Allocate the memory region.

		mov eax, 90						; Specify a 90 byte block.
		call allocateData				; Allocate the memory region.

		mov eax, 100					; Specify a 100 byte block.
		call allocateData				; Allocate the memory region.

		mov eax, 110					; Specify a 110 byte block.
		call allocateData				; Allocate the memory region.

		mov eax, 120					; Specify a 120 byte block.
		call allocateData				; Allocate the memory region.
		
		mov eax, 130					; Specify a 130 byte block.
		call allocateData				; Allocate the memory region.

		mov eax, 140					; Specify a 140 byte block.
		call allocateData				; Allocate the memory region.

		mov eax, 150					; Specify a 150 byte block.
		call allocateData				; Allocate the memory region.

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

		mov esp, ebp					; Move the value of the original stack pointer back into esp.
		pop ebp							; Restore ebp.
		ret
