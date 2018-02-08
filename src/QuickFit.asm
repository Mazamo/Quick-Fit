; Source name			: QuickFit.asm
; Exectuable name		: None
; Version 				: 0.1
; Created date			: 05/02/2018
; Author				: Nick de Visser
; Decription			: An implementation of the quick fit memory allocation algorithm.

SECTION .data

SECTION .bss
	FIVE_BLOCK 			equ 5 	* 32
	TEN_BLOCK			equ 10 	* 32
	TWENTY_BLOCK		equ 20 	* 32
	FOURTY_BLOCK		equ 40 	* 32
	EIGHTY_BLOCK		equ 80 	* 32
	HUNDREDSIXITY_BLOCK equ 160 * 32

	BaseMemoryPtr		resd 1 			; Pointer to the base of the memory region.
	OffsetMemoryPtr 	resd 1			; Pointer to the current offset of the memory region.

	; Pointers to link list structures containing the memory blocks.
	ListOnePtr 			resd 2			; List containing 20 byte blocks.
	ListTwoPtr			resd 2			; List containing 80 byte blocks.
	ListThreePtr		resd 2			; List containing 160 byte blocks.
	ListFourPtr			resd 2			; List containing 320 byte blocks.
	ListFivePtr			resd 2			; List containing 640 byte blocks.
	ListSixPtr			resb 2			; List containing 1240 byte blocks.

SECTION .text
	global bufferInitialize				; Initialize the memory buffer.
	global bufferDestroy				; Destroy the memory buffer and destroy the resources.
	global allocData					; Allocate a specified sized memory block on the buffer.
	global deallocData					; Deallocate a memory block based on its memory address.

	extern createLinkedList
	extern destroyLinkedList
	extern addBack
	extern findData
	extern initializeMemoryBlock
	extern allocateMemoryBlock
	extern deallocateMemoryBlock
	extern findMemoryBlock

	;-----------------------------------------------------------------------------
	; Initializes a memory buffer from which memory blocks can be allocated or 
	; deallocated. -- Last update 05/02/2018
	;
	; Parameters:
	; 	EAX: Pointer to the memory address of the memory buffer.
	; 
	; Return:
	; 	None
	;-----------------------------------------------------------------------------
	bufferInitialize:
		cmp eax, 0						; Determine if eax represents a valid value.
		je .doneInitializing			; If eax is invalid leave the routine.

		mov dword [BaseMemoryPtr], eax	; Set the BaseMemoryPtr with the address of the buffer.
		
		mov dword [ListOnePtr], eax 	; Move the base memory address into ListOnePtr.
		call createLinkedList			; Initialize the first linked list.
		lea eax, [eax + 8]				; Adjust the address stored in eax.
	
		mov dword [ListTwoPtr], eax		; Set adjusted memory memory address into ListTwoPtr.
		call createLinkedList			; initialize the second linked list.
		lea eax, [eax + 8]				; Adjust the address stored in eax.
				
		mov dword [ListThreePtr], eax	; Set adjusted memory memory address into ListThreePtr.
		call createLinkedList			; initialize the third linked list.
		lea eax, [eax + 8]				; Adjust the address stored in eax.
	
		mov dword [ListFourPtr], eax	; Set adjusted memory memory address into ListFourPtr.
		call createLinkedList			; initialize the fourth linked list.
		lea eax, [eax + 8]				; Adjust the address stored in eax.
	
		mov dword [ListFivePtr], eax	; Set adjusted memory memory address into ListFivePtr.
		call createLinkedList			; initialize the fifth linked list.
		lea eax, [eax + 8]				; Adjust the address stored in eax.
	
		mov dword [ListSixPtr], eax		; Set adjusted memory memory address into ListSixPtr.
		call createLinkedList			; initialize the six linked list.
		lea eax, [eax + 8]				; Adjust the address stored in eax.	

		mov dword [OffsetMemoryPtr], eax; Adjust the OffsetMemoryPtr to reference the start of 
										; the writeble memory region.
		mov eax, [BaseMemoryPtr]		; Restore eax to point to the start of the memory buffer.
	
	.doneInitializing:
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
	
		cmp dword [BaseMemoryPtr], 0	; Determine if the BaseMemoryPtr is initialized.
		je .doneDestroying				; If it isn't initialized leave the routine.

		mov eax, BaseMemoryPtr			; Move the BaseMemoryPtr into eax.
		call destroyLinkedList			; Destroy the first linked list.
		mov dword [ListOnePtr], 0		; Destroy 
		lea eax, [eax + 8]
		
		mov eax, BaseMemoryPtr
		call destroyLinkedList
		mov dword [ListTwoPtr], 0
		lea eax, [eax + 8]

		mov eax, BaseMemoryPtr
		call destroyLinkedList
		mov dword [ListThreePtr], 0
		lea eax, [eax + 8]

		mov eax, BaseMemoryPtr
		call destroyLinkedList
		mov dword [ListFourPtr], 0
		lea eax, [eax + 8]

		mov eax, BaseMemoryPtr
		call destroyLinkedList
		mov dword [ListFivePtr], 0
		lea eax, [eax + 8]

		mov eax, BaseMemoryPtr
		call destroyLinkedList
		mov dword [ListFourPtr], 0
		lea eax, [eax + 8]

		mov eax, BaseMemoryPtr

		mov dword [BaseMemoryPtr], 0
		mov dword [OffsetMemoryPtr], 0

	.doneDestroying:
		pop eax
		ret

	;-----------------------------------------------------------------------------
	; Allocates a block of data on the buffer. 
	;-----------------------------------------------------------------------------
	allocData:
		

	;-----------------------------------------------------------------------------
	;
	;-----------------------------------------------------------------------------
	deallocData:
	nop
