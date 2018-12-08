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
  
  //requires env.constants.NumCommandLineArgs(env) as int == 2
  //requires 2  == |env.constants.CommandLineArgs()|;
  
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
  var source, sourceStream := FileStream.Open(sourceFile, env);
  if !source {
    print "SourceFile failed to open!\n";
    return;
  }

 // If the file doesn't exist, it creates one with no content
 var destination, destStream := FileStream.Open(destFile, env); 
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


  //Write(file_offset:nat32, buffer:array?<byte>, start:int32, num_bytes:int32) returns(ok:bool)
  //Read(file_offset:nat32, buffer:array?<byte>, start:int32, num_bytes:int32) returns(ok:bool)



  //var arg : array<char>;

  //var c : int := between( a, a+4 ) ;
  //var argc : uint32;
  //argc :=  env.constants.NumCommandLineArgs(env);

  //arg := env.constants.GetCommandLineArg( 2, env);

  //DestFile == new SourceFile;

  print "done!\n";
}