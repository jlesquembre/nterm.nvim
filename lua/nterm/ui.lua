local _2afile_2a = "/nix/store/imagl8m19a5j9370629sqa0ip1pcgr9w-source/src/nterm/ui.fnl"
local _1_
do
  local name_4_auto = "nterm.ui"
  local module_5_auto
  do
    local x_6_auto = _G.package.loaded[name_4_auto]
    if ("table" == type(x_6_auto)) then
      module_5_auto = x_6_auto
    else
      module_5_auto = {}
    end
  end
  module_5_auto["aniseed/module"] = name_4_auto
  module_5_auto["aniseed/locals"] = ((module_5_auto)["aniseed/locals"] or {})
  do end (module_5_auto)["aniseed/local-fns"] = ((module_5_auto)["aniseed/local-fns"] or {})
  do end (_G.package.loaded)[name_4_auto] = module_5_auto
  _1_ = module_5_auto
end
local autoload
local function _3_(...)
  return (require("aniseed.autoload")).autoload(...)
end
autoload = _3_
local function _6_(...)
  local ok_3f_21_auto, val_22_auto = nil, nil
  local function _5_()
    return {require("aniseed.core"), require("aniseed.nvim"), require("aniseed.string")}
  end
  ok_3f_21_auto, val_22_auto = pcall(_5_)
  if ok_3f_21_auto then
    _1_["aniseed/local-fns"] = {require = {a = "aniseed.core", nvim = "aniseed.nvim", s = "aniseed.string"}}
    return val_22_auto
  else
    return print(val_22_auto)
  end
end
local _local_4_ = _6_(...)
local a = _local_4_[1]
local nvim = _local_4_[2]
local s = _local_4_[3]
local _2amodule_2a = _1_
local _2amodule_name_2a = "nterm.ui"
do local _ = ({nil, _1_, nil, {{}, nil, nil, nil}})[2] end
local width
do
  local v_23_auto
  local function width0()
    return nvim.o.columns
  end
  v_23_auto = width0
  local t_24_auto = (_1_)["aniseed/locals"]
  t_24_auto["width"] = v_23_auto
  width = v_23_auto
end
local height
do
  local v_23_auto
  local function height0()
    return nvim.o.lines
  end
  v_23_auto = height0
  local t_24_auto = (_1_)["aniseed/locals"]
  t_24_auto["height"] = v_23_auto
  height = v_23_auto
end
local popup_pos
do
  local v_23_auto
  local function popup_pos0(anchor, size)
    local north = 2
    local west = 2
    local south = (height() - 4)
    local east = (width() - 2)
    local pos
    local _8_
    if ("NE" == anchor) then
      _8_ = {box = {x1 = (east - size.width), x2 = east, y1 = north, y2 = (north + size.height)}, col = east, row = north}
    elseif ("SE" == anchor) then
      _8_ = {box = {x1 = (east - size.width), x2 = east, y1 = (south - size.height), y2 = south}, col = east, row = south}
    elseif ("SW" == anchor) then
      _8_ = {box = {x1 = west, x2 = (west + size.width), y1 = (south - size.height), y2 = south}, col = west, row = south}
    elseif ("NW" == anchor) then
      _8_ = {box = {x1 = west, x2 = (west + size.width), y1 = north, y2 = (north + size.height)}, col = west, row = north}
    else
      nvim.err_writeln("anchor must be one of: NE, SE, SW, NW")
      _8_ = popup_pos0("NE", size)
    end
    pos = a.assoc(_8_, "anchor", anchor)
    return {anchor = pos.anchor, col = pos.col, focusable = false, height = size.height, relative = "editor", row = pos.row, style = "minimal", width = size.width}
  end
  v_23_auto = popup_pos0
  local t_24_auto = (_1_)["aniseed/locals"]
  t_24_auto["popup-pos"] = v_23_auto
  popup_pos = v_23_auto
end
local max_length
do
  local v_23_auto
  local function max_length0(xs)
    local function _10_(_241)
      return #_241
    end
    return math.max(unpack(a.map(_10_, xs)))
  end
  v_23_auto = max_length0
  local t_24_auto = (_1_)["aniseed/locals"]
  t_24_auto["max-length"] = v_23_auto
  max_length = v_23_auto
end
local default_options
do
  local v_23_auto = {hl = "NtermSuccess", pos = "SE", timeout = 2000}
  local t_24_auto = (_1_)["aniseed/locals"]
  t_24_auto["default-options"] = v_23_auto
  default_options = v_23_auto
end
local popup
do
  local v_23_auto
  do
    local v_25_auto
    local function popup0(msg, options)
      local options0 = a.merge(default_options, options)
      local msg0
      if a["string?"](msg) then
        msg0 = {msg}
      else
        msg0 = msg
      end
      local lines = a.count(msg0)
      local buf_id = nvim.create_buf(true, false)
      local win_opts = popup_pos(options0.pos, {height = (2 + lines), width = (2 + max_length(msg0))})
      local win = nvim.open_win(buf_id, false, win_opts)
      local function _12_(_241)
        return (" " .. _241)
      end
      nvim.buf_set_lines(buf_id, 1, lines, false, a.map(_12_, msg0))
      nvim.win_set_option(win, "winblend", 10)
      nvim.win_set_option(win, "winhl", ("Normal:" .. options0.hl))
      local function _13_()
        return nvim.buf_delete(buf_id, {force = true})
      end
      vim.defer_fn(_13_, options0.timeout)
      return win
    end
    v_25_auto = popup0
    _1_["popup"] = v_25_auto
    v_23_auto = v_25_auto
  end
  local t_24_auto = (_1_)["aniseed/locals"]
  t_24_auto["popup"] = v_23_auto
  popup = v_23_auto
end
local highlight
do
  local v_23_auto
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
  v_23_auto = highlight0
  local t_24_auto = (_1_)["aniseed/locals"]
  t_24_auto["highlight"] = v_23_auto
  highlight = v_23_auto
end
if (0 == nvim.fn.hlID("NtermSuccess")) then
  highlight("NtermSuccess", "181818", "a1b56c")
end
if (0 == nvim.fn.hlID("NtermError")) then
  highlight("NtermError", "d8d8d8", "ab4642")
end
-- (popup ["Success!" "Command was ok"] {:hl "NtermError" :pos "NW" :timeout 2500})
return nil