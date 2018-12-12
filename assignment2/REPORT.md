# Question 1:
## Note that in the FileSystemState and the FileStream classes, all of the functions say they read this. Why is this important?
Those functions say "reads this", to be able to access and use information they did not receive as arguments or are stored in heap memory, this way they can access attributes inside it's class.

//porque é que temos de ter o read this lá, tem haver com frames. Se o que está no read não muda...

m.reads is used to denote the things that method m may read.

A reads clause specifies the set of memory locations that a function may read.  If "*" is given in a reads clause it means any memory may be read. This allows the function to read anything inside it's class.

Functions are not allowed to have side effects but may be restricted in what they can read. The reading frame of a function (or predicate) is all the memory locations that the function is allowed to read. The reason we might limit what a function can read is so that when we write to memory, we can be sure that functions that did not read that part of memory have the same value they did before. For example, we might have two arrays, one of which we know is sorted. If we did not put a reads annotation on the sorted predicate, then when we modify the unsorted array, we cannot determine whether the other array stopped being sorted. While we might be able to give invariants to preserve it in this case, it gets even more complex when manipulating data structures. In this case, framing is essential to making the verification process feasible.



# Question 2:
## Note that it isn’t possible to create new FileSystemState objects. What problems might arise if this were possible?
The FileSystemState maps file names to their content, so you can only map file names with the content of existing files, meaning that FileSystemState only applies to already existing files.

If you were able to create FileSystemState objects without assuring that it would regard a file, you could be creating a mapping for a file that doesn't exist and you would have names and contents without a file.


# Question 3:
## Semantically, what does it mean if you add preconditions (requires) to the Main method?
A precondition is a condition that a caller must stabilish before it is allowed to invoke a method. Without assuring that the preconditions of the methods that Main is calling are being assured, the program won't run, so you need to be sure that it follows those methods preconditions by adding those preconditions to the Main method.


# Challenge 2
## Explain the algorithm and decisions

The algorithm we chose was the Run Length Encoding (RLE) data compression algorithm which is a form of lossless data compression.

For example, if apply our algorithm to compress this: HHHHHHHHHHHFBRRRRRRRRRRRRVVVFWW

We get: H11F1B1V12F1W2


###Explanation of the algorithm (compress_impl and decompress_impl methods)

####Compress
Being _bytes_ what we need to compress and _compressed_bytes_ the compression, we start by checking if the lenght of _bytes_ is 0 or 1. If it is 0 or 1, it means it is empty or it only has one element and therefore, there is no need to apply the algorithm, so we say that the _compressed_bytes_ is equal to _bytes_ (identity function).

If the lenght of _bytes_ is bigger than 1, we do the following:

1. We initialize a counter to 1 

1. We compare the element i of _bytes_, starting in the first element of _bytes_ ([bytes[0]), with

 value of the first element of _bytes_ ([bytes[0]) and compare it to the value of the next position off "bytes" ([bytes[1]),

2. if the value is the same and we are not at the end of the data stream, we increment our count and . If it isn't the same, then we write the value of the count

Para na descompressão ser mais facil localizar os valores, colacamos os


References:
<https://www.fileformat.info/mirror/egff/ch09_03.htm>
<https://en.wikipedia.org/wiki/Run-length_encoding>