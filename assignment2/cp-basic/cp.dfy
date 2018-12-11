/*
 * This is the skeleton for your cp utility.
 *
 * Rui Maranhao -- rui@computer.org
 */

include "Io.dfy"

// Useful to convert Dafny strings into arrays of characters.
method ArrayFromSeq<A>(s: seq<A>) returns (a: array<A>)
  ensures a[..] == s
  ensures fresh(a)
{
  a := new A[|s|] ( i requires 0 <= i < |s| => s[i] );
}


// TO COMPILE  C:\dafny\Dafny.exe cp.dfy IoNative.cs

method {:main} Main(ghost env: HostEnvironment?)
  requires env != null && env.Valid() && env.ok.ok()
  requires |env.constants.CommandLineArgs()| == 3
  modifies env.ok
  modifies env.files
{
  var args := HostConstants.NumCommandLineArgs(env);
  // arg0 is cp, arg 1 is SourceFile, arg2 is DestFile 
  if args != 3{
    print "Invalid arguments, should be: ./cp SourceFile DestFile\r\n";
    return;
  }

  var sourceFile := HostConstants.GetCommandLineArg(1, env);
  var destFile := HostConstants.GetCommandLineArg(2, env);

  // sourceFile needs to exist
  var sourceFileExists := FileStream.FileExists(sourceFile, env);
  if !sourceFileExists  {
    print "Source file doesn't exist!\r\n";
    return;
  }

  // destFile can't exist
  var destFileExists := FileStream.FileExists(destFile, env);
  if destFileExists {
    print "Destination file already exists!\r\n";
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
   print "DestinationFile failed to open!\r\n";
   return;
  }

  // Get the lenght of the file -> len:int32
  var success, len: int32 := FileStream.FileLength(sourceFile, env);
  if !success {
       print "Couldn't get file size!\r\n";
       return;
  }  

  // Arguments necessary for the Write and Read methods
  var file_offset: int := 0;
  var num_bytes: int := 256;
  var buffer := new byte[num_bytes]; // byte = b:int | 0 <= b < 256
  var start := 0;
  
  var readFromSource, writeToDest := true, true;

  while ((file_offset + num_bytes) < len as int)
    invariant sourceFileStream.env.files != null;
    invariant sourceFileStream.Name() in sourceFileStream.env.files.state(); 
    invariant sourceFileStream.IsOpen() && sourceFileStream.env.Valid() && sourceFileStream.env.ok.ok();
    decreases len as int - (file_offset + num_bytes);
  {

    writeOnBuffer(sourceFileStream, file_offset as nat32, buffer, num_bytes as int32);

    //Read(file_offset:nat32, buffer:array?<byte>, start:int32, num_bytes:int32) returns(ok:bool)
    readFromSource := sourceFileStream.Read(file_offset as nat32, buffer, start as int32, num_bytes as int32);
    if !readFromSource {
      print "Read failed!\r\n";
      return;
    }  
    //Write(file_offset:nat32, buffer:array?<byte>, start:int32, num_bytes:int32) returns(ok:bool)
    writeToDest := destFileStream.Write(file_offset as nat32, buffer, start as int32, num_bytes as int32);
    if !writeToDest {
      print "Write failed!\r\n";
      return;
    } 

    file_offset := file_offset + num_bytes;  
  }

  print "File copied!\r\n";
}


// Guarantee that the buffer has been freshly allocated (and contains the information we want to read)
lemma {:axiom} writeOnBuffer(sourceFileStream: FileStream, file_offset: nat32, buffer: array?<byte>, num_bytes: int32)  
  requires sourceFileStream.env.files != null;
  requires sourceFileStream.Name() in sourceFileStream.env.files.state(); 
  requires sourceFileStream.IsOpen() && sourceFileStream.env.Valid() && sourceFileStream.env.ok.ok();

  ensures fresh(buffer);




