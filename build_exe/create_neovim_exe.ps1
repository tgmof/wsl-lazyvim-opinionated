# 1. Define paths
$TargetDir = "$env:ProgramData\Neovim"
if (!(Test-Path $TargetDir)) { New-Item -ItemType Directory -Path $TargetDir -Force }

$ExePath = Join-Path $TargetDir "WSLNeovim.exe"
$IconPath = Join-Path $TargetDir "build_exe\neovim.ico"
$SourceCodePath = Join-Path $TargetDir "build_exe\WSLNeovimLauncher.cs"

# 2. Locate the built-in C# Compiler (csc.exe) which exists on all Windows machines
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
