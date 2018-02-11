; Source name			: QuickFit.asm
; Exectuable name		: None
; Version 				: 0.1
; Created date			: 05/02/2018
; Last update			: 10/02/2018
; Author				: Nick de Visser
; Decription			: An implementation of the quick fit memory allocation algorithm.

SECTION .data

SECTION .bss
	FIVE_BLOCK 			equ 5			
	TEN_BLOCK			equ 10 
	TWENTY_BLOCK		equ 20
	FOURTY_BLOCK		equ 40
	EIGHTY_BLOCK		equ 80
	HUNDREDSIXTY_BLOCK	equ 160

	BaseMemoryPtr		resd 1 			; Pointer to the base of the memory region.
	OffsetMemoryPtr 	resd 1			; Pointer to the current offset of the memory region.

	; Pointers to link list structures containing the memory blocks.
	ListOnePtr 			resd 1			; List containing 20 byte blocks.
	ListTwoPtr			resd 1			; List containing 80 byte blocks.
	ListThreePtr		resd 1			; List containing 160 byte blocks.
	ListFourPtr			resd 1			; List containing 320 byte blocks.
	ListFivePtr			resd 1			; List containing 640 byte blocks.
	ListSixPtr			resb 1			; List containing 1240 byte blocks.

	BufferSize			resd 1			; The size of the buffer in bytes.

