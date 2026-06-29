using System;
using System.IO;
using System.Diagnostics;

public class WSLNeovimLauncher {
    public static void Main(string[] args) {
        if (args.Length > 0) {
            string targetFile = args[0];

            // 1. Ensure the permanent helper script exists.
            string helperScriptPath = System.IO.Path.Combine(Environment.GetEnvironmentVariable("ProgramData"), "Neovim", "launch_nvim.sh");
            if (!System.IO.File.Exists(helperScriptPath)) {
                System.Windows.Forms.MessageBox.Show(string.Format( "Missing bash file: {0}", helperScriptPath ));
            }

            // 2. Run Alacritty!
            ProcessStartInfo alacrittyInfo = new ProcessStartInfo {
                FileName = @"C:\Program Files\Alacritty\alacritty.exe",
                Arguments = string.Format("-e wsl bash /mnt/c/ProgramData/Neovim/launch_nvim.sh '{0}'", targetFile.Replace("\\", "/")),
                UseShellExecute = false,
                CreateNoWindow = true
            };

            try {
                Process.Start(alacrittyInfo);
            } catch (Exception) { }
        }
    }
}
