--[[
    SPDX-FileCopyrightText: Lieven Hey <lieven.hey@kdab.com>
    
    SPDX-License-Identifier: MIT
]]
local config = {}

config.options = { authors = {}, licenses = {} }

function config.setup(options)
	options = options or {}

	config.options = vim.tbl_deep_extend("keep", options, config.options)

	return config.options
end

return config
