## Question 1:
### Note that in the FileSystemState and the FileStream classes, all of the functions say they read this. Why is this important?

Those functions say "reads this", to be able to access and use information they did not receive as arguments or are stored in heap memory, this way they can access attributes inside it's class.


## Question 2:
### Note that it isn’t possible to create new FileSystemState objects. What problems might arise if this were possible?

The FileSystemState maps file names to their content, so you can only map file names with the content of existing files, meaning that FileSystemState only applies to already existing files.

If you were able to create FileSystemState objects without assuring that it would regard a file, you could be creating a mapping for a file that doesn't exist and you would have names and contents without a file.


## Question 3:
### Semantically, what does it mean if you add preconditions (requires) to the Main method?
A precondition is a condition that a caller must stabilish before it is allowed to invoke a method. Without assuring that the preconditions of the methods that Main is calling are being assured, the program won't run, so you need to be sure that it follows those methods preconditions by adding those preconditions to the Main method.


## EXTRA: Challenge 2
### Explain the algorithm and decisions


