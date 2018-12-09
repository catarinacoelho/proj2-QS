
using System.IO;
using System.IO.Compression;

public static byte[] Zip(byte[] sourceFileBytes) {
    byte[] buffer;
    using(sourceFileBytes){
        buffer = new byte[bsourceFileBytes.Length];
        sourceFileBytes.Read(buffer, 0, (int)sourceFileBytes.Length);
    } 
    using(var compressedFile = new GZipStream(sourceFileBytes, CompressionMode.Compress)){
        compressedFile.Write(buffer, 0, buffer.Length);
    }

    return compressedFile.ToArray();
}
  
/* 
public static string Unzip(byte[] bytes) {
    using (var msi = new MemoryStream(bytes))
    using (var mso = new MemoryStream()) {
        using (var gs = new GZipStream(msi, CompressionMode.Decompress)) {
            //gs.CopyTo(mso);
            CopyTo(gs, mso);
        }

        return Encoding.UTF8.GetString(mso.ToArray());
    }
}
*/