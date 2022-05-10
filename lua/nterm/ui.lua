local _2afile_2a = "/nix/store/slv17irph93vfbqs49mlgdn5m7zh0ssi-source/src/nterm/ui.fnl"
local _2amodule_name_2a = "nterm.ui"
local _2amodule_2a
do
  package.loaded[_2amodule_name_2a] = {}
  _2amodule_2a = package.loaded[_2amodule_name_2a]
end
local _2amodule_locals_2a
do
  _2amodule_2a["aniseed/locals"] = {}
  _2amodule_locals_2a = (_2amodule_2a)["aniseed/locals"]
end
local a, nvim, s = require("aniseed.core"), require("aniseed.nvim"), require("aniseed.string")
do end (_2amodule_locals_2a)["a"] = a
_2amodule_locals_2a["nvim"] = nvim
_2amodule_locals_2a["s"] = s
local function width()
  return nvim.o.columns
end
_2amodule_locals_2a["width"] = width
local function height()
  return nvim.o.lines
end
_2amodule_locals_2a["height"] = height
local function popup_pos(anchor, size)
  local north = 2
  local west = 2
  local south = (height() - 4)
  local east = (width() - 2)
  local pos
  local _1_
  if ("NE" == anchor) then
    _1_ = {row = north, col = east, box = {y1 = north, x1 = (east - size.width), y2 = (north + size.height), x2 = east}}
  elseif ("SE" == anchor) then
    _1_ = {row = south, col = east, box = {y1 = (south - size.height), x1 = (east - size.width), y2 = south, x2 = east}}
  elseif ("SW" == anchor) then
    _1_ = {row = south, col = west, box = {y1 = (south - size.height), x1 = west, y2 = south, x2 = (west + size.width)}}
  elseif ("NW" == anchor) then
    _1_ = {row = north, col = west, box = {y1 = north, x1 = west, y2 = (north + size.height), x2 = (west + size.width)}}
  else
    nvim.err_writeln("anchor must be one of: NE, SE, SW, NW")
    _1_ = popup_pos("NE", size)
  end
  pos = a.assoc(_1_, "anchor", anchor)
  return {relative = "editor", width = size.width, height = size.height, col = pos.col, row = pos.row, focusable = false, anchor = pos.anchor, style = "minimal"}
end
_2amodule_locals_2a["popup-pos"] = popup_pos
local function max_length(xs)
  local function _3_(_241)
    return #_241
  end
  return math.max(unpack(a.map(_3_, xs)))
end
_2amodule_locals_2a["max-length"] = max_length
local default_options = {timeout = 2000, hl = "NtermSuccess", pos = "SE"}
_2amodule_locals_2a["default-options"] = default_options
local function popup(msg, options)
  local options0 = a.merge(default_options, options)
  local msg0
  if a["string?"](msg) then
    msg0 = {msg}
  else
    msg0 = msg
  end
  local lines = a.count(msg0)
  local buf_id = nvim.create_buf(true, false)
  local win_opts = popup_pos(options0.pos, {width = (2 + max_length(msg0)), height = (2 + lines)})
  local win = nvim.open_win(buf_id, false, win_opts)
  local function _5_(_241)
    return (" " .. _241)
  end
  nvim.buf_set_lines(buf_id, 1, lines, false, a.map(_5_, msg0))
  nvim.win_set_option(win, "winblend", 10)
  nvim.win_set_option(win, "winhl", ("Normal:" .. options0.hl))
  local function _6_()
    return nvim.buf_delete(buf_id, {force = true})
  end
  vim.defer_fn(_6_, options0.timeout)
  return win
end
_2amodule_2a["popup"] = popup
local function highlight(group, guifg, guibg, ctermfg, ctermbg, attr, guisp)
  local parts = {group}
  if guifg then
    table.insert(parts, ("guifg=#" .. guifg))
  else
  end
  if guibg then
    table.insert(parts, ("guibg=#" .. guibg))
  else
  end
  if ctermfg then
    table.insert(parts, ("ctermfg=" .. ctermfg))
  else
  end
  if ctermbg then
    table.insert(parts, ("ctermbg=" .. ctermbg))
  else
  end
  if attr then
    table.insert(parts, ("gui=" .. attr))
    table.insert(parts, ("cterm" .. attr))
  else
  end
  if guisp then
    table.insert(parts, ("guisp=#" .. guisp))
  else
  end
  return nvim.command(("highlight " .. table.concat(parts, " ")))
end
_2amodule_locals_2a["highlight"] = highlight
if (0 == nvim.fn.hlID("NtermSuccess")) then
  highlight("NtermSuccess", "181818", "a1b56c")
else
end
if (0 == nvim.fn.hlID("NtermError")) then
  highlight("NtermError", "d8d8d8", "ab4642")
else
end
--[[ (popup ["Success!" "Command was ok"] {:hl "NtermError" :pos "NW" :timeout 2500}) ]]--
return _2amodule_2a