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
	global bufferInitialize
	global bufferDestroy
	global allocData
	global deallocData

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
		cmp eax, 0
		je .doneInitializing

		mov dword [BaseMemoryPtr], eax
		
		mov dword [ListOnePtr], eax
		call createLinkedList
		lea eax, [eax + 8]
	
		mov dword [ListTwoPtr], eax
		call createLinkedList
		lea eax, [eax + 8]
				
		mov dword [ListThreePtr], eax
		call createLinkedList
		lea eax, [eax + 8]
	
		mov dword [ListFourPtr], eax
		call createLinkedList
		lea eax, [eax + 8]
	
		mov dword [ListFivePtr], eax
		call createLinkedList
		lea eax, [eax + 8]
	
		mov dword [ListSixPtr], eax
		call createLinkedList
		lea eax, [eax + 8]

		mov dword [OffsetMemoryPtr], eax
		mov eax, [BaseMemoryPtr]
	
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
		push eax 

		cmp dword [BaseMemoryPtr], 0
		je .doneDestroying

		mov eax, BaseMemoryPtr
		call destroyLinkedList
		mov dword [ListOnePtr], 0
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
	;
	;-----------------------------------------------------------------------------
	allocData:
	nop

	;-----------------------------------------------------------------------------
	;
	;-----------------------------------------------------------------------------
	deallocData:
	nop
