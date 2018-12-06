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
  
  
  requires env.constants.NumCommandLineArgs(env) as int == 2
  
  requires 2  == |env.constants.CommandLineArgs()|;



  modifies env.ok
  modifies env.files
  
  //ensures fresh(DestFile);
{

  //var arg : array<char>;

  var argc : uint32;
  argc :=  env.constants.NumCommandLineArgs(env);



  var arg : array<char>;

  arg := env.constants.GetCommandLineArg( 2, env);

  //DestFile == new SourceFile;

  var name:array<char>;

  var test := FileStream.FileExists(name, env);


  print "done!\n";
}



 
 