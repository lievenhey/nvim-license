--[[
    SPDX-FileCopyrightText: Lieven Hey <lieven.hey@kdab.com>
    
    SPDX-License-Identifier: MIT
]]

local M = require("nvim-spdx.main")

local spdx = {}

function spdx.spdx()
	if _G.spdx.config == nil then
		_G.spdx.config = require("nvim-spdx.config").options
	end

	M.add_spdx()
end

function spdx.setup(opts)
	_G.spdx.config = require("nvim-spdx.config").setup(opts)
end

_G.spdx = spdx

return _G.spdx
