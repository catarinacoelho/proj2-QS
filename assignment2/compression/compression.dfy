/*  
 * This is the skeleton for your compression and decompression routines.
 * As you can see, it doesn't do much at the moment.  See how much you 
 * can improve on the current algorithm! 
 *
 * Rui Maranhao -- rui@computer.org
 */

include "Io.dfy"

function compress(bytes:seq<byte>) : seq<byte>
{
bytes
}

function decompress(bytes:seq<byte>) : seq<byte>
{
bytes
}

lemma lossless(bytes:seq<byte>)
  ensures decompress(compress(bytes)) == bytes;
{
}

method compress_impl(bytes:array?<byte>) returns (compressed_bytes:array?<byte>)
  requires bytes != null;
  ensures  compressed_bytes != null;
  ensures  compressed_bytes[..] == compress(bytes[..]);
  ensures |compressed_bytes[..]| < |bytes[..]|
{
  compressed_bytes := bytes;
}

method decompress_impl(compressed_bytes:array?<byte>) returns (bytes:array?<byte>)
  requires compressed_bytes != null;
  ensures  bytes != null;
  ensures  bytes[..] == decompress(compressed_bytes[..]);
  ensures |bytes[..]| > |compressed_bytes[..]|
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
  var source, sourceFileStream := FileStream.Open(sourceFile, env);
  if !source {
    print "SourceFile failed to open!\r\n";
    return;
  }

  if (compressDecompress != null && compressDecompress[0] == '0'){
  }
  else if(compressDecompress != null && compressDecompress[0]  == '1'){
     compress_impl(sourceFileStream); 
  } 
  else {
    print "Invalid argument! Should be 0 or 1.";
    return;
  } 

  print "Compress me!\n";  
}