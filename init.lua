require("core.options")
require("core.keymaps")
require("core.snippets")
require("core.lazy")

vim.g.clipboard = {
  name = "WslClipboard",
  copy = {
    ["+"] = "clip.exe",
    ["*"] = "clip.exe",
  },
  paste = {
    ["+"] = 'powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).ToString().Replace("`r", ""))',
    ["*"] = 'powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).ToString().Replace("`r", ""))',
  },
  cache_enabled = 0,
}

vim.opt.clipboard = "unnamedplus"
