%include "asm_io.inc"

SECTION .data

error1: db "Incorrect number of command line arguments (Enter one number)",0
error2: db "Not a valid command line argument (Between 2 and 9)",0
msg1: db "Command line arguments are good, you entered: ",0
peg: dd 0,0,0,0,0,0,0,0,0
disc1: db "         o|o",0
disc2: db "        oo|oo",0
disc3: db "       ooo|ooo",0
disc4: db "      oooo|oooo",0
disc5: db "     ooooo|ooooo",0
disc6: db "    oooooo|oooooo",0
disc7: db "   ooooooo|ooooooo",0
disc8: db "  oooooooo|oooooooo",0
disc9: db " ooooooooo|ooooooooo",0
base: db  "XXXXXXXXXXXXXXXXXXXXXX",0
msg2: db "The final sorted configuration is: ",0
msg3: db "The initial configuration is: ",0
numberOfDiscs: dd 0

SECTION .bss

SECTION .txt
   global asm_main

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Subroutine for sorting
sorthem:
	enter 0, 0					; enter and pushes all registers
	pusha

	mov ebx, [ebp+12] 				; puts the number of discs into ebx
	mov ecx, [ebp+8]				; puts the address to the first element in ecx 

	cmp ebx, dword 1				; if the number of discs is 1, go to the end
	je Sorthem_End

	dec ebx						; decreases the number of discs by 1 then pushes it to the stack
	push ebx					
	add ecx, 4					; gets the address of the next value of the array then pushes it
	push ecx
	call sorthem					; recursively calls sorthem
	pop ecx						; pops and stores in ecx and ebx
	pop ebx

	mov edx, dword 0				; this is my i value that is being iterated over
	jmp Sorting_Loop		

Sorthem_End:
	popa
	leave
	ret

Sorting_Loop:
	mov eax, ebx					; checks to see if i = number of discs -1, jumping if it is
	sub eax, dword 1
	cmp eax, edx
	je Loop_End

	mov eax, dword [ecx]				; moves into eax, the value of the element in the array
	cmp eax, dword [ecx+4]				; compares the value of the array, to the next one
	jae Loop_End					; jumps if it is equal to or greater to
	jmp Swap					; if they are not equal to or greater than swap
	
Swap:	
	mov eax, dword [ecx]				; Moves into eax, the value of the element in the array
	mov esi, dword [ecx+4]				; Moves into esi, the value of the elemnt after it
	mov [ecx+4], eax				; Changes the values of the two elements in the array  
	mov [ecx], esi
	add ecx, dword 4				; Moves the "pointer" to the next element in the array
	inc edx						; increment i
	jmp Sorting_Loop			

Loop_End:
	mov ebx, peg					; pushes number of discs, then array, and prints them via showp
	mov ecx, numberOfDiscs
	push ecx					
	push ebx
	call showp
	pop ebx
	pop ecx
	jmp Sorthem_End					; goes to end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Subroutine for showing the pegs configuration
showp:
	enter 0, 0					; Enter and pushes all the registers
	pusha
	
	jmp Show_Pegs_Setup			

Show_Pegs_Setup:
	call print_nl					; prints a new line
	mov ebx, [numberOfDiscs]			; moves into ebx, the number of discs
	mov eax, ebx					; moves into eax, the number of discs
	mov edx, dword 4				; makes edx, 4
	mul edx						; multiplies eax by 4
	sub eax, 4					; subtracts eax by 4
	;;;;;;;;; At this point eax is now a number that when added to the address of the array
	;;;;;;;;; will point to the last member
	mov edx, eax					; moves into edx, eax
	mov ecx, [ebp+8]				; moves into ecx, the address of the first array
	mov eax, dword [ecx+edx]			; moves into eax, the actual value of the final element in the array
	jmp Loop_to_print_Discs		

Loop_to_print_Discs:
	cmp ebx, dword 0				; compares the number of discs to 0, jumping to end if it is 0
	je End_Showp

	cmp eax, dword 9				; compares the value of the array and prints out the associated string
	je print9
	cmp eax, dword 8
	je print8
	cmp eax, dword 7
	je print7
	cmp eax, dword 6
	je print6
	cmp eax, dword 5
	je print5
	cmp eax, dword 4
	je print4
	cmp eax, dword 3
	je print3
	cmp eax, dword 2
	je print2
	cmp eax, dword 1
	je print1

print1:							; One of 9 print statements to print out the discs in a line						
	mov eax, disc1
	call print_string
	call print_nl
	jmp Setup_for_next_Print
	
print2:
	mov eax, disc2
	call print_string
	call print_nl
	jmp Setup_for_next_Print

print3:
	mov eax, disc3
	call print_string
	call print_nl
	jmp Setup_for_next_Print

print4:
	mov eax, disc4
	call print_string
	call print_nl
	jmp Setup_for_next_Print

print5:
	mov eax, disc5
	call print_string
	call print_nl
	jmp Setup_for_next_Print

