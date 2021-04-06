# nterm.nvim

Warning: WIP

A neovim plugin to interact with the terminal emulator

## Usage

```lua
require'nterm.main'.init({
  size = 20,
  direction = "horizontal", -- horizontal or vertical
  shell = "fish",
  popup = 2000,     -- Number of miliseconds to show the info about the commmand. 0 to dissable
  popup_pos = "SE", --  one of "NE" "SE" "SW" "NW"
  autoclose = 2000, -- If command is sucesful, close the terminal after that number of miliseconds
})
```

## Maps

## Similar projects

- [nvim-toggleterm.lua](https://github.com/akinsho/nvim-toggleterm.lua)
- [neoterm](https://github.com/kassio/neoterm)
