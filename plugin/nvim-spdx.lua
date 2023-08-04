--[[
    SPDX-FileCopyrightText: Lieven Hey <lieven.hey@kdab.com>
    
    SPDX-License-Identifier: MIT
]]

if _G.NvimSpdxLoaded then
	return
end
_G.NvimSpdxLoaded = true

vim.api.nvim_create_user_command("Spdx", function()
	require("nvim-spdx").spdx()
end, {})
