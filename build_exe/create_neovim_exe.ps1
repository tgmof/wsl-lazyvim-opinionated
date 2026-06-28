# 1. Define paths
$TargetDir = "C:\ProgramData\Neovim"
if (!(Test-Path $TargetDir)) { New-Item -ItemType Directory -Path $TargetDir -Force }

$ExePath = Join-Path $TargetDir "WSLNeovim.exe"
$IconPath = Join-Path $TargetDir "neovim.ico"
$SourceCodePath = Join-Path $TargetDir "WSLNeovimLauncher.cs"

# 2. Write the core engine in robust C#
$SourceCode = @'
using System;
using System.Diagnostics;

public class WSLNeovimLauncher {
    public static void Main(string[] args) {
        if (args.Length > 0) {
            string targetFile = args[0];
            
            // 1. Manually translate the Windows path to a WSL path
            string driveLetter = targetFile.Substring(0, 1).ToLower();
            string pathWithoutDrive = targetFile.Substring(3).Replace("\\", "/").Replace(" ", "\\ ");
            string linuxPath = string.Format("/mnt/{0}/{1}", driveLetter, pathWithoutDrive);
            
            // 2. Ensure the permanent helper script exists. 
            // We use ONE permanent helper script instead of cluttering the disk with temporary files.
            string helperScriptPath = @"C:\ProgramData\Neovim\launch_nvim.sh";
            if (!System.IO.File.Exists(helperScriptPath)) {
                string scriptContent = "#!/bin/bash\nexec /home/linuxbrew/.linuxbrew/bin/nvim \"$1\"\n";
                System.IO.File.WriteAllText(helperScriptPath, scriptContent);
            }
            
            // 3. Run Alacritty!
            ProcessStartInfo alacrittyInfo = new ProcessStartInfo {
                FileName = @"C:\Program Files\Alacritty\alacritty.exe",
                Arguments = string.Format("-e bash /mnt/c/ProgramData/Neovim/launch_nvim.sh \"{0}\"", linuxPath),
                UseShellExecute = false,
                CreateNoWindow = true
            };
            
            try {
                Process.Start(alacrittyInfo);
            } catch (Exception) { }
        }
    }
}
'@

Set-Content -Path $SourceCodePath -Value $SourceCode -Encoding UTF8

# 3. Locate the built-in C# Compiler (csc.exe) which exists on all Windows machines
$CscPath = "$env:windir\Microsoft.NET\Framework64\v4.0.30319\csc.exe"

if (!(Test-Path $CscPath)) {
    # Fallback to 32-bit if 64-bit isn't found
    $CscPath = "$env:windir\Microsoft.NET\Framework\v4.0.30319\csc.exe"
}

# 4. Compile the EXE
if (Test-Path $CscPath) {
    Write-Host "Compiling executable..." -ForegroundColor Cyan
    
    # We use /target:winexe so it runs completely in the background (no console flash)
    # We use /win32icon: to attach your custom Neovim icon natively
    $compileArgs = @(
        "/nologo",
        "/target:winexe",
        "/out:$ExePath"
    )
    
    if (Test-Path $IconPath) {
        $compileArgs += "/win32icon:$IconPath"
    } else {
        Write-Host "Icon not found at $IconPath, compiling without icon." -ForegroundColor Yellow
    }
    
    $compileArgs += $SourceCodePath

    # Execute the compiler
    & $CscPath $compileArgs
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "SUCCESS! Your native binary is ready at: $ExePath" -ForegroundColor Green
    } else {
        Write-Host "Compilation failed." -ForegroundColor Red
    }
} else {
    Write-Host "Could not find csc.exe compiler on this system." -ForegroundColor Red
}

# Cleanup the temporary C# source file
if (Test-Path $SourceCodePath) { Remove-Item $SourceCodePath }
