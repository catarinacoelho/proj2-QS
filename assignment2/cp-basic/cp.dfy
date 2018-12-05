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

method {:main} Main(ghost env: HostEnvironment?)
  requires env != null && env.Valid() && env.ok.ok();
  modifies env.ok
  modifies env.files
{
  GetCommandLineArg(2, env);
  NumCommandLineArgs(env) == 2;

  arg[0] := SourceFile;
  arg[1] := DestFile;

  ensures fresh(DestFile);
  DestFile== new SourceFile;

  DestFile == old(SourceFile);


  print "done!\n";
}



 
 