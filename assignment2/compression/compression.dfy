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
  //decreases |bytes|
{
  bytes
  //if |bytes| == 0 then bytes else [bytes[0]][..] + compress(bytes[1..])
}  

function decompress(bytes:seq<byte>) : seq<byte>
  //decreases |bytes|
{
 bytes
 //if |bytes| == 0 then bytes else compress(bytes[..1]) + decompress(bytes[1..])
}

lemma {:induction bytes}lossless(bytes:seq<byte>)
  ensures decompress(compress(bytes)) == bytes;
{
}

method compress_impl(bytes:array?<byte>) returns (compressed_bytes:array?<byte>)
  requires bytes != null;
  ensures  compressed_bytes != null;
  ensures  compressed_bytes[..] == compress(bytes[..]);
  ensures |compressed_bytes[..]| <= |bytes[..]|;
  ensures forall i :: 0 <= i < bytes.Length ==> bytes[i] == old(bytes[i]);
{
  var compressed : seq<byte>;
  compressed_bytes := ArrayFromSeq(compressed);

  //in case the file is empty
  if bytes.Length == 0{
    compressed_bytes := bytes;
    //return compressed_bytes;
  }
  
  //in case the file has only one byte to compress
  if bytes.Length == 1{
    compressed_bytes := ArrayFromSeq(bytes[..]); //adicionar o  + [1] esta a fazer com que uma condiçao might not hold
    //return compressed_bytes; //condiçao pode nao hold pq compress nao ta implementado
  }

  //in case the file has more than one byte to compress
  if bytes.Length > 1{

    var i := 0;
    var j := 0;
    var count := 1;
    var pos := 0;

    while(i < bytes.Length)
      invariant 0 <= i <= bytes.Length;
      decreases bytes.Length - i;
      {
        count := 1;
        j := i;
        while(j < bytes.Length - 1 && bytes[j]==bytes[j+1])
          invariant 0 <= j <= bytes.Length - 1;
          decreases bytes.Length - 1 - j;
          {
            count := count + 1;
            j := j + 1;
          }
        compressed_bytes := ArrayFromSeq(compressed_bytes[..] + [bytes[i]][..] + [count as byte]);
        i := i +1;
        
      }   
  }
}


method decompress_impl(compressed_bytes:array?<byte>) returns (bytes:array?<byte>)
  requires compressed_bytes != null;
  ensures  bytes != null;
  ensures  bytes[..] == decompress(compressed_bytes[..]);
  ensures |bytes[..]| >= |compressed_bytes[..]|
{
  bytes := compressed_bytes;
}

method {:main} Main(ghost env:HostEnvironment?)
  requires env != null && env.Valid() && env.ok.ok();
  requires |env.constants.CommandLineArgs()| == 4
{
  var args := HostConstants.NumCommandLineArgs(env);
  // arg0 is compression, arg 1 is compress/decompress, arg2 is SourceFile, arg3 is DestFile 
  if args != 4{
    print "Invalid arguments, should be: ./compression 0 SourceFile DestFile or ./compression 1 SourceFile DestFile\r\n";
    return;
  }

  var compressDecompress := HostConstants.GetCommandLineArg(1, env);
  var sourceFile := HostConstants.GetCommandLineArg(2, env);
  var destFile := HostConstants.GetCommandLineArg(3, env);

   // If the file exists, then the file contents are unchanged
  /*var source, sourceFileStream := FileStream.Open(sourceFile, env);
  if !source {
    print "SourceFile failed to open!\r\n";
    return;
  }*/
/*
  if (compressDecompress != null && compressDecompress[0] == '0'){
  }
  else if(compressDecompress != null && compressDecompress[0]  == '1'){
     //compress_impl(sourceFileStream); 
  } 
  else {
    print "Invalid argument! Should be 0 or 1.";
    return;
  } */

  print "Compress me!\n";  
}