sudo apt-get install software-properties-common build-essential zip unzip jq -y
if command -v brew >/dev/null 2>&1; then
  echo "Homebrew is already in PATH; skipping install."
else
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo >>~/.bashrc
  echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"' >>~/.bashrc
fi
# Install tools required by basic LazyVim setup
brew install fd
brew install neovim
brew install lazygit
# Install node since many LSP rely on it
brew install fnm
fnm install 24
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
