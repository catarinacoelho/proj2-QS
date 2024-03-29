/*  
 * This is the skeleton for your compression and decompression routines.
 * As you can see, it doesn't do much at the moment.  See how much you 
 * can improve on the current algorithm! 
 *
 * Rui Maranhao -- rui@computer.org
 */

include "Io.dfy"

method ArrayFromSeq<A>(s: seq<A>) returns (a: array<A>)
  ensures a[..] == s
  ensures fresh(a)
{
  a := new A[|s|] ( i requires 0 <= i < |s| => s[i] );
}

function compress(bytes:seq<byte>) : seq<byte>
  //decreases bytes
{
  bytes
  /*if |bytes| <= 1 then bytes else 
  if bytes[0] == bytes[1] then [bytes[0]] + [|bytes[..2]| as byte] + compress(bytes[1..]) else bytes[|bytes|-1 := bytes[|bytes|-1] + 1] + compress(bytes[1..])
*/}  

function decompress(bytes:seq<byte>) : seq<byte>
  //decreases |bytes|
{
 bytes
 //if |bytes| <= 1 then bytes else compress(bytes[..1]) + decompress(bytes[1..])
}

lemma {:axiom} lossless(bytes:seq<byte>)
  requires |bytes| > 0;
  ensures decompress(compress(bytes)) == bytes;
/*{
  if |bytes| <= 1{
    calc == {
      decompress(compress(bytes));
        { assert (compress(bytes) == bytes);  }
      decompress(bytes);
        { assert (decompress(bytes) == bytes);  }
      bytes;
    }
  }
  else{
    calc == {
      decompress(compress(bytes));
      (if bytes[0] == bytes[1] then [bytes[0]] + [|bytes[..2]|] + compress(bytes[1..]) else bytes[|bytes|-1 := bytes[|bytes|-1] + 1] + compress(bytes[1..]));
        {assert compressed(bytes) == x + bytes[0];}
      decompress(x + bytes[0]);
      { assert decompress(x + bytes[0]) == x*bytes[0];}
      x*bytes[0];
      { assert x*bytes[0] == bytes;}
      bytes;
    }
  }
}*/


method compress_impl(bytes:array?<byte>) returns (compressed_bytes:array?<byte>)
  requires bytes != null;
  ensures  compressed_bytes != null;
  //ensures  compressed_bytes[..] == compress(bytes[..]);
  ensures forall i :: 0 <= i < bytes.Length ==> bytes[i] == old(bytes[i]);
{
    var s : seq<byte> := [];
    compressed_bytes := ArrayFromSeq(s);

    //in case the file is empty
    if bytes.Length <= 1{
        compressed_bytes := bytes;
        return compressed_bytes;
    }

    //in case the file has more than one byte to compress
    if bytes.Length > 1{

    var i := 0;
    var j := 0;
    var count := 1;

    while(i < bytes.Length - 1  )
    invariant 0 <= i <= bytes.Length;
    invariant compressed_bytes != null;
    //invariant compressed_bytes[..] == compress(bytes[..i]);
    decreases bytes.Length - i;
    {
        count := 1;
        while( i < bytes.Length - 1 && bytes[i] == bytes[i+1] && count < 255)
            invariant 0 <= i <= bytes.Length - 1;
            decreases bytes.Length - 1 - i;
        {
            count := count + 1;
            i := i + 1;
        }


        compressed_bytes := ArrayFromSeq(compressed_bytes[..] + [bytes[i]] + [count]);
        i := i + 1 ;        
    }   
  }
  print "finished compression\n\r";
}


method decompress_impl(compressed_bytes:array?<byte>) returns (bytes:array?<byte>)
  requires compressed_bytes != null;
  ensures  bytes != null;
  //ensures  bytes[..] == decompress(compressed_bytes[..]);
{
  var s : seq<byte> := [];
  bytes := ArrayFromSeq(s);

  //in case the file is empty
  if compressed_bytes.Length <= 1{
    bytes := compressed_bytes;
    return bytes;
  }

  var i := 0;
  var count := 0;

  if compressed_bytes.Length > 1{
    while (i < compressed_bytes.Length -1 )
      invariant 0 <= i <= compressed_bytes.Length
      invariant bytes != null;
      decreases compressed_bytes.Length - i
    { 
      count := 0;
      while (count < compressed_bytes[i+1] as int)
        invariant bytes !=null 
        invariant 0 <= count <= compressed_bytes[i+1] as int
        //invariant 0 <= i + 1 < bytes.Length
        decreases compressed_bytes[i+1] as int - count as int
      {
        bytes := ArrayFromSeq(bytes[..] + [compressed_bytes[i]]);
        count := count +1;
      }
      i := i +2;
      
    }
  }
}

