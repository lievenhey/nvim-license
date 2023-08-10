--[[
    SPDX-FileCopyrightText: Lieven Hey <lieven.hey@kdab.com>
    
    SPDX-License-Identifier: MIT
]]

local function year()
	return os.date("%Y")
end

local function format_author(author)
	return string.gsub(author, "@YYYY@", year())
end

local function extract_existing_record(lines)
	local authors = {}
	local licenses = {}

	for _, line in pairs(lines) do
		local author = string.match(line, "SPDX%-FileCopyrightText: (.+)$")
		local license = string.match(line, "SPDX%-License%-Identifier: (.+)$")

		if author ~= nil then
			table.insert(authors, author)
		elseif license ~= nil then
			table.insert(licenses, license)
		end
	end
	return authors, licenses
end

local function create_spdx_record(authors, licenses)
	local record = {}

	for _, author in pairs(authors) do
		table.insert(record, string.format("SPDX-FileCopyrightText: %s", format_author(author)))
	end

	table.insert(record, "")

	for _, license in pairs(licenses) do
		table.insert(record, string.format("SPDX-License-Identifier: %s", license))
	end

	return record
end

local function list_contains(list, item)
	for index, entry in pairs(list) do
		if entry == item then
			return index
		end
	end
	return -1
end

local function update_spdx_record(old_authors, old_licenses, new_authors, new_licenses)
	local authors = {}
	local licenses = {}

	for _, author in pairs(old_authors) do
		local author_year = string.match(author, "^(%d%d%d%d) ")
		if author_year ~= nil then
			local author_index = list_contains(new_authors, author:gsub("%d%d%d%d", "@YYYY@"))
			if author_index ~= -1 then
				if author_year ~= tostring(year()) then
					author = author:gsub("%d%d%d%d", author_year .. "-" .. tostring(year()))
					table.remove(new_authors, author_index)
				end
			end
		end
		local start_year, end_year = string.match(author, "^(%d%d%d%d)-(%d%d%d%d) ")
		if start_year ~= nil then
			if end_year ~= tostring(year()) then
				author = author:gsub("%-%d%d%d%d", "-" .. tostring(year()))
				local author_pattern = author:gsub("%d%d%d%d%-%d%d%d%d", "@YYYY@")
				local author_index = list_contains(new_authors, author_pattern)
				if author_index ~= -1 then
					table.remove(new_authors, author_index)
				end
			end
		end
		table.insert(authors, author)
	end

	for _, author in pairs(new_authors) do
		if not author:find("@YYYY@") then
			if list_contains(authors, author) == -1 then
				table.insert(authors, author)
			end
		else
			author = author:gsub("@YYYY@", tostring(year()))
			if list_contains(authors, author) == -1 then
				table.insert(authors, author)
			end
		end
	end
	for _, license in pairs(old_licenses) do
		table.insert(licenses, license)
	end

	for _, license in pairs(new_licenses) do
		if list_contains(licenses, license) == -1 then
			table.insert(licenses, license)
		end
	end
	return authors, licenses
end

return {
	create_spdx_record = create_spdx_record,
	extract_existing_record = extract_existing_record,
	update_spdx_record = update_spdx_record,
}
