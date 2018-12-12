# Question 1:
## Note that in the FileSystemState and the FileStream classes, all of the functions say they read this. Why is this important?
A _reads_ clause specifies the set of memory locations that a function may read. _reads this_ allows the function to read anything inside it's class.

The reason we might limit what a function can read is so that when we write to memory, we can be sure that functions that did not read that part of memory have the same value they did before. This is important because the _reading frame_ might be essential to make the verification process feasible.


# Question 2:
## Note that it isn’t possible to create new FileSystemState objects. What problems might arise if this were possible?
The FileSystemState maps file names to their content, so you can only map file names with the content of existing files, meaning that FileSystemState only applies to already existing files.

If you were able to create FileSystemState objects without assuring that it would regard a file, you could be creating a mapping for a file that doesn't exist and you would have names and contents without a file.


# Question 3:
## Semantically, what does it mean if you add preconditions (requires) to the Main method?
A precondition is a condition that a caller must stabilish before it is allowed to invoke a method. Without assuring that the preconditions of the methods that Main is calling are being assured, the program won't run, so you need to be sure that it follows those methods preconditions by adding those preconditions to the Main method.


# Challenge 2
## Explain the algorithm and decisions

The algorithm we chose was the Run Length Encoding (RLE) data compression algorithm because it is a simple form of lossless data compression.

It works the following way:
- If we apply our algorithm to compress "HHHHHHHHHHHFBRRRRRRRRRRRRVVVFWW"
- We get "H11F1B1V12F1W2"

###Explanation of the algorithm (compress_impl and decompress_impl methods)

####Compress
Being _bytes_ what we need to compress and _compressed_bytes_ the compression, we start by checking if the lenght of _bytes_ is 0 or 1. If it is 0 or 1, it means it is empty or it only has one element and therefore, there is no need to apply the algorithm, so we say that the _compressed_bytes_ is equal to _bytes_ (identity function).

If the lenght of _bytes_ is bigger than 1, we do the following:

1. We initialize a counter to 1 

1. We compare the element i of _bytes_, starting in the first element of _bytes_ ([bytes[0]), with

 value of the first element of _bytes_ ([bytes[0]) and compare it to the value of the next position off "bytes" ([bytes[1]),

2. if the value is the same and we are not at the end of the data stream, we increment our count and . If it isn't the same, then we write the value of the count

Para na descompressão ser mais facil localizar os valores, colacamos os

####Decompress



References:
<https://www.fileformat.info/mirror/egff/ch09_03.htm>
<https://en.wikipedia.org/wiki/Run-length_encoding>