/*  
 * Class to read user input in C#
 */

using System;
using System.Numerics;
using System.Diagnostics;
using System.Threading;
using System.Collections.Concurrent;
using System.Collections.Generic;
using FStream = System.IO.FileStream;

using System.IO;

namespace @__default {

    public partial class Utils
    {
        public static void WantOverride(out bool okay){
            okay = (Console.ReadLine().ToLower().Equals("yes"));
        } 

        public static void DeleteFile(char[] filename){
            if(File.Exists(new String(filename)))
            {
                File.Delete(new String(filename));
            }
        }
    }
}