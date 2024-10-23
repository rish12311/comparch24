.data
array:  .word 5, 10, 15, 20, 25   # Array of integers
length: .word 5                   # Length of the array
sum:    .word 0                   # Store the result here

.text
.globl main

main:
    la   $t0, array      # Load address of the array into $t0
    lw   $t1, length     # Load the length of the array into $t1
    li   $t2, 0          # Initialize sum in $t2 to 0
    li   $t3, 0          # Index counter (i) in $t3

loop:
    beq  $t3, $t1, exit  # If index == length, exit the loop
    lw   $t4, 0($t0)     # Load array element into $t4
    add  $t2, $t2, $t4   # Add element to the sum
    addi $t0, $t0, 4     # Move to the next element (word is 4 bytes)
    addi $t3, $t3, 1     # Increment index
    j    loop            # Repeat the loop

exit:
    sw   $t2, sum        # Store the sum in memory

    # Exit the program
    li   $v0, 10         # Exit syscall
    syscall
