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

	BaseMemoryPtr		resb 1 			; Pointer to the base of the memory region.
	OffsetMemoryPtr 	resb 1			; Pointer to the current offset of the memory region.

	; Pointers to link list structures containing the memory blocks.
	ListOnePtr 			resb 2			; List containing 20 byte blocks.
	ListTwoPtr			resb 2			; List containing 80 byte blocks.
	ListThreePtr		resb 2			; List containing 160 byte blocks.
	ListFourPtr			resb 2			; List containing 320 byte blocks.
	ListFivePtr			resb 2			; List containing 640 byte blocks.
	ListSixPointer		resb 2			; List containing 1240 byte blocks.

SECTION .text
	global bufferInitialize
	global bufferDestroy
	global allocData
	global deallocData



