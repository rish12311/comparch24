.data
prompt: .asciiz "Enter the number of nodes: "
inputMsg: .asciiz "Enter node value: "
sumMsg: .asciiz "Sum: "
avgMsg: .asciiz "Average: "
newline: .asciiz "\n"
array: .space 400  # Reserve space for up to 100 integers (4 * 100 = 400 bytes)

.text
.globl main

main:
    # Prompt user to enter the number of nodes
    la $a0, prompt
    li $v0, 4
    syscall

    # Read number of nodes
    li $v0, 5
    syscall
    move $t0, $v0      # Store number of nodes in $t0

    li $t1, 0          # Initialize sum to 0
    li $t2, 0          # Index counter for array

input_loop:
    # Check if all nodes are processed
    beq $t2, $t0, compute_avg

    # Prompt for node value
    la $a0, inputMsg
    li $v0, 4
    syscall

    # Read node value
    li $v0, 5
    syscall
    move $t3, $v0      # Store input value in $t3

    # Store value in array
    la $a0, array      # Base address of the array
    mul $t4, $t2, 4    # Calculate offset (t2 * 4)
    add $t4, $a0, $t4  # Address of array[t2]
    sw $t3, 0($t4)     # Store input value at array[t2]

    # Add value to sum
    add $t1, $t1, $t3

    # Increment index counter
    addi $t2, $t2, 1
    j input_loop

compute_avg:
    # Compute average = sum / number of nodes
    div $t1, $t0
    mflo $t5  # Store average in $t5

    # Print sum (optional)
    la $a0, sumMsg
    li $v0, 4
    syscall

    move $a0, $t1
    li $v0, 1
    syscall

    # Print average (optional)
    la $a0, newline
    li $v0, 4
    syscall

    la $a0, avgMsg
    li $v0, 4
    syscall

    move $a0, $t5
    li $v0, 1
    syscall

    la $a0, newline
    li $v0, 4
    syscall

subtract_and_print:
    li $t2, 0  # Reset index counter

print_loop:
    # Check if all nodes are processed
    beq $t2, $t0, exit

    # Load value from array
    la $a0, array
    mul $t4, $t2, 4    # Calculate offset
    add $t4, $a0, $t4  # Address of array[t2]
    lw $t3, 0($t4)     # Load value from array

    # Subtract average from the value
    sub $t3, $t3, $t5

    # Print the modified value
    move $a0, $t3
    li $v0, 1
    syscall

    # Print newline
    la $a0, newline
    li $v0, 4
    syscall

    # Increment index counter
    addi $t2, $t2, 1
    j print_loop

exit:
    li $v0, 10  # Exit the program
    syscall
