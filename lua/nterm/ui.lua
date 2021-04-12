local _0_0 = nil
do
  local name_0_ = "nterm.ui"
  local module_0_ = nil
  do
    local x_0_ = package.loaded[name_0_]
    if ("table" == type(x_0_)) then
      module_0_ = x_0_
    else
      module_0_ = {}
    end
  end
  module_0_["aniseed/module"] = name_0_
  module_0_["aniseed/locals"] = ((module_0_)["aniseed/locals"] or {})
  module_0_["aniseed/local-fns"] = ((module_0_)["aniseed/local-fns"] or {})
  package.loaded[name_0_] = module_0_
  _0_0 = module_0_
end
local function _1_(...)
  local ok_3f_0_, val_0_ = nil, nil
  local function _1_()
    return {require("aniseed.core"), require("aniseed.nvim"), require("aniseed.string")}
  end
  ok_3f_0_, val_0_ = pcall(_1_)
  if ok_3f_0_ then
    _0_0["aniseed/local-fns"] = {require = {a = "aniseed.core", nvim = "aniseed.nvim", s = "aniseed.string"}}
    return val_0_
  else
    return print(val_0_)
  end
end
local _local_0_ = _1_(...)
local a = _local_0_[1]
local nvim = _local_0_[2]
local s = _local_0_[3]
local _2amodule_2a = _0_0
local _2amodule_name_2a = "nterm.ui"
do local _ = ({nil, _0_0, {{}, nil, nil, nil}})[2] end
local width = nil
do
  local v_0_ = nil
  local function width0()
    return nvim.o.columns
  end
  v_0_ = width0
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["width"] = v_0_
  width = v_0_
end
local height = nil
do
  local v_0_ = nil
  local function height0()
    return nvim.o.lines
  end
  v_0_ = height0
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["height"] = v_0_
  height = v_0_
end
local popup_pos = nil
do
  local v_0_ = nil
  local function popup_pos0(anchor, size)
    local north = 2
    local west = 2
    local south = (height() - 4)
    local east = (width() - 2)
    local pos = nil
    local _2_
    if ("NE" == anchor) then
      _2_ = {box = {x1 = (east - size.width), x2 = east, y1 = north, y2 = (north + size.height)}, col = east, row = north}
    elseif ("SE" == anchor) then
      _2_ = {box = {x1 = (east - size.width), x2 = east, y1 = (south - size.height), y2 = south}, col = east, row = south}
    elseif ("SW" == anchor) then
      _2_ = {box = {x1 = west, x2 = (west + size.width), y1 = (south - size.height), y2 = south}, col = west, row = south}
    elseif ("NW" == anchor) then
      _2_ = {box = {x1 = west, x2 = (west + size.width), y1 = north, y2 = (north + size.height)}, col = west, row = north}
    else
      nvim.err_writeln("anchor must be one of: NE, SE, SW, NW")
      _2_ = popup_pos0("NE", size)
    end
    pos = a.assoc(_2_, "anchor", anchor)
    return {anchor = pos.anchor, col = pos.col, focusable = false, height = size.height, relative = "editor", row = pos.row, style = "minimal", width = size.width}
  end
  v_0_ = popup_pos0
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["popup-pos"] = v_0_
  popup_pos = v_0_
end
local max_length = nil
do
  local v_0_ = nil
  local function max_length0(xs)
    local function _2_(_241)
      return #_241
    end
    return math.max(unpack(a.map(_2_, xs)))
  end
  v_0_ = max_length0
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["max-length"] = v_0_
  max_length = v_0_
end
local default_options = nil
do
  local v_0_ = {hl = "NtermSuccess", pos = "SE", timeout = 2000}
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["default-options"] = v_0_
  default_options = v_0_
end
local popup = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function popup0(msg, options)
      local options0 = a.merge(default_options, options)
      local msg0 = nil
      if a["string?"](msg) then
        msg0 = {msg}
      else
        msg0 = msg
      end
      local lines = a.count(msg0)
      local buf_id = nvim.create_buf(true, false)
      local win_opts = popup_pos(options0.pos, {height = (2 + lines), width = (2 + max_length(msg0))})
      local win = nvim.open_win(buf_id, false, win_opts)
      local function _3_(_241)
        return (" " .. _241)
      end
      nvim.buf_set_lines(buf_id, 1, lines, false, a.map(_3_, msg0))
      nvim.win_set_option(win, "winblend", 10)
      nvim.win_set_option(win, "winhl", ("Normal:" .. options0.hl))
      local function _4_()
        return nvim.buf_delete(buf_id, {force = true})
      end
      vim.defer_fn(_4_, options0.timeout)
      return win
    end
    v_0_0 = popup0
    _0_0["popup"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["popup"] = v_0_
  popup = v_0_
end
local highlight = nil
do
  local v_0_ = nil
  local function highlight0(group, guifg, guibg, ctermfg, ctermbg, attr, guisp)
    local parts = {group}
    if guifg then
      table.insert(parts, ("guifg=#" .. guifg))
    end
    if guibg then
      table.insert(parts, ("guibg=#" .. guibg))
    end
    if ctermfg then
      table.insert(parts, ("ctermfg=" .. ctermfg))
    end
    if ctermbg then
      table.insert(parts, ("ctermbg=" .. ctermbg))
    end
    if attr then
      table.insert(parts, ("gui=" .. attr))
      table.insert(parts, ("cterm" .. attr))
    end
    if guisp then
      table.insert(parts, ("guisp=#" .. guisp))
    end
    return nvim.command(("highlight " .. table.concat(parts, " ")))
  end
  v_0_ = highlight0
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["highlight"] = v_0_
  highlight = v_0_
end
if (0 == nvim.fn.hlID("NtermSuccess")) then
  highlight("NtermSuccess", "181818", "a1b56c")
end
if (0 == nvim.fn.hlID("NtermError")) then
  highlight("NtermError", "d8d8d8", "ab4642")
end
-- (popup table: 0x7ffff79f7b08 table: 0x7ffff77f5ad0)
return nil