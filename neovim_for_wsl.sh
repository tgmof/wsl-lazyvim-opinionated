sudo apt-get install software-properties-common build-essential zip unzip jq -y
if command -v brew >/dev/null 2>&1; then
  echo "Homebrew is already in PATH; skipping install."
else
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  printf '\neval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"' >>~/.bashrc
fi
# Install tools required by basic LazyVim setup
brew install fd
brew install neovim
brew install lazygit
# Install node since many LSP rely on it
brew install fnm
fnm install 24
# Install Windows terminal tools and copy the local Alacritty config into AppData.
if command -v powershell.exe >/dev/null 2>&1; then
  powershell.exe -Command "winget install Alacritty.Alacritty"
  powershell.exe -Command "winget install win32yank"
  powershell.exe -NoProfile -ExecutionPolicy Bypass -Command '
    $fontZip = Join-Path $env:TEMP "FiraCode.zip"
    $fontSourceDir = Join-Path $env:TEMP "FiraCodeNerdFont"
    $fontInstallDir = Join-Path $env:LOCALAPPDATA "Microsoft\Windows\Fonts"
    $fontRegistryPath = "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Fonts"
    $fontFiles = @("FiraCodeNerdFont-Regular.ttf", "FiraCodeNerdFont-Bold.ttf", "FiraCodeNerdFont-Retina.ttf")

    Invoke-WebRequest -Uri "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/FiraCode.zip" -OutFile $fontZip
    Remove-Item -Recurse -Force $fontSourceDir -ErrorAction SilentlyContinue
    Expand-Archive -Path $fontZip -DestinationPath $fontSourceDir -Force
    New-Item -ItemType Directory -Force -Path $fontInstallDir | Out-Null

    foreach ($fontFile in $fontFiles) {
      $source = Join-Path $fontSourceDir $fontFile
      $target = Join-Path $fontInstallDir $fontFile
      if (Test-Path $source) {
        Copy-Item -Path $source -Destination $target -Force
        $fontName = "$([System.IO.Path]::GetFileNameWithoutExtension($fontFile)) (TrueType)"
        New-ItemProperty -Path $fontRegistryPath -Name $fontName -Value $fontFile -PropertyType String -Force | Out-Null
      }
    }

    $shell = New-Object -ComObject Shell.Application
    $fontFolder = $shell.Namespace(0x14) # 0x14 represents the Fonts special folder
    foreach ($fontFile in $fontFiles) {
      $target = Join-Path $fontInstallDir $fontFile
      if (Test-Path $target) {
        $fontFolder.CopyHere($target, 0x10) # 0x10 avoids displaying a progress dialog
      }
    }
  '
  appdata_path="$(wslpath "$(powershell.exe -Command "echo \$env:AppData" | tr -d '\r')")"
  mkdir -p "$appdata_path/alacritty"
  cp alacritty.toml "$appdata_path/alacritty/alacritty.toml"
else
  echo "powershell.exe is not available in PATH; skipping Windows Alacritty and win32yank setup."
fi
# Install win32yank so that you can sync your windows clipboad with your WSL clipboard
if [ -x /usr/local/bin/win32yank.exe ]; then
  echo "win32yank is already installed in /usr/local/bin; skipping install."
else
  case "$(uname -m)" in
  x86_64 | amd64)
    win32yank_url="https://github.com/equalsraf/win32yank/releases/download/v0.1.1/win32yank-x64.zip"
    ;;
  i386 | i686)
    win32yank_url="https://github.com/equalsraf/win32yank/releases/download/v0.1.1/win32yank-x86.zip"
    ;;
  *)
    echo "Unsupported architecture for win32yank: $(uname -m)"
    exit 1
    ;;
  esac
  curl -sLo /tmp/win32yank.zip "$win32yank_url"
  unzip -p /tmp/win32yank.zip win32yank.exe >/tmp/win32yank.exe
  chmod +x /tmp/win32yank.exe
  sudo mv /tmp/win32yank.exe /usr/local/bin/
fi
# Overwrite the LazyVim config with the opinionated setup for usage in WSL
if [ -d ~/.config/nvim ]; then
  zip -r neovim_backup_$(date +%s).zip ~/.config/nvim/
fi

rm -rf ~/.config/nvim
mkdir -p ~/.config
cp -r nvim/ ~/.config/nvim/

# Enable Windows interop when /etc/wsl.conf already exists and has no interop section.
if [ -f /etc/wsl.conf ] && ! grep -q '^\[interop\]$' /etc/wsl.conf; then
  printf '\n[interop]\nenabled=true\nappendWindowsPath=true\n' | sudo tee -a /etc/wsl.conf >/dev/null
else
  printf "Your /etc/wsl.conf already contains an [interop] section so we didn't update it. If this file doesn't contain this: \n[interop]\nenabled=true\nappendWindowsPath=true\n Please update it manually to allow windows program to run like win32yank or powershell"
fi

echo "When you feel ready, add export EDITOR='nvim' in your ~/.bashrc so that neovim becomes your default editor"
