--[[
    SPDX-FileCopyrightText: Lieven Hey <lieven.hey@kdab.com>
    
    SPDX-License-Identifier: MIT
]]

local spdx = require("nvim-spdx.spdx")

local function prompt_author()
	vim.ui.input({ prompt = "License author: " }, function(input)
		local config = require("nvim-spdx.config")
		table.insert(config.options.authors, input)
	end)
end

local function prompt_license()
	vim.ui.input({ prompt = "License: " }, function(input)
		local config = require("nvim-spdx.config")
		table.insert(config.options.licenses, input)
	end)
end

local function has_spdx(buffer)
	for _, line in pairs(vim.api.nvim_buf_get_lines(buffer, 0, -1, true)) do
		if line:match("SPDX%-") ~= nil then
			return true
		end
	end

	return false
end

local comment_begin = { lua = "--[[", c = "/*", cpp = "/*", python = '"""' }
local comment_end = { lua = "]]", c = "*/", cpp = "*/", python = '"""' }

local function find_end_of_spdx(buffer)
	for linenr, line in pairs(vim.api.nvim_buf_get_lines(buffer, 0, -1, true)) do
		if string.find(line, comment_end[vim.bo.filetype]) ~= nil then
			return linenr
		end
	end
	return 0
end

local function add_spdx()
	local config = require("nvim-spdx.config")
	local authors = config.options.authors
	local licenses = config.options.licenses

	if has_spdx(0) then
		local last_line = find_end_of_spdx(0)
		authors, licenses = spdx.extract_existing_record(vim.api.nvim_buf_get_lines(0, 0, last_line, true))
		vim.api.nvim_buf_set_lines(0, 0, last_line, true, {})
		authors, licenses = spdx.update_spdx_record(authors, licenses, config.options.authors, config.options.licenses)
	end

	if #authors == 0 then
		prompt_author()
	end

	if #licenses == 0 then
		prompt_license()
	end
	print(vim.inspect(licenses))
	local text = { comment_begin[vim.bo.filetype] }

	local record = spdx.create_spdx_record(authors, licenses)

	for _, entry in pairs(record) do
		table.insert(text, "    " .. entry)
	end

	table.insert(text, comment_end[vim.bo.filetype])

	vim.api.nvim_buf_set_text(0, 0, 0, 0, 0, text)
end

return {
	add_spdx = add_spdx,
}
