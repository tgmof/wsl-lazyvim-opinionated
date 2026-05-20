# wsl-lazyvim-opinionated

An opinionated setup for neovim/lazyvim noob that come from VSCode and wants to avoid figuring things out and be able to start using neovim/lazyvim "quickly" and "learn by doing" the details on the way.

It was successfully tested in Windows 11 with the default wsl (wsl --install) which installs Ubuntu 24.04LTS and names the wsl instance "Ubuntu".

The installation bash file installs Alacritty in Windows. This is less fancy than (for instance) WezTerm but this is on purpose: WezTerm would add yet another layer of complexity for neovim/lazyvim beginners and yet another set of keyboard shortcut to understand / learn, and Alacritty has the additional advantage of using GPU acceleration a lot and having a very low RAM footprint (order of 30MB against 300MB for WezTerm).

## Installation guide

Open a WSL terminal and run:

```bash
cd
git clone https://github.com/tgmof/wsl-lazyvim-opinionated.git
cd wsl-lazyvim-opinionated && ./neovim_for_wsl.sh
cd
rm -rf wsl-lazyvim-opinionated
nvim

```

Lean the following keybindings by heart for quick start: (note that "+" means that you end up with several keys pressed AT THE SAME TIME whereas the absence of "+" means "press, release and then continue with the next key". Ex: `<Ctrl>+c` (concurrent) is different from `<Ctrl>c` (sequential))

- Learn the basic vim keybindings on Google/YouTube/with LLMs (`hjkl` to navigate in a file, `i` to enter "insert mode", `<esc>` to return to "normal mode", `v` to enter "visual mode" and `y` to copy highlighted text, `dd` to delete a line, `diw` to delete a word... You can use <https://vim-adventures.com/> to build your muscle memory)
- Generally speaking, use `q` or `<esc>` to exit any pop-up (yes `q` not `:q`)
- Generally speaking, combinations like `<ctrl>+<some letter>` means "move your cursor somewhere" and `<shift>+<some letter>` means "update the buffer/screen where your cursor is"
- Generally speaking, as per the vim convention use a letter for an action and the same letter capitalized to do the contrary it (Ex: n to move to the next search pattern match and N for the previous one).

Run through:

- `<space>e` to open the explorer side window like in VSCode, so you can leave it on the left and navigate back and forth with `<Ctrl>+h` and `<Ctrl>+l`
- `<space><space>` to open a full-page pop-up editor that also shows preview the files for you
- `<enter>` to open a file (it's called a buffer, so technically you open a buffer and load the file into it)
- Open a second and third file/buffer using the same method
- Enter `i` to enter "insert mode" and make some edit and then `<ctrl>+s` to exit insert mode and save, like in VSCode
- Close a buffer/file via `<space>bd` (stands for buffer delete)
- Use `<shift>h` `<shift>l` to move between the buffers (which looks like moving between VSCode Tabs at the top of your screen)
- Use `<space>ft` to open a split that shows your terminal like in VScode, escape the "terminal mode" (similar to "insert mode" for files) via `<esc><esc>` and navigate back and forth between terminal and editor via `<Ctrl>+j` and `<Ctrl>+k`, then when your cursor is on the "terminal buffer" press `<space>bd` to close the terminal
- If you want a dedicated "buffer terminal" (like a VSCode Tab Terminal), press `<space>fn` followed by `:terminal`
- You can see the modified files in the `<space>e` editor or via the git interface that you can open via `<space>gd` (git diff) `<space>gg` (full git UI, navigate with `<tab>` between panes, scroll down/up a diff with `<shift>j` and `<shift>k` and read the commands at the bottom to stage/stash/commit,...
- Missing language support / linting can be easily added via `:Mason` (and follow the instructions/keybindings documented in that UI to search/install what you need)
- The learning curve of using vim/neovim/lazyvim was (despite its name) steep. At the age of AI, it has never been so easy so ask AI if you have any question! Like "In LazyVim, how to do xxx" mostly works! (when your question is simple, a simple googling + first open the first website also works well!)
