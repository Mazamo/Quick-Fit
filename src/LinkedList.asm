; Source name			: LinkedList.asm
; Exectuable name		: None
; Version				: 1.0
; Created date			: 01/02/2018
; Last update			: 10/02/2018
; Author				: Nick de Visser
; Description			: An implementation of a double linked list data structure using 
; 						  NASM 2.11.08.
;
; List layout:
;	head: pointer to the head node
;	tail: pointer to the tail node
;
; Node layout:
;	next: pointer to the next node
;	prev: pointer to the previous node
;	data: pointer to the data inside the node

global ListSize					; The size of a list structure.
global NodeSize					; The size of a node structure.

SECTION .data

SECTION .bss
	ListSize		equ 8		; The size of a list structure in bytes.
	NodeSize		equ 12		; The size of a node structure in bytes.
	
SECTION .text
	global createLinkedList		; Create a new list instance.
	global destroyLinkedList	; Destroy a list and its nodes.
	global addFront				; Add a new node to the front of the list.
	global addBack				; Add a new node to the back of the list.
	global addIndex				; Add a new node after a specified index.
	global deleteFront			; Delete the front node.
	global deleteBack			; Delete The back node.
	global deleteIndex			; Delete the node on the specified index.
	global getFront				; Retrieve the data stored in the head node.
	global getBack				; Retrieve the data stored in the tail node.
	global getIndex				; Retrieve the data stored in the n'th node of the list.
	global findData 			; Iterate through the list and search for a criterium.
	global printElements		; Iterate through the list and print each element.


	;-----------------------------------------------------------------------------	
	; Construction method for a linked list structure. This method intializes the 
	; linked list structure by initialising both the head and tail nodes with the
	; vaule of zero indicating that the list is empty. -- Last update 02/02/2018
	;
	; Parameters:
	;	EAX: Destination address
	;
	; Return:
	;	None
	;-----------------------------------------------------------------------------
	createLinkedList:				
		cmp eax, 0					; Determine if eax points to a valid memory address.
		jne .initializeList			; If eax does not point to a null pointer. 
		ret							; If eax is a nullptr leave the routine.

	.initializeList:
		mov	dword [eax], 0			; Set the head node to null.
		mov dword [eax + 4], 0		; Set the tail node to null.
		ret

	;-----------------------------------------------------------------------------
	; Destroy a linked list and each of its members by setting them to zero.
	; -- Last update 01/02/2018
	;
	; Parameters:
	;	EAX: Address of the linked list
	;
	; Return:
	;	None
	;-----------------------------------------------------------------------------
	destroyLinkedList:
		push eax					; Store the used registers on the stack.
		push ebx

		cmp eax, 0					; Determine if eax represents a valid memory address.
		jne .iterateThroughList		; If eax is valid iterate through the list.

		; If a pointer to an invalid address was provided.
		pop ebx						; Pop the used registers from the stack.
		pop eax
		ret

	.iterateThroughList:
		cmp dword [eax], 0			; Determine if the list is empty.
		je .doneDestroying			; If the list is empty leave the routine.

		call deleteFront			; Delete the head node of the list.
		jmp .iterateThroughList		; Repeat the above.

	.doneDestroying:
		pop ebx						; Restore the used registers to their original state.
		pop eax

		mov dword [eax], 0			; Destroy the linked list's head node reference.
		mov dword [eax], 0			; Destroy the linked list's tail node reference.
		ret

	;-----------------------------------------------------------------------------
	; Addition of the first node to a list structure. This procedure is used
	; whenever data is added to either end of an empty list structure.
	; -- Last update 01/02/2018
	;
	; Parameters:
	;	EAX: Address of the linked list
	;   EBX: Address of the data added to the linked list
	;	ECX: Address of the location that can store the new node
	;
	; Return:
	;	None
	;-----------------------------------------------------------------------------
	addFirstNode:
		push eax
		push ecx

		cmp eax, 0					; Determine if eax represents a valid address.
		je .doneAdding				; If eax is invalid leave the routine.

		cmp ebx, 0					; Determine if ebx represents a valid address.
		je .doneAdding				; If ebx is invalid leave the routine.

		cmp ecx, 0					; Determine if ecx represents a valid address.
		je .doneAdding				; If ecx is invalid leave the routine.
		
		mov dword [eax], ecx		; Set the head node to ecx.
		mov dword [eax + 4], ecx	; Set the tail node to ecx.
		mov dword [ecx], 0			; Set the next member of the new node to null.
		mov dword [ecx + 4], 0		; Set the prev member of the new node to null.
		mov dword [ecx + 8], ebx	; Set the data member of the new node to reference the data's address.

	.doneAdding:
		pop ecx
		pop eax
		ret

	;-----------------------------------------------------------------------------
	; Addition of data to the front of the list structure -- Last update 01/02/2018
	; 
	; Parameters:
	;	EAX: Address of the linked list
	;	EBX: Address of the data to be added to the linked list
	;	ECX: Address of the location that can store the new node
	;
	; Return:
	;	None
	;-----------------------------------------------------------------------------
	addFront:
		push eax					; Store the used registers on the stack.
		push ebx
		push ecx					
		push edx

		cmp eax, 0					; Determine if eax represents a valid address.
		je .doneAdding				; If eax is invalid leave the routine.

		cmp ebx, 0					; Determine if ebx represents a valid address.
		je .doneAdding				; If ebx is invalid leave the routine.

		cmp ecx, 0					; Determine if ecx represents a valid address.
		je .doneAdding				; If ecx is invalid leave the routine.

		cmp dword [eax], 0			; Determine if the list already contains a head node.
		jne .addNode				; If the list is not empty add another node.

		call addFirstNode			; If the list is empty add a first node.
		jmp .doneAdding				; Leave the routine.
		
	.addNode:
		mov edx, [eax]				; Move the address of the head node in edx.
		mov dword [edx + 4], ecx	; Set the prev member of the current head node to the new node.
		mov dword [ecx], edx		; Set the next member of the new node to the current head node.
		mov dword [eax], ecx		; Set the head member of the list to the new node.
		mov dword [ecx + 4], 0		; Set the prev memeber of the new node to null.
		mov dword [ecx + 8], ebx	; Set the data member of the new node to reference the data's address.

	.doneAdding:
		pop edx						; Restore the used registers to their original state.
		pop ecx
		pop ebx
		pop eax
		ret

	;-----------------------------------------------------------------------------
	; Addition of data to the back of the list structure -- Last update 01/02/2018
	;
	; Parameters:
	;	EAX: Address of the linked list
	;	EBX: Address of the data to be added to the linked list
	;	ECX: Address of the location that can store the new node
	;
	; Return:
	;	None
	;-----------------------------------------------------------------------------
	addBack:
		push eax					; Store the used registers on the stack.
		push ebx
		push ecx
		push edx

		cmp eax, 0					; Determine if eax represents a valid address.
		je .doneAdding				; If eax is invalid leave the routine.

		cmp ebx, 0					; Determine if ebx represents a valid address.
		je .doneAdding				; If ebx is invalid leave the routine.

		cmp ecx, 0					; Determine if ecx represents a valid address.
		je .doneAdding				; If ecx is invalid leave the routine.
	
		cmp dword [eax + 4], 0		; Determine if the list already contains a tail node.
		jne .addNode				; If the list is not empty add another node.

		call addFirstNode			; If the list is empty add a first node.
		jmp .doneAdding				; Leave the routine.
		
	.addNode:
		mov edx, [eax + 4]			; Move the address of the tail node in edx.
		mov dword [edx], ecx		; Set the next node of the current tail node to the new node.
		mov dword [ecx + 4], edx	; Set the prev node of the new node to the current tail node.
		mov dword [eax + 4], ecx	; Set the tail member of the list to the new node.
		mov dword [ecx], 0			; Set the next member of the new node to null.
		mov dword [ecx + 8], ebx	; Set the data member of the new node to reference the data's
									; address.

	.doneAdding:
		pop edx						; Restore the used registers to their original state.
		pop ecx
		pop ebx
		pop eax
		ret

	;-----------------------------------------------------------------------------
	; Addition of data to the list after a specified index parameter. 
	; -- Last update 02/02/2018
	;
	; Parameters:
	;	EAX: Address of the linked list
	;	EBX: Address of the data to be added to the linked list
	;	ECX: Address of the location that can store the new node
	;	EDX: Index after which the data will be added to the list
	;
	; Return:
	;	None
	;-----------------------------------------------------------------------------
	addIndex:
		push edi					; Store the used registers on the stack.
		push edx
		push ebx
		push eax

		cmp eax, 0					; Determine if eax represents a valid address.
		je .noAction				; If eax is invalid leave the routine. 

		cmp ebx, 0					; Determine if ebx represents a valid address.
		je .noAction				; If eax is invallid leave the routine.

		cmp dword [eax], 0			; Determine if the list's head node is a null pointer.
		jne .preIterate				; If the list is not empty iterate through the list.

		cmp edx, 0					; Determine if the index indicates the first element of the list.
		jne .noAction				; If the index is not zero whilst the list is empty leave the routine.

		call addFirstNode			; Since the list is empty and the index is zero call addFirstNode.
		jmp .noAction				; Leave the routine.

	.preIterate:
		mov eax, [eax]
	.iterateThroughList:
		cmp edx, 0					; Determine if the element is reached.
		je .addNode					; If the element has been reached add a node after it.

		cmp dword [eax], 0			; Determine if the next member of the next node is a null pointer.
		je .noAction				; If the end of the list has been reached whilst edx isn't 0.

		mov eax, [eax]				; Move the next member into eax.
		dec edx						; Decrement the index counter.
		jmp .iterateThroughList		; Loop around.

	.addNode:
		lea edx, [eax]				; Move the address of the node into eax.
		pop eax						; Restore eax with the address of the list.
		
		cmp dword [edx + 4], 0		; Determine if edx is the first node in the list.
		je .addHeadNode				; If edx is the current head nod add a new head node to the list.

		cmp dword [edx], 0			; Determine if edx is the last node in the list.
		je .addTailNode				; If edx is the current tail node add a new tail node to the list.

		mov edi, [edx]				; Move the next member of the node into edi.
		mov dword [edx], ecx		; Move the address of the to be added node into edx's next member.
		mov dword [edi + 4], ecx	; Move the address of the to be added node into ebx's prev member.

		mov dword [ecx], edi		; Move the value of edi in the to be added node's next member.
		mov dword [ecx + 4], edx	; Move the value of edx in the to be added node's prev member.
		mov dword [ecx + 8], ebx	; Move the address of the data in the to be added node's data member.
		jmp .doneAdding				; Leave the routine.
	
	.addTailNode:
		call addBack
		jmp .doneAdding

	.addHeadNode:
		call addFront
		jmp .doneAdding
		
	.noAction:	
		pop eax						; Restore the eax with the address of the list.
	.doneAdding:
		pop ebx
		pop edx
		pop edi						; Restore the used register to its original state.
		ret

	;-----------------------------------------------------------------------------
	; Retrieves the data stored in the list's head node	-- Last update 01/02/2018
	;
	; Parameters:
	;	EAX: Address of the linked list
	;	
	; Return:
	;	EAX: Address of the requested data 
	;-----------------------------------------------------------------------------
	getFront:
		push ebx					; Store the used register on the stack.

		cmp eax, 0					; Determine if eax represents a valid address.
		je .doneRetrieving			; If eax is invalid leave the routine.

		cmp dword [eax], 0			; Determine if the list is empty.
		je .doneRetrieving			; If the list is empty no further action should take place.
		
		mov ebx, [eax]				; Move the address of the head node into ebx.
		mov eax, [ebx + 8]			; Move the address of the head node's data member into eax.

	.doneRetrieving:
		pop ebx						; Restore the used register to its original state.
		ret

	;-----------------------------------------------------------------------------
	; Retrieves the data stored in the list's tail node	-- Last update 01/02/2018
	;
	; Parameters:
	;	EAX: Address of the linked list
	;
	; Return:
	;	EAX: Address of the requested data
	;-----------------------------------------------------------------------------
	getBack:
		push ebx					; Store the used register on the stack.

		cmp eax, 0					; Determine if eax represents a valid address.
		je .doneRetrieving			; If eax is invalid leave the routine.

		cmp dword [eax], 0			; Determine if the list is empty.
		je .doneRetrieving 

		mov ebx, [eax + 4]			; Move the address of the tail node into ebx.
		mov eax, [ebx + 8]			; Move the address of the tail node's data member into eax.

		.doneRetrieving:
		pop ebx						; Restore the used register to its original state.
		ret

	;-----------------------------------------------------------------------------
	; Retrieves the data stored in the list's n'th element -- Last update 04/02/2018
	;
	; Parameters:
	;	EAX: Address of the linked list
	;	EBX: Index of the data node
	;
	; Return:
	;	EAX: Address of the requested data
	;-----------------------------------------------------------------------------
	getIndex:
		push ecx					; Store the used register on the stack.

		cmp eax, 0					; Determine if eax represents a valid address.
		je .doneRetrieving			; If eax is invalid leave the routine.

		cmp dword [eax], 0			; Determine if the list contains elements.
		mov eax, [eax]				; Move the first node into eax.
		jne .iterateThroughList		; If the list is not empty iterate through the list.
		
		jmp .elementNotFound		; Leave the routine.

	.iterateThroughList:			
		cmp ebx, 0					; Determine if the index is null.
		je .getData					; If the index has been reached retrieve the data stored in the node.

		cmp dword [eax], 0			; Determine if the nodeś next member is a null pointer.
		je .elementNotFound			; Determine if the end of the list is reached without reaching ebx.

		mov eax, [eax]				; Move the next member of eax into eax.
		dec ebx						; Decrement the index counter.
		jmp .iterateThroughList		; Loop back.

	.getData:
		mov eax, [eax + 8]			; Move the address of the node's data member into eax.
		jmp .doneRetrieving			; Leave the routine.

	.elementNotFound:
		mov eax, 0					; Mov an invalid null pointer into eax.
		
	.doneRetrieving:
		pop ecx						; Restore the used register to its original state.
		ret

	;-----------------------------------------------------------------------------
	; Deletes the first element from the list -- Last update 02/02/2018
	;
	; Parameters:
	;	EAX: Address of the linked list
	;
	; Return:
	;	None
	;-----------------------------------------------------------------------------
	deleteFront:
		push ebx					; Store the used registers on the stack.
		push ecx

		cmp eax, 0					; Determine if eax represents a valid address.
		je .doneDeleting			; If eax is invalid leave the routine.

		cmp dword [eax], 0			; Determine if the list is empty.
		je .doneDeleting			; If the list is empty leave the routine.
		
		mov ebx, [eax]				; Move the current front node into ebx.
		mov dword [ebx + 8], 0		; Remove the reference to the data stored in the head node.
		mov ecx, [ebx]				; Move the potentially third element into ecx.
		mov dword [ebx], 0			; Remove the reference to the next node from the head node.
	
		mov dword [eax], ecx		; Replace the head node in the list.
		
		cmp dword [eax], 0			; Determine if the removed node was the only node in the list.
		je .setNewTail				; If no nodes are present anymore in the list remove all references.

		mov dword [ecx + 4], 0		; Remove the reference to the previous node from the next node.
		jmp .doneDeleting			; Leave the routine.
		
	.setNewTail:
		mov dword [eax + 4], 0		; Remove the list's reference to the tail node.

	.doneDeleting:
		pop ecx						; Restore the used registers to their original state.
		pop ebx
		ret

	;-----------------------------------------------------------------------------
	; Deletes the last element from the list -- Last update 03/02/2018
	;
	; Parameters:
	;	EAX: Address of the linked list
	;
	; Return:
	;	None
	;-----------------------------------------------------------------------------
	deleteBack:
		push ebx					; Store the used registers on the stack.
		push ecx

		cmp eax, 0					; Determine if eax represents a valid address.
		je .doneDeleting			; If eax is invalid leave the routine.

		cmp dword [eax], 0			; Determine if the list is empty.
		je .doneDeleting			; If the list is empty leave the routine.

		mov ebx, [eax + 4]			; Move the tail node into ebx.
		mov dword [ebx + 8], 0		; Remove the reference to the data stored in the head node.
		mov ecx, [ebx + 4]			; Move the previous member of the tail node into ecx.
		mov dword [eax + 4], ecx	; Replace the list's tail member with ecx.

		cmp dword [eax + 4], 0		; Determine if the new tail member is a null pointer.
		je .setNewHead				; If no nodes are present anymore in the list remove all references.

		mov dword [ecx], 0			; If the new tail node is not a null pointer remove its next member.
		jmp .doneDeleting			; Leave the routine.

	.setNewHead:
		mov dword [eax], 0			; Remove the list's reference to the tail node.

	.doneDeleting:
		pop ecx						; Restore the used registers to their original state.
		pop ebx
		ret

	;-----------------------------------------------------------------------------
	; Delete the element on the specified index from the list 
	; -- Last update 03/02/2018
	;
	; Parameters:
	;	EAX: Address of the linked list
	;	EBX: Index from the eletem which will be deleted
	;
	; Return:
	;	None
	;-----------------------------------------------------------------------------
	deleteIndex:
		push ebx					; Store the used registers on the stack.
		push ecx
		push edx
		push eax					

		cmp eax, 0					; Determine if eax represents a valid address.
		je .doneDeleting			; If eax is invalid leave the routine.

		cmp dword [eax], 0			; Determine if the list is empty.
		je .noAction				; If the list is empty leave the routine.

		mov eax, [eax]				; Move the head member into eax.
		
	.iterateThroughList:
		cmp ebx, 0					; Determine if the index has been reached.
		je .deleteNode				; If the index has been reached delete the node.

		cmp dword [eax], 0			; Determine if the next node is a null pointer.
		je .noAction				; If the list's end is reached without reaching ebx leave the routine.

		mov eax, [eax]				; Move the next member into eax.
		dec ebx						; Decrement the index counter.
		jmp .iterateThroughList		; Loop around.
		
	.deleteNode:
		lea ecx, [eax]				; Store the node in eax into ecx.
		pop eax						; Restore eax with the list's address.

		; Determine if the to be deleted node is the only node in the list.
		mov ebx, [eax + 4]			; Move the tail node's address into ebx.
		cmp dword [eax], ebx		; Determine if the list contains one node.
		je .clearList

		; Detemine if the to be delete node is the head node.
		cmp dword [ecx + 4], 0		; Determine if the node contains a prev member.
		je .noPrevMember			; If the node does not contain a prev member is is the head node.

		; Determine if the to be deleted node is the tail node.
		cmp dword [ecx] , 0			; Determine if the node contains a next member.
		je .noNextMember			; If the node does not contain a next member it is the tail node.

		; The node is in the middle of atleast two other nodes.
		mov ebx, [ecx]				; Move the next member of ecx into ebx.
		mov edx, [ecx + 8]			; Move the previous member of ecx into edx.

		mov dword [ebx], edx		; Set the next member of ebx to edx.
		mov dword [edx + 4], ebx	; Set the previous member of edx to ebx.

		mov dword [ecx], 0			; Remove the next member of ecx.
		mov dword [ecx + 4], 0		; Remove the prev member of ecx.
		mov dword [ecx + 8], 0		; Remove the data member of ecx.

		jmp .doneDeleting

	.noPrevMember:
		call deleteFront			; Since the ebx'th node is the head node call the respective routine. 
		jmp .doneDeleting			; Leave the routine.

	.noNextMember:
		call deleteBack				; Since the ebx'th node is the tail node call the respective routine.
		jmp .doneDeleting			; Leave the routine.

	.clearList:
		mov dword [ecx + 8], 0		; Remove the data member of ecx.

		mov dword [eax], 0			; Remove the list's head node.
		mov dword [eax + 4], 0		; Remove the list's tail node.
		jmp .doneDeleting
		
	.noAction:
		pop eax
	.doneDeleting:
		pop edx						; Restore the used register to their original state.
		pop ecx
		pop ebx
		ret

	;-----------------------------------------------------------------------------
	; Finds a node based on a specific criterium which is specief in a pointer 
	; to a function. -- Last update 05/02/2018
	;
	; Parameters:
	; 	EAX: Pointer to the linked list
	; 	EBX: Pointer to the search function.
	;   ECX: Value to be compared in the search function.
	;
	; Return:
	; 	EAX: Pointer to the data member of the find node or a nullptr if no node 
	;		 is found.
	;-----------------------------------------------------------------------------
	findData:
		push ebx					; Store the used registers on the stack.
		push ecx

		cmp eax, 0					; Determine if eax contains a valid value.
		je .noAction				; If eax is invallid leave the routine.

		cmp ebx, 0					; Determine if ebx contains a valid value.
		je .noAction				; If eax is invallid leave the routine.

		cmp dword [eax], 0			; Determine if the linked list is empty.
		je .noAction				; If the linked list is empty leave the routine.

		mov eax, [eax]				; Move the first node of the list into eax.
	.iterateThroughList:
		push eax					; Store the current node on the stack.
		mov eax, [eax + 8]			; Store the data stored in the current node into eax.
		call ebx					; Call the routine for searching the data member.
		mov ecx, eax				; Store the return value in ecx.
		pop eax						; Restore the current node value into eax.

		cmp ebx, 1					; Determine if the current node is the right node.
		je .foundData				; If the current node is the right node leave the routine.

		mov eax, [eax]				; Move the current node's next member into eax.
		
		cmp eax, 0					; Determine if the next node is a nullptr (end of the list).
		je .doneFinding				; If the end has been reached leave the routine.

		jmp .iterateThroughList		; Loop around.

	.foundData:
		mov eax, [eax + 8]			; Move the address of the searched data into eax.
		jmp .doneFinding			; Leave the routine.

	.noAction:
		mov eax, 0					; Move a invallid state into eax.

	.doneFinding:
		pop ecx						; Restore the used registers to their original state.
		pop ebx
		ret

	;-----------------------------------------------------------------------------
	; Retrieves the elements from the provided list and prints them usng the 
	; provided method. -- Last update 10/02/2018
	;
	; Parameters:
	; 	EAX: Pointer to the list from which the memory block's elements are printed
	; 	EBX: Method used to print the data members values
	;
	; Return:
	; 	None
	;-----------------------------------------------------------------------------
	printElements:
		push eax
		push ebx
		push ecx					; Store the used registers on the stack.
		push edx 

		cmp eax, 0					; Determine if eax is valid. 
		je .donePrinting			; If eax is invalid leave the routine.

		cmp dword [eax], 0			; Deterrmine if the list contains elements.
		je .donePrinting			; If the list is empty leave the routine.

		mov ecx, eax				; Move the address of the linked list into ecx.
		mov edx, ebx				; Move the printing method into edx.
		mov ebx, 0					; Move the first index into edx.

	.iterateThroughList:
		mov eax, ecx				; Move the address of the linked list into eax.
		call getIndex				; Retrieve the edx'th node from the list.
		
		cmp eax, 0					; Determine if a null pointer was returned (empty list).
		je .donePrinting			; If a null pointer was returned leave the routine.

		call edx					; Print the contents of the element.
		inc ebx						; Increment edx to be able to call the node.
		jmp .iterateThroughList		; Loop around.

	.donePrinting:
		mov eax, ecx				; Restore eax with the value of the list.

		pop edx						; Restore the used registers to their orignal state.
		pop ecx
		pop ebx
		pop eax
		ret 
