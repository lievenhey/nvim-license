# nvim-license

A simple neovim plugin which manages spdx records.
It adds a command `:Spdx` which will create and update spdx records.

## Configuration
To configure call setup like this:
```lua
require("nvim-spdx").setup {
  authors = {
    "Lieven Hey <lieven.hey@kdab.com>",
  },
  licenses = { "GPL-2.0-or-later" },
}
 
```

You can use `@YYYY@` as a placeholder for the current year.
