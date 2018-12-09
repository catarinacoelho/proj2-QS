
Markdown: https://github.com/adam-p/markdown-here/wiki/Markdown-Here-Cheatsheet#h1


INFO: When you call a method, you "call" the specification (ensures), the body doesn't matter

## Question 1:
### Note that in the FileSystemState and the FileStream classes, all of the functions say they read this. Why is this important?

For us to be able to reach things we did not receive as arguments with need to say reads this, and this way, those functions are able to access anduse information they didn't receive as arguments.

## Question 2:
### Note that it isn’t possible to create new FileSystemState objects. What problems might arise if this were possible?

What the FileSystemState does is map file names (sequences of characters) to their content, so you can only map file names and the content of existing files, meaning that FileSystemState only applies to already existing files.

Since it makes

, n faz sentido mapearmos um ficheiro que n existe


## Question 3:
### Semantically, what does it mean if you add preconditions (requires) to the Main method?
A precondition is a condition that a caller must stabilish before it is allowed to invoke a method. You can assume that condition inside the implementation of a method

For main to be able to call the other methods, it needs to be sure that it follows those methods pre conditions.


oprograma n corre sem que as pre condições sejam verificadas
SOMETHING LIKE THIS????




## EXTRA: Challenge 2:
### Explain the algorithm and decisions


