/*
 * This is the skeleton for your cp utility.
 *
 * Rui Maranhao -- rui@computer.org
 */

include "Io.dfy"
include "UtilsDfy.dfy"

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
	requires |env.files.state()| > 0 //requires 1 file to exist
	requires |env.constants.CommandLineArgs()| == 3
	requires env.constants.CommandLineArgs()[1] in env.files.state()
	requires !(env.constants.CommandLineArgs()[2] in env.files.state())
	requires |env.files.state()[env.constants.CommandLineArgs()[1]] | > 0 
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
	// sourceFile needs to exist
	var sourceFileExists := FileStream.FileExists(sourceFile, env);
	if !sourceFileExists  {
		print "Error: Source file doesn't exist!\r\n";
		return;
	}

	var destFile := HostConstants.GetCommandLineArg(2, env);
	// if destFile exists, prompt user to cancel or overwrite it
	var destFileExists := FileStream.FileExists(destFile, env);
	if destFileExists {
		print "Destination file already exists! Do you want to overwrite it? yes/no? \r\n";	
		
        var wantOverride := Utils.WantOverride();

		if(!wantOverride){
			print "File copy ABORTED!\r\n";
			return;
		}
		Utils.DeleteFile(destFile);
	}

	// If the file exists, then the file contents are unchanged
	var source, sourceFileStream := FileStream.Open(sourceFile, env);
	if !source {
		print "Error: SourceFile failed to open!\r\n";
		return;
	}

    // If the file doesn't exist, it creates one with no content
    var destination, destFileStream := FileStream.Open(destFile, env); 
	if !destination {
        print "Error: DestinationFile failed to open!\r\n";
        return;
	}

    assert destFileStream.Name() in destFileStream.env.files.state(); 
	assert destFileStream.IsOpen() && destFileStream.env.ok.ok();

	// Get the lenght of the file -> len:int32
	var ok, len: int32 := FileStream.FileLength(sourceFile, env);
	if !ok {
		print "Error: Couldn't get file size!\r\n";
		return;
	}  

	// Arguments necessary for the Write and Read methods
	var file_offset: int := 0;
	var buffer_size: int := 256;
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
		var num_bytes := buffer_size;

        // At the last copy iteration, the content may not fill the whole buffer; Copy only what's left
		if(file_offset + buffer_size >= len as int){
			num_bytes := len as int - file_offset;
		}

        // Ensure buffer is fresh
		WriteOnBuffer(sourceFileStream, file_offset as nat32, buffer, num_bytes as int32);

		//Read(file_offset:nat32, buffer:array?<byte>, start:int32, num_bytes:int32) returns(ok:bool)
		var readFromSource := sourceFileStream.Read(file_offset as nat32, buffer, start as int32, num_bytes as int32);
		if !readFromSource {
			print "Error: Read failed!\r\n";
			return;
		}  

		//Write(file_offset:nat32, buffer:array?<byte>, start:int32, num_bytes:int32) returns(ok:bool)
		var writeToDest := destFileStream.Write(file_offset as nat32, buffer, start as int32, num_bytes as int32);
		if !writeToDest {
			print "Error: Write failed!\r\n";
			return;
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

	print "File copied with Success!\r\n";
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

