
Markdown: https://github.com/adam-p/markdown-here/wiki/Markdown-Here-Cheatsheet#h1


INFO: When you call a method, you "call" the specification (ensures), the body doesn't matter

## Question 1:
### Note that in the FileSystemState and the FileStream classes, all of the functions say they read this. Why is this important?

The body of a function needs to be a single expression

## Question 2:
### Note that it isn’t possible to create new FileSystemState objects. What would problems might arise if this were possible?

class FileSystemState
{
    constructor{ :axiom} () requires false;
    function {:axiom} state() : map<seq<char>,seq<byte>>   // File system maps file names (sequences of characters) to their contents
        reads this;
}



## Question 3:
### Semantically, what does it mean if you add preconditions (requires) to the Main method?
A precondition is a condition that a caller must stabilish before it is allowed to invoke a method. You can assume that condition inside the implementation of a method

For main to be able to call the other methods, it needs to be sure that it follows those methods pre conditions.

SOMETHING LIKE THIS????




## EXTRA: Challenge 2:
### Explain the algorithm and decisions


