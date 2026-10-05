require("core.options")
require("core.keymaps")
require("core.snippets")
require("core.lazy")

-- WSL has no native clipboard tool, so route through the Windows one there.
-- Elsewhere Neovim detects wl-copy/xclip itself.
if vim.fn.has("wsl") == 1 then
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
end
