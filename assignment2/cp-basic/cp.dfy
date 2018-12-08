/*
 * This is the skeleton for your cp utility.
 *
 * Rui Maranhao -- rui@computer.org
 */

include "Io.dfy"

// Useful to convert Dafny strings into arrays of characters.
method ArrayFromSeq<A>(s: seq<A>) returns (a: array<A>)
  ensures a[..] == s
{
  a := new A[|s|] ( i requires 0 <= i < |s| => s[i] );
}


// TO COMPILE  C:\dafny\Dafny.exe cp.dfy IoNative.cs

method {:main} Main(ghost env: HostEnvironment?)
  requires env != null && env.Valid() && env.ok.ok()
  modifies env.ok
  modifies env.files
 // modifies buffer

 // ensure the copy was done??
  
  //ensures fresh(DestFile);
{
  var args := HostConstants.NumCommandLineArgs(env);

  //  ./cp SourceFile DestFile

  var sourceFile := HostConstants.GetCommandLineArg(1, env);
  var destFile := HostConstants.GetCommandLineArg(2, env);

  // sourceFile needs to exist
  var sourceFileExists := FileStream.FileExists(sourceFile, env);
  if !sourceFileExists  {
    print "Source file doesn't exist!\n";
    return;
  }

  // destFile can't exist
  var destFileExists := FileStream.FileExists(destFile, env);
  if destFileExists {
    print "Destination file already exists!\n";
    return;
  }

  // If the file exists, then the file contents are unchanged
  var source, sourceFileStream := FileStream.Open(sourceFile, env);
  if !source {
    print "SourceFile failed to open!\n";
    return;
  }

 // If the file doesn't exist, it creates one with no content
 var destination, destFileStream := FileStream.Open(destFile, env); 
  if !destination {
   print "DestinationFile failed to open!\n";
   return;
  }

  // Get the lenght of the file -> len:int32
  var success, len: int32 := FileStream.FileLength(sourceFile, env);
  if !success {
       print "Couldn't get file size!\n";
       return;
  }  

  // Arguments necessary for the Write and Read methods
  var file_offset: int := 0;
  var num_bytes: int := 256;
  var buffer := new byte[num_bytes]; // byte = b:int | 0 <= b < 256
  var start := 0;
  
  var readFromSource, writeToDest := true, true;

  while ((file_offset + num_bytes) < len as int)
    invariant sourceFileStream.Name() in sourceFileStream.env.files.state(); // && sourceFileStream.env.files.state() != null;
    invariant sourceFileStream.IsOpen() && sourceFileStream.env.Valid() && sourceFileStream.env.ok.ok();
    decreases len as int - (file_offset + num_bytes);
  {
    //Read(file_offset:nat32, buffer:array?<byte>, start:int32, num_bytes:int32) returns(ok:bool)
    readFromSource := sourceFileStream.Read(file_offset as nat32, buffer, start as int32, num_bytes as int32);
    //Write(file_offset:nat32, buffer:array?<byte>, start:int32, num_bytes:int32) returns(ok:bool)
    writeToDest := destFileStream.Write(file_offset as nat32, buffer, start as int32, num_bytes as int32);

    //Fazer a verificação se deu true??

    //xxxxxxxLemma(xxxxxxxx);
    file_offset := file_offset + num_bytes;    
  }

  //DestFile == new SourceFile;

  print "done!\n";
}


//What do we need to verify? The READ and the WRITE?
/*
lemma xxxxxxxLemma(xxxxxxxx)
  requires env != null && env.Valid() && env.ok.ok();
  ensures xxxxxx;
  decreases xxxxx;
{
  assume false;
}
*/


