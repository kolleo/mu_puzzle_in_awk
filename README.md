# An awk script for the MU puzzle
## Introduction
This is a tiny 'playground project' to teach myself some basics of ***awk***.
I take the ***MIU system*** as the field of application.
My script generates a random *derivation chain* in this 'system'.

## awk
Awk is a well-known Unix/Linux command line utility, and a real programming language too. 
It was actually invented for processing/filtering line oriented text files.
See [AWK](https://en.wikipedia.org/wiki/AWK) for more information.

## The MIU system, and the MU puzzle
The MIU system ist an example of a simple ***formal system*** with a few *derivation rules*.
The ***MU puzzle*** relates to the question:  
When you start with the *word* "MI" - Is the word "MU" derivable from it?  
See [MU puzzle](https://en.wikipedia.org/wiki/MU_puzzle) for more information.

## How to run the awk script
> I assume you have the gawk implementation of awk!

In a **bash shell** enter

    awk -f mu-puzzle.awk  

> HINT! If it seems that you get the same deviation chain over and over again. Don't bother! Run the script somes more times! You'll eventually obtain a different 'derivation pattern'.

Enter `awk -f mu-puzzle.awk help` to get some help.

Have fun!  
*-- Oliver Kolle*
