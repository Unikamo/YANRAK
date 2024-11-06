# Boot/Kernel documentation
*Be free to use anything written in here, I don't really care*
*A lot of things that are here will probably come from Linux/FreeBSD/OpenBSD's kernel

## Memory 

### Layout

         | Protected-mode kernel  |
100000   +------------------------+
         | I/O memory hole        |
0A0000   +------------------------+
         | Reserved for BIOS      | Leave as much as possible unused
         ~                        ~
         | Command line           | (Can also be below the X+10000 mark)
X+10000  +------------------------+
         | Stack/heap             | For use by the kernel real-mode code.
X+08000  +------------------------+
         | Kernel setup           | The kernel real-mode code.
         | Kernel boot sector     | The kernel legacy boot sector.
       X +------------------------+
         | Boot loader            | <- Boot sector entry point 0x7C00
001000   +------------------------+
         | Reserved for MBR/BIOS  |
000800   +------------------------+
         | Typically used by MBR  |
000600   +------------------------+
         | BIOS use only          |
000000   +------------------------+

### Stack + Heap

#### Stack

**Size**: 8MB on Linux; 1MB on Windows
**Management**: By the CPU, automatically
**Speed**: Fast, because it moves the Stack Pointer
**Span**: Only available within the scope its defined
**Security Issues**: Stack Overflow if too much stack memory is used, Buffer overflow if volume of stored data is greater than the buffer/if allocated data is smaller than stored data
**Usage**: Static Memory Allocation, temporary variables, function parameters, return addresses
**Access**: Fast due to LFIO nature
**Safety**: Safer, avoirs pointer-related errors and memory leaks


#### Heap

**Size**: No Limit/Max memory that OS provides
**Management**: Manually, using malloc()
**Speed**: Slower
**Span**: Globally available
**Security Issues**: Heap Overflow if too large inputs
**Usage**: Return data that outlives the function that creates it, store unknown quantity of memory 
    *Example*: "local" vs "global" in lua, where "local" is the Stack, "global" is the heap
**Access**: Slower
**Safety**: Not as safe as stack

## Booting from Hard Disk