SECTION .text
	global bufferInitialize				; Initialize the memory buffer.
	global bufferDestroy				; Destroy the memory buffer and destroy the resources.
	global allocateData					; Allocate a specified sized memory block on the buffer.
	global deallocateData				; Deallocate a memory block based on its memory address.

	extern createLinkedList
	extern destroyLinkedList
	extern addBack
	extern findData
	extern initializeMemoryBlock
	extern allocateMemoryBlock
	extern deallocateMemoryBlock
	extern getMemoryAddress
	extern findMemoryBlock
	extern findFreeMemoryBlock
	extern MemoryBlockSize
	extern NodeSize
	extern ListSize

	;-----------------------------------------------------------------------------
	; Initializes a memory buffer from which memory blocks can be allocated or 
	; deallocated. -- Last update 05/02/2018
	;
	; Parameters:
	; 	EAX: Pointer to the memory address of the memory buffer
	;	EBX: Size of the memory buffer in bytes
	; 
	; Return:
	; 	None
	;-----------------------------------------------------------------------------
	bufferInitialize:
		push ecx						; Store the used register on the stack.

		cmp eax, 0						; Determine if eax represents a valid value.
		je .doneInitializing			; If eax is invalid leave the routine.

		cmp ebx, 0						; Determine if the size is a valid value.
		je .doneInitializing			; If the size is invallid

		mov dword [BufferSize], ebx		; Move the size of the buffer into the BufferSize variable.
		mov ecx, ListSize				; Mov the size of a list into ecx.

		mov dword [BaseMemoryPtr], eax	; Set the BaseMemoryPtr with the address of the buffer.
		
		mov dword [ListOnePtr], eax 	; Move the base memory address into ListOnePtr.
		call createLinkedList			; Initialize the first linked list.
		lea eax, [eax + ecx]			; Adjust the address stored in eax.
	
		mov dword [ListTwoPtr], eax		; Set adjusted memory memory address into ListTwoPtr.
		call createLinkedList			; initialize the second linked list.
		lea eax, [eax + ecx]			; Adjust the address stored in eax.
				
		mov dword [ListThreePtr], eax	; Set adjusted memory memory address into ListThreePtr.
		call createLinkedList			; initialize the third linked list.
		lea eax, [eax + ecx]			; Adjust the address stored in eax.
	
		mov dword [ListFourPtr], eax	; Set adjusted memory memory address into ListFourPtr.
		call createLinkedList			; initialize the fourth linked list.
		lea eax, [eax + ecx]			; Adjust the address stored in eax.
	
		mov dword [ListFivePtr], eax	; Set adjusted memory memory address into ListFivePtr.
		call createLinkedList			; initialize the fifth linked list.
		lea eax, [eax + ecx]			; Adjust the address stored in eax.
	
		mov dword [ListSixPtr], eax		; Set adjusted memory memory address into ListSixPtr.
		call createLinkedList			; initialize the six linked list.
		lea eax, [eax + ecx]			; Adjust the address stored in eax.

		mov dword [OffsetMemoryPtr], eax; Adjust the OffsetMemoryPtr to reference the start of 
										; the writeble memory region.
		mov eax, [BaseMemoryPtr]		; Restore eax to point to the start of the memory buffer.
	
	.doneInitializing:
		pop ecx							; Restore the used register to its original state.
		ret

	;-----------------------------------------------------------------------------
	; Destroys the memory buffer and the resources used for the implementation
	; of the quick fit algorithm. -- 05/05/2018
	;
	; Parameters:
	;	None
	;
	; Return:
	;	None
	;-----------------------------------------------------------------------------
	bufferDestroy:
		push eax 						; Store the used register on the stack.
		push ecx

		cmp dword [BaseMemoryPtr], 0	; Determine if the BaseMemoryPtr is initialized.
		je .doneDestroying				; If it isn't initialized leave the routine.

		mov ecx, ListSize				; Move the size of a list structure into ecx.

		mov eax, BaseMemoryPtr			; Move the BaseMemoryPtr into eax.
		call destroyLinkedList			; Destroy the first linked list.
		mov dword [ListOnePtr], 0		; Remove the reference to the list structure.
		lea eax, [eax + ecx]			; Adjust the address stored in eax.
		
		call destroyLinkedList			; Destroy the second linked list.
		mov dword [ListTwoPtr], 0		; Remove the reference to the list structure.
		lea eax, [eax + ecx]			; Adjust the address stored in eax.

		call destroyLinkedList			; Destroy the third linked list.
		mov dword [ListThreePtr], 0		; Remove the reference to the list structure.
		lea eax, [eax + ecx]			; Adjust the address stored in eax.

		mov eax, BaseMemoryPtr			; Destroy the fourth linked list.
		call destroyLinkedList			; Remove the reference to the list structure.
		mov dword [ListFourPtr], 0		; Adjust the address stored in eax.
		lea eax, [eax + ecx]			; Adjust the address stored in eax.

		mov eax, BaseMemoryPtr			; Destory the fith linked list.
		call destroyLinkedList			; Remove the reference to the list structure.
		mov dword [ListFivePtr], 0		; Adjust the address stored in eax.
		lea eax, [eax + ecx]			; Adjust the address stored in eax.

		mov eax, BaseMemoryPtr			; Destroy the sixth linked list.
		call destroyLinkedList			; Remove the reference to the list structure.
		mov dword [ListFourPtr], 0		; Adjust the address stored in eax.
		lea eax, [eax + ecx]			; Adjust the address stored in eax.

		mov dword [BaseMemoryPtr], 0	; Remove the reference to the base memory pointer.
		mov dword [OffsetMemoryPtr], 0	; Remove the reference to the offset memory pointer.
		mov dword [BufferSize], 0		; Reset the size of the buffer to zero.

	.doneDestroying:
		pop ecx							; Restore the registers to their original state.
		pop eax		
		ret

	;-----------------------------------------------------------------------------
	; Allocates a block of data on the buffer or re-allocates a block if a 
	; free block is found. -- Last update 08/02/2018
	;
	; Parameters:
	;	EAX: Size of the block that is allocated
	;
	; Return:
	;	EAX: Pointer to the writeble address or a nullptr in the case the 
	;		 allocation operation failed
	;-----------------------------------------------------------------------------
	allocateData:
		push ebx						; Store the used register on the stack.

		cmp eax, 0						; Determine if a null byte sized block is requested.
		je .doneAllocating				; If eax is null leave the routine.

		cmp eax, HUNDREDSIXTY_BLOCK		; Determine if the requested block is greater than the largest 
										; available block.
		jg .doneAllocating				; If the required block will is not allocatable leave the routine.

		cmp eax, FIVE_BLOCK				; Determine if the requested block is equal or below a FIVE_BLOCK.
		jbe .allocateFiveBlock			; Allocate a block of five bytes.

		cmp eax, TEN_BLOCK				; Determine if the requested block is equal or below a TEN_BLOCK.
		jbe .allocateTenBlock			; Allocate a block of ten bytes.

		cmp eax, TWENTY_BLOCK			; Determine if the requested block is equal or below a TWENTY_BLOCK.
		jbe .allocateTwentyBlock		; Allocate a block twenty bytes.

		cmp eax, FOURTY_BLOCK			; Determine if the requested block is equal or below a FOURTHY_BLOCK.
		jbe .allocateFourthyBlock		; Allocate a block of fourthy bytes.

		cmp eax, EIGHTY_BLOCK			; Determine if the requested block is equal or below a EIGHTY_BLOCK.
		jbe .allocateEightyBlock		; Allocate a block of eighty bytes.

		jmp .allocateHundredSixtyBlock	; Allocate a block of hundredsixity bytes.

	.allocateFiveBlock:
		mov eax, [ListOnePtr]			; Store a pointer to the first list into eax.
		mov ebx, FIVE_BLOCK				; Move the appropiate size into ebx.
		call allocateBlock				; Allocate the memory block on the buffer.
	
		jmp .doneAllocating				; Leave the routine once finsihed allocation the memory block.

	.allocateTenBlock:
		mov eax, [ListTwoPtr]			; Store a pointer to the second list into eax.
		mov ebx, TEN_BLOCK				; Move the appropiate size into ebx.
		call allocateBlock				; Allocate the memory block on the buffer.

		jmp .doneAllocating				; Leave the routine once finsihed allocation the memory block.

	.allocateTwentyBlock:
		mov eax, [ListThreePtr]			; Store a pointer to the third list into eax.
		mov ebx, TWENTY_BLOCK			; Move the appropiate size into ebx.
		call allocateBlock				; Allocate the memory block on the buffer.

		jmp .doneAllocating				; Leave the routine once finsihed allocation the memory block.

	.allocateFourthyBlock:
		mov eax, [ListFourPtr]			; Store a pointer to the fourth list into eax.
		mov ebx, FOURTY_BLOCK			; Move the appropiate size into ebx.
		call allocateBlock				; Allocate the memory block on the buffer.

		jmp .doneAllocating				; Leave the routine once finsihed allocation the memory block.
	
	.allocateEightyBlock:
		mov eax, [ListFivePtr]			; Store a pointer to the fifth list into eax.
		mov ebx, EIGHTY_BLOCK			; Move the appropiate size into ebx.
		call allocateBlock				; Allocate the memory block on the buffer.

		jmp .doneAllocating				; Leave the routine once finsihed allocation the memory block.

	.allocateHundredSixtyBlock:
		mov eax, [ListSixPtr]			; Store a pointer to the sixth list into eax.
		mov ebx, HUNDREDSIXTY_BLOCK		; Move the appropiate size into ebx.
		call allocateBlock				; Allocate the memory block on the buffer.

	.doneAllocating:
		pop ebx							; Restore the used register to its original state.
		ret

	;-----------------------------------------------------------------------------
	; Allocates a memory block of a specified size on a specified linked list
	; structure. -- Last update 08/02/2018
	;
	; Parameters:
	;	EAX: Linked list structure on which the memory block is allocated
	;	EBX: Size of the block that is allocated in bytes
	;
	; Return:
	;	EAX: New offset pointer or a nullptr in the case the operation failed.
	;-----------------------------------------------------------------------------
	allocateBlock:
		push ecx						; Push the used register on the stack.
		push edx

		cmp eax, 0						; Determine if the pointer to the linked list is invalid.
		je .doneAllocating				; If eax is invalid leave the routine.

		cmp ebx, 0						; Determine if the block size is invallid.
		je .doneAllocating				; If ebx is invalid leave the routine.

		cmp dword [eax], 0				; Determine if the list is empty.
		je .allocateNewBlock			; If the list is empty add the first memory block to it.
		
		push eax
		mov ebx, findFreeMemoryBlock	; Move the address of the function in ebx.
		call findData					; Find a free memory block in the list.
		mov ecx, eax
		pop eax
		
		cmp ecx, 0						; Determine if a free memory block has been found.
		je .allocateNewBlock			; If no free block has been found allocate a new one.
		
		jmp .allocateExistingBlock		; If a free block has been found reuse if.

	.allocateNewBlock:
		mov edx, [BaseMemoryPtr]
		mov ecx, [OffsetMemoryPtr]
	
		add edx, BufferSize
		add ecx, ebx

		cmp ecx, edx					; Determine if there is enough place to store the new mem. block.
		ja .doneAllocating				; If there is not enough place leave the routine.

		push ebx						; Push the used registers on the stack.
		push eax

		mov ebx, NodeSize				; Move the size of a now into ebx.
		mov eax, [OffsetMemoryPtr]
		add eax, ebx
		call initializeMemoryBlock		; Initialize the memory block on the buffer.
		mov ebx, eax					; Move the address of the memory block into ebx.
		pop eax							; Restore eax with the value of the linked list.
		
		mov ecx, [OffsetMemoryPtr]		; Store the address to store the node into ecx.
		call addBack					; Add the node referencing the newly added mem. block to the list.

		mov eax, ebx					; Move the address of the memory block into eax.
		pop ebx							; Restore ebx with the size of the allocated memory block.

		add ebx, NodeSize				; Add the size of the newly added node to the mem. block size.
		add ebx, MemoryBlockSize		; Add the size of the added memory block to the mem. block size.
	.debug:
		add ecx, ebx					; Add the used size to the memory offset. 
		mov dword [OffsetMemoryPtr], ecx; Move the new offset into the OffsetMemoryPtr.

	.allocateExistingBlock:				; It is assumed eax contains a pointer to a memory block structure.
		call allocateMemoryBlock		; Allocate the memory block.
		call getMemoryAddress			; Retrieve the address of the writeble memory range.
	
	.doneAllocating:
		pop edx
		pop ecx							; Restore the used register to its original state.
		ret


	;-----------------------------------------------------------------------------
	; Deallocate a memory block from the buffer based on a provided memory address.
	; -- Last update 08/02/2018
	;
	; Parameters:
	;	EAX: Memory address representing the start of the writeble memory block
	;
	; Return:
	;	None
	;-----------------------------------------------------------------------------
	deallocateData:
		cmp eax, 0						; Determine if eax contains a valid value.
		je .doneDeallocating			; If eax is invalid leave the routine.
		
		mov ebx, findMemoryBlock		; Move the address of the findMemoryBlock routine into ebx.
		mov ecx, eax					; Move the memory address stored in eax into ecx.

		mov eax, [ListOnePtr]			; Move a pointer to the first list into eax.
		call findData					; Search for the specific memory block.
		cmp eax, 0						; Determine if the block has been found.
		jne .deallocBlock				; If the block has been found deallocate it.
		
		mov eax, [ListTwoPtr]			; Move a pointer to the second list into eax.
		call findData					; Search for the specific memory block.
		cmp eax, 0						; Determine if the block has been found.
		jne .deallocBlock				; If the block has been found deallocate it.
		
		mov eax, [ListThreePtr]			; Move a pointer to the third list into eax.
		call findData					; Search for the specific memory block.
		cmp eax, 0						; Determine if the block has been found.
		jne .deallocBlock				; If the block has been found deallocate it.

		mov eax, [ListFourPtr]			; Move a pointer to the fourth list into eax.
		call findData					; Search for the specific memory block.
		cmp eax, 0						; Determine if the block has been found.
		jne .deallocBlock				; If the block has been found deallocate it.

		mov eax, [ListFivePtr]			; Move a pointer to the fifth list into eax.
		call findData					; Search for the specific memory block.
		cmp eax, 0						; Determine if the block has been found.
		jne .deallocBlock				; If the block has been found deallocate it.

		mov eax, [ListSixPtr]			; Move a pointer to the sixth list into eax.
		call findData					; Search for the specific memory block.
		cmp eax, 0						; Determine if the block has been found.
		jne .deallocBlock				; If the block has been found deallocate it.

		jmp .doneDeallocating			; If the memory block has not been found leave the routine.

	.deallocBlock:
		call deallocateMemoryBlock		; Allocate the found memory block.
	
	.doneDeallocating:
		ret
