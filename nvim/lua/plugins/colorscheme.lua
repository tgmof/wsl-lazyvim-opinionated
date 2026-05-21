-- 1. Run the registry check globally at the top of the file
local handle = io.popen(
  'cmd.exe /c reg query "HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Themes\\Personalize" /v AppsUseLightTheme 2>/dev/null'
)

local is_dark = true -- Fallback default
if handle then
  local result = handle:read("*a")
  handle:close()
  if string.find(result, "0x1") then
    is_dark = false -- 0x1 is Light Mode
  end
end

-- 2. Return the dynamic configuration to LazyVim
return {
  {
    "LazyVim/LazyVim",
    opts = {
      -- Compute the colorscheme name dynamically based on Windows
      colorscheme = is_dark and "tokyonight-moon" or "tokyonight-day",
    },
  },
}