print6:
	mov eax, disc6
	call print_string
	call print_nl
	jmp Setup_for_next_Print

print7:
	mov eax, disc7
	call print_string
	call print_nl
	jmp Setup_for_next_Print

print8:
	mov eax, disc8
	call print_string
	call print_nl
	jmp Setup_for_next_Print

print9:
	mov eax, disc9
	call print_string
	call print_nl
	jmp Setup_for_next_Print

Setup_for_next_Print:
	dec ebx						; decrements the number of discs, stored in ebx			
	sub edx, 4					; subtracts edx, so that can access the previous element in the array
	mov eax, dword [ecx+edx]			; moves into eax the value of the elmenet that comes before the previous one
	jmp Loop_to_print_Discs

End_Showp:			
	mov eax, base					; moves into eax the base string and prints it out
	call print_string
	call print_nl
	call read_char					; waits for user enter
	
	popa						; pops, leaves, returns
	leave
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_main:
	enter 0,0
	pusha

	mov eax, [ebp+8]				; moves the number of cmd line arguments into eax
	cmp eax, dword 2				; checks to see if there is two cmd line arguments
	jne Incorrect_Number_Of_Arguments		; executes error if wrong number

	mov ebx, dword [ebp+12]				; moves into ebx address for the cmd line vector
	mov eax, dword [ebx+4]				; stores the value of the second argument in eax

	mov bl, byte [eax]				; moves the first byte of the second argument into bl

	cmp bl, '2'					; series of comparisons to determine if it is between 2 and 9
	je OK
	cmp bl, '3'
	je OK
	cmp bl, '4'
	je OK
	cmp bl, '5'
	je OK
	cmp bl, '6'
	je OK
	cmp bl, '7'
	je OK
	cmp bl, '8'
	je OK
	cmp bl, '9'
	je OK

	jmp Incorrect_Arguments				; executes error if not in specified range


OK:
	mov bl, byte [eax+1]				; moves into bl the second byte in the second argument
	cmp bl, byte 0					; checks to see if it is 0
	jne Incorrect_Arguments				; executes error if not 0
	
	mov eax, msg1					; prints out message
	call print_string
	mov ebx, dword [ebp+12]				; gets the first byte of the second cmd line argument
	mov eax, dword [ebx+4]		
	mov bl, byte [eax]
	mov al, bl
	call print_char					; prints out the number
	call print_nl
	jmp Random_Config_and_Sort		
	
Random_Config_and_Sort:
	sub bl, '0'
	mov ecx, 0				
	mov cl, bl					; ecx now is a value from 2 - 9
	mov ebx, peg					; moves the address to the peg array into ebx 
	mov [numberOfDiscs], ecx			; moves into a global variable the number of discs 
	push ecx					; pushes the number of discs on the stack
	push ebx					; pushes the addres of the array representing the peg onto the stack
	call rconf					; reconf randmozies the array
	pop ebx						; stores the address to the array in ebx and moves the stack pointer +4
	pop ecx						; stores the number of discs in cx and moves the stack pointer +4

	call print_nl
	mov eax, msg3					; Prints out message 3 saying that it is the initial config
	call print_string
	call print_nl

	push ecx					; pushes ecx and ebx onto the stack
	push ebx
	call showp					; showp displays the peg configuration 
	pop ebx						; stores what was previouly in ebx and ecx in them again and moves esp +8
	pop ecx
	
	mov ebx, peg	

	push ecx					; Pushes the number of discs, and the address for the array of discs
	push ebx	
	call sorthem					; sorts them
	pop ebx						; pops and stores and moves the stack pointer
	pop ecx
	mov edx, dword 0
	jmp Final_Sort

; Because the recursive sort does not sort the bottom value, it needs to be sorted manually
; The following two labels use the exact same logic (loop and swap) to sort the bottom element
Final_Sort:
	mov eax, ecx
	sub eax, dword 1
	cmp eax, edx
	je End
	
	mov eax, dword [ebx]
	cmp eax, dword [ebx+4]
	jae End
	jmp Swap_Final

Swap_Final:
	mov eax, dword [ebx]
	mov esi, dword [ebx+4]
	mov [ebx+4], eax
	mov [ebx], esi
	add ebx, dword 4
	inc edx
	jmp Final_Sort

End:	
	mov eax, msg2					; Prints out a final message
	call print_string
	call print_nl
	push ecx					; pushes ecx and ebx onto the stack
	push peg
	call showp					; showp displays the peg configuration
	pop ebx						; Pops and then moves esp +8
	pop ecx

	jmp asm_main_end				; exits the program

Incorrect_Number_Of_Arguments:				; print warning message and exit the program
	mov eax, error1
	call print_string
	call print_nl
	jmp asm_main_end

Incorrect_Arguments:					; print warning message and exit the program
	mov eax, error2
	call print_string
	call print_nl
	jmp asm_main_end	
	
asm_main_end:						; exit the program procedure
	popa
	leave
	ret
