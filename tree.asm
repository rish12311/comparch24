.data
prompt: .asciiz "Enter the number of nodes: "
inputMsg: .asciiz "Enter node value: "
newline: .asciiz "\n"
sumStr: .asciiz "Sum: "
avgStr: .asciiz "Average: "
.text

# Function prototypes
.globl main
.globl buildTree
.globl inorderSubtractAndPrint

# Node structure: value, left, right (each word = 4 bytes)
# Input:
# $a0 = node address
# $a1 = input value
# Builds the binary search tree
buildTree:
    lw $t0, 0($a0)        # Load current node's value
    beq $t0, $zero, insert  # If empty, insert node
    bgt $a1, $t0, right    # If input > node, go right
left:
    lw $a0, 4($a0)        # Move to left child
    jal buildTree         # Recursive call
    jr $ra

right:
    lw $a0, 8($a0)        # Move to right child
    jal buildTree         # Recursive call
    jr $ra

insert:
    move $t0, $a1         # Store value in node
    sw $t0, 0($a0)        # Insert value
    li $v0, 9             # Allocate space for left and right children
    li $a0, 8             # 8 bytes (2 words)
    syscall
    sw $v0, 4($a0)        # Set left child
    li $v0, 9
    li $a0, 8
    syscall
    sw $v0, 8($a0)        # Set right child
    jr $ra

# Inorder traversal to print and subtract the average
inorderSubtractAndPrint:
    lw $t0, 4($a0)        # Left child
    beq $t0, $zero, print  # If null, print value
    jal inorderSubtractAndPrint

print:
    lw $t1, 0($a0)        # Load node value
    sub $t1, $t1, $t2     # Subtract average
    move $a0, $t1         # Print value
    li $v0, 1
    syscall

    la $a0, newline       # Print newline
    li $v0, 4
    syscall

    lw $t0, 8($a0)        # Right child
    beq $t0, $zero, return  # If null, return
    jal inorderSubtractAndPrint

return:
    jr $ra

main:
    la $a0, prompt        # Prompt for number of nodes
    li $v0, 4
    syscall

    li $v0, 5             # Read input
    syscall
    move $t0, $v0         # Store number of nodes

    li $t1, 0             # Initialize sum to 0
    li $t2, 0             # Node counter

loop:
    beq $t2, $t0, avgCalc  # If all nodes processed, calculate average

    la $a0, inputMsg      # Prompt for node value
    li $v0, 4
    syscall

    li $v0, 5             # Read input value
    syscall

    li $v0, 9             # Allocate space for node
    li $a0, 12            # Node size (3 words)
    syscall
    move $a1, $v0         # Store address of new node

    add $t1, $t1, $v0     # Add value to sum
    addi $t2, $t2, 1      # Increment node counter

    jal buildTree         # Insert node in tree
    j loop

avgCalc:
    div $t1, $t2          # Calculate average
    mflo $t2              # Store average in $t2

    jal inorderSubtractAndPrint  # Traverse and print modified values

    li $v0, 10            # Exit program
    syscall
