--[[
    SPDX-FileCopyrightText: Lieven Hey <lieven.hey@kdab.com>
    
    SPDX-License-Identifier: MIT
]]

local spdx = require("lua.nvim-spdx.spdx")

local luaunit = require("luaunit")

TestSPDX = {}

function TestSPDX:testCreateRecord()
	local authors = { "Author 1 <author@dev>", "@YYYY@ Dev Inc" }
	local licenses = { "GPL-2.0-or-later", "APACHE-2.0" }

	local record = spdx.create_spdx_record(authors, licenses)

	luaunit.assertEquals(record, {
		"SPDX-FileCopyrightText: Author 1 <author@dev>",
		"SPDX-FileCopyrightText: 2023 Dev Inc",
		"",
		"SPDX-License-Identifier: GPL-2.0-or-later",
		"SPDX-License-Identifier: APACHE-2.0",
	})
end

function TestSPDX:testExtractRecord()
	local lines = {
		"SPDX-FileCopyrightText: Author 1 <author@dev>",
		"SPDX-FileCopyrightText: 2022 Dev Inc",
		"",
		"SPDX-License-Identifier: GPL-2.0-or-later",
		"SPDX-License-Identifier: APACHE-2.0",
	}

	local authors, licenses = spdx.extract_existing_record(lines)

	luaunit.assertEquals(authors, { "Author 1 <author@dev>", "2022 Dev Inc" })
	luaunit.assertEquals(licenses, { "GPL-2.0-or-later", "APACHE-2.0" })
end

function TestSPDX:testUpdateNoYear()
	local authors, licenses = spdx.update_spdx_record(
		{ "Author 1" },
		{ "GPL-2.0-or-later" },
		{ "Author 1", "Author 2" },
		{ "GPL-2.0-or-later" }
	)

	luaunit.assertEquals(authors, { "Author 1", "Author 2" })
	luaunit.assertEquals(licenses, { "GPL-2.0-or-later" })
end

function TestSPDX:testUpdateNoYear2()
	local authors, licenses = spdx.update_spdx_record(
		{ "Author 1" },
		{ "GPL-2.0-or-later" },
		{ "Author 1" },
		{ "GPL-2.0-or-later", "MIT" }
	)

	luaunit.assertEquals(authors, { "Author 1" })
	luaunit.assertEquals(licenses, { "GPL-2.0-or-later", "MIT" })
end

function TestSPDX:testUpdateYear()
	local authors, licenses = spdx.update_spdx_record(
		{ "2022 Author 1" },
		{ "GPL-2.0-or-later" },
		{ "@YYYY@ Author 1" },
		{ "GPL-2.0-or-later" }
	)

	luaunit.assertEquals(authors, { "2022-2023 Author 1" })
	luaunit.assertEquals(licenses, { "GPL-2.0-or-later" })
end

function TestSPDX:testUpdateSameYear()
	local authors, licenses = spdx.update_spdx_record(
		{ "2023 Author 1" },
		{ "GPL-2.0-or-later" },
		{ "@YYYY@ Author 1" },
		{ "GPL-2.0-or-later" }
	)

	luaunit.assertEquals(authors, { "2023 Author 1" })
	luaunit.assertEquals(licenses, { "GPL-2.0-or-later" })
end

function TestSPDX:testUpdateMultiYear()
	local authors, licenses = spdx.update_spdx_record(
		{ "2020-2022 Author 1" },
		{ "GPL-2.0-or-later" },
		{ "@YYYY@ Author 1" },
		{ "GPL-2.0-or-later" }
	)

	luaunit.assertEquals(authors, { "2020-2023 Author 1" })
	luaunit.assertEquals(licenses, { "GPL-2.0-or-later" })
end

os.exit(luaunit.LuaUnit.run())
