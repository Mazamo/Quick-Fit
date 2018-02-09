; Source name			: MemoryBlock.asm
; Executable name		: None
; Version 				: 0.1
; Created date			: 05/02/2018
; Last update			: 05/02/2018
; Author				: Nick de Visser
; Description 			: A memory block structure used in the quick fit memory allocation 
;						: algorithm.
;
; Node layout:
;	Allocated/Free: Value indicating if the memory block is currently free or allocated.
;	Data address: Pointer to the actual memory following the block structure.

global MemoryBlockSize					; The size of a memory block structure.

SECTION .data

SECTION .bss
	MemoryBlockSize			equ 2		; The size of a memory block structure in dwords.

SECTION .text
	global initializeMemoryBlock		; Create a new memory block structure.
	global destroyMemoryBlock			; Destroy a memory block structure.
	global allocateMemoryBlock			; Allocate a memory block structure.
	global deallocateMemoryBlock		; Deallocate a memory block structure.
	global getMemoryAddress				; Retrieve a pointer memory block.
	global findMemoryBlock				; Find a memory block based on its address.
	global findFreeMemoryBlock			; Find a free memory block based on its allocated member.

	;-----------------------------------------------------------------------------
	; Construction method for a memory block structure. This method initializes the
	; memory block structure by filling its members with provided values.
	; -- Last update 05/02/2018
	; 
	; Parameters:
	; 	EAX: Pointer to the memory region on which the block will be initialized
	; 
	; Return:
	; 	None
	;-----------------------------------------------------------------------------
	initializeMemoryBlock:	
		cmp eax, 0           			; Determine if eax contains a valid value.         
		jne .initializeMemoryBlock		; If eax contains a valid value initialize the block.
		ret								; If eax contains a invalid address leave the routine.

	.initializeMemoryBlock:
		push ebx 

		mov dword [eax], 1				; Move a value into the block´s alloc. member indicating
										; it's allocated.
		lea ebx, [eax + 8]
		mov dword [eax + 4], ebx

		pop ebx
		ret

	;-----------------------------------------------------------------------------
	; Destroy a memory block structure by setting all of its members to reference
	; null pointers. Note this functionality isn't a required part of the quick fit
	; memory allocation algorithm. -- Last update 05/05/2018
	;
	; Parameters:
	; 	EAX: Pointer to the memory block structure to be destroyed
	;
	; Return:
	; 	None
	;-----------------------------------------------------------------------------
	destroyMemoryBlock:
		cmp eax, 0						; Determine if eax contains a valid value.
		je .doneDestroying				; If eax contains an invalid value leave the routine.
	
		mov dword [eax], 0				; Move the allocated member of the memory block to zero.	
		mov dword [eax + 4], 0			; Move the data member of the memory block to zero.

	.doneDestroying:
		ret

	;-----------------------------------------------------------------------------
	; Allocates a memory block by setting its allocated member to a value 
	; indicating it's currently allocated. -- Last update 05/05/2018
	; 
	; Parameters:
	; 	EAX: Pointer to the memory block that is to be allocated
	;
	; Return:
	; 	None
	;-----------------------------------------------------------------------------
	allocateMemoryBlock:
		cmp eax, 0						; Determine if eax contains a valid value. 
		je .doneAllocating				; If eax contains an invalid value leave the routine.

		cmp dword [eax], 1 				; Determine if the memory block is already allocated.
		je .doneAllocating				; If the block is already allocated leave the routine.

		mov dword [eax], 1				; Allocate the memory block. 

	.doneAllocating:
		ret

	;-----------------------------------------------------------------------------
	; Deallocate a memory block by settings its allocated member to a value 
	; indicating it's currently not allocated. -- Last update 05/05/2018
	;
	; Parameters:
	;	EAX: Pointer to the memory block that is to be deallocated
	;
	; Return:
	;	None
	;-----------------------------------------------------------------------------
	deallocateMemoryBlock:
		cmp eax, 0						; Determine if eax contains a valid value. 
		je .doneDeallocating

		mov dword [eax], 0				; Deallocate the memory block. 

	.doneDeallocating:
		ret


	;-----------------------------------------------------------------------------
	; Retrieve the memory address member of a memory block.
	; -- Last update 05/05/2018
	;
	; Parameters:
	;	EAX: Pointer to the memory block from which the memory address is retrieved
	;
	; Return:
	; 	EAX: Memory address member of the memory block.
	;-----------------------------------------------------------------------------
	getMemoryAddress:
		cmp eax, 0						; Determine if eax contains a valid value.
		je .doneRetrieving				; If eax is invalid leave the routine.

		lea eax, [eax + 4]				; Store the block's memory address member in eax.

	.doneRetrieving:
		ret

	;-----------------------------------------------------------------------------
	; Find a memory block by comparing a provided memory address with the
	; memory address member of the provided memory block. -- Last update 05/05/2018
	;
	; Parameters:
	;	EAX: Pointer to the memory block
	; 	ECX: Memory address used for comparison
	;
	; Return:
	; 	EAX: Value indicating the result of the comparions (1 equal, 0 unequal).
	;-----------------------------------------------------------------------------
	findMemoryBlock:
		cmp eax, 0						; Determine if eax contains a valid value.
		je .doneComparing				; If eax is invalid leave the routine.

		cmp dword [eax + 4], ecx		; Compare ebx with the block's memory address member. 
		jne .unequal					; If the two differ fill eax with zero.

		mov eax, 1						; If the two are equal fill eax with one.
		jmp .doneComparing				; Leave the routine

	.unequal:
		mov eax, 0						; Indicate that the block's memory member and ebx differ.

	.doneComparing:				
		ret

	;-----------------------------------------------------------------------------
	; Find a free memory block by comparing 
	;-----------------------------------------------------------------------------
	findFreeMemoryBlock:
		cmp eax, 0						; Determine if eax contains a valid value.
		je .doneComparing				; If eax is invalid leave the routine.

		cmp dword [eax], 0				; Determine if the memory block is free.
		jne .unequal					; If the block is not free.

		mov eax, 1						; If the block is free move one into eax.
		jmp .doneComparing				; Leave the routine.

	.unequal:
		mov eax, 0						; Indicate that the block is already allocated

	.doneComparing:
		ret
