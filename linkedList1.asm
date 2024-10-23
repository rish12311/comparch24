#get a linked list from input until 0 is entered
#print the list back

#typedef struct node{
#	int val;
#	struct *node next;
#};

.data
	question:    .asciiz "Enter a number (0 to stop): "
	newline:   .asciiz "\n"
	node_val:  .asciiz "Node value: "

.text
	#initiliaze a0 to nonZero
	addi $a0, $zero, 8
	
	#base address for linked list is $t0
	li $t0, 0           # $t0 = head (NULL initially)
    	li $t1, 0           # $t1 = tail (NULL initially)
    	li $s0, 0           # $s0 will store the input value
	
	
	#get the input until 0

    	li $v0, 4
	la $a0, question
	syscall
	
	readInput:
		
		#input the number
		li $v0, 5
		syscall
		move $s0, $v0
		
		#end if 0
		li $t2, 0
		beq $v0, $t2, traverse_list
		
		#allocate the memory
		li $v0, 9
		li $a0, 8
		syscall
		move $t3, $v0       # $t3 will hold the address of the new node
		
		# ______________________________
		# |4 bytes (Int)|4 bytes (add)	|
		# |_____________|_______________|
		sw $s0, 0($t3) 	   # set 1st 4 bytes to value of input
		
		li $t4, 0
    		sw $t4, 4($t3)
    		
    		beq $t0, $zero, head # set t0 as head 
    		sw $t3, 4($t1)
	
	head:
		# Set head if it’s the first node
    		beq $t0, $zero, store_head

    		# Update the tail to the new node
    		move $t1, $t3
    		b readInput
    	
    	store_head:
    		move $t0, $t3       # Set head to new node
    		move $t1, $t3       # Set tail to new node (first node)
    		b readInput        # Go back to read more input 
    		
    	traverse_list:
		    # Print the list contents header
		    li $v0, 4
		    la $a0, newline
		    syscall

		    # Traverse the list and print each node's value
		    move $t3, $t0       # Start at head

	traverse_loop:
		    beq $t3, $zero, end_program  # Exit if we reach the end of the list (NULL)

		    # Print "Node value: "
		    li $v0, 4
		    la $a0, node_val
		    syscall

		    # Load and print the value in the current node
		    lw $a0, 0($t3)      # Load the value from the current node
		    li $v0, 1           # Syscall for printing integer
		    syscall
		    
		    # Print the list contents header
		    li $v0, 4
		    la $a0, newline
		    syscall

		    # Move to the next node
		    lw $t3, 4($t3)      # Load the next pointer from the current node
		    j traverse_loop

	end_program:
		    # Exit the program
		    li $v0, 10          # Syscall for exit
		    syscall