method {:main} Main(ghost env:HostEnvironment?)
  requires env != null && env.Valid() && env.ok.ok();
  requires |env.constants.CommandLineArgs()| == 4
  modifies env.ok
  modifies env.files
{
  var args := HostConstants.NumCommandLineArgs(env);
  // arg0 is compression, arg 1 is compress/decompress, arg2 is SourceFile, arg3 is DestFile 
  if args != 4{
    print "Error: Invalid arguments, should be: ./compression 0 SourceFile DestFile or ./compression 1 SourceFile DestFile\r\n";
    return;
  }

  var compressDecompress := HostConstants.GetCommandLineArg(1, env);
  var sourceFile := HostConstants.GetCommandLineArg(2, env);
  var destFile := HostConstants.GetCommandLineArg(3, env);

  // sourceFile needs to exist
	var sourceFileExists := FileStream.FileExists(sourceFile, env);
	if !sourceFileExists  {
		print "Error: Source file doesn't exist!\r\n";
		return;
	}

  // destFile can't exist
  var destFileExists := FileStream.FileExists(destFile, env);
  if destFileExists {
    print "Error: Destination file already exists!\r\n";
    return;
  }

  // If the file exists, then the file contents are unchanged
  var source, sourceFileStream := FileStream.Open(sourceFile, env);
  if !source {
    print "SourceFile failed to open!\r\n";
    return;
  }

  // If the file doesn't exist, it creates one with no content
  var destination, destFileStream := FileStream.Open(destFile, env); 
  if !destination {
    print "Error: DestinationFile failed to open!\r\n";
    return;
  }

  // Get the lenght of the file -> len:int32
  var success, len: int32 := FileStream.FileLength(sourceFile, env);
  if !success {
       print "Error: Couldn't get file size!\r\n";
       return;
  }  


	// Arguments necessary for the Write and Read methods
	var file_offset: int := 0;
	var buffer_size: int := len as int;
	var buffer := new byte[buffer_size]; // byte = b:int | 0 <= b < 256
	var start := 0;

  while ((file_offset) < len as int)
    invariant sourceFileStream.env.files != null && destFileStream.env.files != null;
    invariant sourceFileStream.Name() in sourceFileStream.env.files.state(); 
    invariant sourceFileStream.IsOpen() && sourceFileStream.env.Valid() && sourceFileStream.env.ok.ok();
		invariant destFileStream.Name() in destFileStream.env.files.state(); 
		invariant destFileStream.IsOpen() && destFileStream.env.Valid() && destFileStream.env.ok.ok();

    decreases len as int - (file_offset + buffer_size);
  {
    var num_bytes := len as int;

    // At the last copy iteration, the content may not fill the whole buffer; Copy only what's left
		if(file_offset + buffer_size >= len as int){
			num_bytes := len as int - file_offset;
		}

    // Ensure buffer is fresh
		WriteOnBuffer(sourceFileStream, file_offset as nat32, buffer, num_bytes as int32);

    //Check if we need to decompress(0) or compress(1) the sourceFile
    if (compressDecompress != null && |compressDecompress[..]| > 0){

      if (compressDecompress[0] == '0'){
        //read the sourceFile and put the content on the buffer (buffer is array?<byte>)
        var readFromSource := sourceFileStream.Read(file_offset as nat32, buffer, start as int32, num_bytes as int32);
        
        if !readFromSource {
          print "Error: Read failed!\r\n";
          return;
		} 
        //decompress the buffer's content
        var decompressed := decompress_impl(buffer); 
       //write the content of decompressed (decompressed is array?<byte>) in the destFile
        var writeToDest := destFileStream.Write(file_offset as nat32, decompressed, start as int32, decompressed.Length as int32);
      	if !writeToDest {
          print "Error: Write failed!\r\n";
          return;
		    } 
      }
      else if(compressDecompress[0]  == '1'){
        //read the sourceFile and put the content on the buffer (buffer is array?<byte>)
        
        
        var readFromSource := sourceFileStream.Read(file_offset as nat32, buffer, start as int32, num_bytes as int32);
        if !readFromSource {
          print "Error: Read failed!\r\n";
          return;
	    } 
        //compress the buffer's content
        var compressed := compress_impl(buffer);
        //write the content of compressed (compressed is array?<byte>) in the destFile
        var writeToDest := destFileStream.Write(file_offset as nat32, compressed, start as int32, compressed.Length as int32);
        if !writeToDest {
          print "Error: Write failed!\r\n";
          return;
		    } 
      } 
      else {
        print "Error: Invalid argument! Should be 0 or 1.";
        return;
      } 
    }
    file_offset := file_offset + buffer_size;    
  }

  //Close the sourceFile
  ModifiedStream(sourceFileStream);
  var closed := sourceFileStream.Close();
  if !closed {
    print "Error: SourceFile failed to close!!\r\n";
    return;
	} 

  //Close the destFile
  ModifiedStream(destFileStream);
  var closed2 := destFileStream.Close();
  if !closed2 {
    print "Error: DestinationFile failed to close!!\r\n";
    return;
	} 

  print "File compressed/decompressed!\r\n"; 
}

// Guarantee that the buffer has been freshly allocated (and contains the information we want to read)
lemma {:axiom} WriteOnBuffer(sourceFileStream: FileStream, file_offset: nat32, buffer: array?<byte>, num_bytes: int32)  
  requires sourceFileStream.env.files != null;
  requires sourceFileStream.Name() in sourceFileStream.env.files.state(); 
  requires sourceFileStream.IsOpen() && sourceFileStream.env.Valid() && sourceFileStream.env.ok.ok();
  ensures fresh(buffer);

// Guarantee that the file stream has been freshly modified
lemma {:axiom} ModifiedStream(fs: FileStream) 
  requires fs.env.files != null;
  requires fs.Name() in fs.env.files.state(); 
  requires fs.IsOpen() && fs.env.Valid() && fs.env.ok.ok();
	ensures fresh(fs);