# Sorting-Recursively-in-Assembly
A program written in NASM x86 assembly to recursively sort a stack of discs.

The program takes in one command line argument, from 2-9 which is the number of discs. It then randomly generates an order for the discs.

An example can be seen below:

    ./sorthem 4  
    Command line arguments are good, you entered: 4  
      
    The initial configuration is:  
           
       oooo|oooo
          o|o
        ooo|ooo
         oo|oo
    XXXXXXXXXXXXXXX
    
Every time "enter" is pressed, the program goes through one iteration of sorting

          o|o
       oooo|oooo
        ooo|ooo
         oo|oo
    XXXXXXXXXXXXXXX  
    
          o|o
        ooo|ooo
       oooo|oooo
         oo|oo
    XXXXXXXXXXXXXXX  
    
    The final sorted configuration is:  
    
          o|o
         oo|oo
        ooo|ooo
       oooo|oooo
    XXXXXXXXXXXXXXX 

## What I learned!
Through this project, not only did I learn how about assembly, but I also grew in my skill of debugging code as there are very few error messages and debuggers available for assembly. I also learned how computers work at the lowest level, specifically how they deal with memory in the form of the stack, heap, stack and base pointers, and more.
