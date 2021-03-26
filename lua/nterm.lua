local _0_0 = nil
do
  local name_0_ = "nterm"
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
local _2amodule_name_2a = "nterm"
do local _ = ({nil, _0_0, {{}, nil, nil, nil}})[2] end
local filetype = nil
do
  local v_0_ = nil
  do
    local v_0_0 = "nterm"
    _0_0["filetype"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["filetype"] = v_0_
  filetype = v_0_
end
local terms = nil
do
  local v_0_ = nil
  do
    local v_0_0 = ((_0_0).terms or {})
    _0_0["terms"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["terms"] = v_0_
  terms = v_0_
end
local options = nil
do
  local v_0_ = nil
  do
    local v_0_0 = {bg_color = nil, direction = "horizontal", shell = "fish", size = 20}
    _0_0["options"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["options"] = v_0_
  options = v_0_
end
local get_terms = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function get_terms0()
      return terms
    end
    v_0_0 = get_terms0
    _0_0["get-terms"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["get-terms"] = v_0_
  get_terms = v_0_
end
local get_term_by_buf = nil
do
  local v_0_ = nil
  local function get_term_by_buf0(buf_id)
    local term_info = nil
    local function _2_(_241)
      if (buf_id == a.get(_241, "buf")) then
        return _241
      end
    end
    term_info = a.some(_2_, a.vals(get_terms()))
    return a.get(term_info, "name")
  end
  v_0_ = get_term_by_buf0
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["get-term-by-buf"] = v_0_
  get_term_by_buf = v_0_
end
local tab_get_open_terms = nil
do
  local v_0_ = nil
  local function tab_get_open_terms0()
    local function _2_(_241)
      return (filetype == nvim.buf_get_option(_241, "filetype"))
    end
    local function _3_(_241)
      return nvim.win_get_buf(_241)
    end
    return a.map(get_term_by_buf, a.filter(_2_, a.map(_3_, nvim.tabpage_list_wins(0))))
  end
  v_0_ = tab_get_open_terms0
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["tab-get-open-terms"] = v_0_
  tab_get_open_terms = v_0_
end
local get_term_win = nil
do
  local v_0_ = nil
  local function get_term_win0(name)
    local name0 = (name or "default")
    local buf_id = a["get-in"](terms, {name0, "buf"})
    local wins = nvim.tabpage_list_wins(0)
    local function _2_(_241)
      local buf = nvim.win_get_buf(_241)
      if (buf == buf_id) then
        return _241
      end
    end
    return a.some(_2_, wins)
  end
  v_0_ = get_term_win0
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["get-term-win"] = v_0_
  get_term_win = v_0_
end
local open_window = nil
do
  local v_0_ = nil
  local function open_window0()
    do
      local open_term = get_term_win(a.last(tab_get_open_terms()))
      nvim.set_current_win(open_term)
      if (a.get(options, "direction") == "horizontal") then
        if open_term then
          nvim.command("rightbelow vnew")
        else
          nvim.command("botright new")
          nvim.win_set_height(0, a.get(options, "size"))
        end
      else
        if open_term then
          nvim.command("rightbelow new")
        else
          nvim.command("vert botright new")
          nvim.win_set_width(0, a.get(options, "size"))
        end
      end
    end
    local win_id = nvim.get_current_win()
    nvim.win_set_option(win_id, "number", false)
    nvim.win_set_option(win_id, "relativenumber", false)
    if (a.get(options, "direction") == "horizontal") then
      nvim.win_set_option(win_id, "winfixheight", true)
    else
      nvim.win_set_option(win_id, "winfixwidth", true)
    end
    return {win_id, nvim.win_get_buf(win_id)}
  end
  v_0_ = open_window0
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["open-window"] = v_0_
  open_window = v_0_
end
local check_term_21 = nil
do
  local v_0_ = nil
  local function check_term_210(name)
    local buf_id = a["get-in"](terms, {name, "buf"})
    if not nvim.buf_is_valid(buf_id) then
      return a.assoc(terms, name, nil)
    end
  end
  v_0_ = check_term_210
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["check-term!"] = v_0_
  check_term_21 = v_0_
end
local term_destroy = nil
do
  local v_0_ = nil
  local function term_destroy0(name)
    do
      local buf_id = a["get-in"](terms, {name, "buf"})
      if nvim.buf_is_valid(buf_id) then
        nvim.buf_delete(buf_id, {force = true})
      end
    end
    return a.assoc(terms, name, nil)
  end
  v_0_ = term_destroy0
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["term-destroy"] = v_0_
  term_destroy = v_0_
end
local move_cur_bottom_21 = nil
do
  local v_0_ = nil
  local function move_cur_bottom_210(name)
    local buf_id = a["get-in"](terms, {name, "buf"})
    local win_id = get_term_win(name)
    local lines = nvim.buf_line_count(buf_id)
    return nvim.win_set_cursor(win_id, {lines, 1})
  end
  v_0_ = move_cur_bottom_210
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["move-cur-bottom!"] = v_0_
  move_cur_bottom_21 = v_0_
end
local term_new = nil
do
  local v_0_ = nil
  local function term_new0(name)
    local _let_0_ = open_window()
    local win_id = _let_0_[1]
    local buf_id = _let_0_[2]
    local shell = a.get(options, "shell")
    local cmd = (shell .. ";#" .. name)
    nvim.buf_set_option(buf_id, "filetype", filetype)
    nvim.buf_set_var(buf_id, "nterm_name", name)
    local job_id = nil
    local function _2_()
      return term_destroy(name)
    end
    job_id = vim.fn.termopen(cmd, {env = {FOO = "BAR", SHELL = shell}, on_exit = _2_})
    nvim.win_set_cursor(win_id, {nvim.buf_line_count(buf_id), 1})
    return a.assoc(terms, name, {buf = buf_id, job = job_id, name = name})
  end
  v_0_ = term_new0
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["term-new"] = v_0_
  term_new = v_0_
end
local term_display = nil
do
  local v_0_ = nil
  local function term_display0(name)
    local buf_id = a["get-in"](terms, {name, "buf"})
    local _let_0_ = open_window()
    local win_id = _let_0_[1]
    local old_buf_id = _let_0_[2]
    nvim.command("wincmd p")
    nvim.win_set_buf(win_id, buf_id)
    return nvim.buf_delete(old_buf_id, {})
  end
  v_0_ = term_display0
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["term-display"] = v_0_
  term_display = v_0_
end
local term_open = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function term_open0(name)
      local name0 = (name or "default")
      local _ = check_term_21(name0)
      local cur_win = nvim.tabpage_get_win(0)
      local term_buf_id = a["get-in"](terms, {name0, "buf"})
      if term_buf_id then
        if not get_term_win(name0) then
          term_display(name0)
        end
      else
        term_new(name0)
      end
      return nvim.set_current_win(cur_win)
    end
    v_0_0 = term_open0
    _0_0["term-open"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["term-open"] = v_0_
  term_open = v_0_
end
local term_close = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function term_close0(name)
      local name0 = (name or "default")
      local win_id = get_term_win(name0)
      if win_id then
        return nvim.win_close(win_id, false)
      end
    end
    v_0_0 = term_close0
    _0_0["term-close"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["term-close"] = v_0_
  term_close = v_0_
end
local term_toggle = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function term_toggle0()
      local open_terms = tab_get_open_terms()
      if (0 < a.count(open_terms)) then
        nvim.g._nterm_terms = open_terms
        return a["run!"](term_close, open_terms)
      else
        return a["run!"](term_open, (nvim.g._nterm_terms or {"default"}))
      end
    end
    v_0_0 = term_toggle0
    _0_0["term_toggle"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["term_toggle"] = v_0_
  term_toggle = v_0_
end
local term_send = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function term_send0(line, name)
      local name0 = (name or "default")
      term_open(name0)
      move_cur_bottom_21(name0)
      return nvim.fn.chansend(a["get-in"](terms, {name0, "job"}), (line .. "\n"))
    end
    v_0_0 = term_send0
    _0_0["term_send"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["term_send"] = v_0_
  term_send = v_0_
end
local trim_with_pos = nil
do
  local v_0_ = nil
  local function trim_with_pos0(str)
    local line = s.trim(str)
    local _, start_pos = string.find(str, "^%s*(.-)")
    local end_pos = (#line + start_pos)
    return {line, start_pos, end_pos}
  end
  v_0_ = trim_with_pos0
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["trim-with-pos"] = v_0_
  trim_with_pos = v_0_
end
local highlight = nil
do
  local v_0_ = nil
  local function highlight0(start, _end, rtype)
    local ns = nvim.create_namespace("")
    local buf = nvim.get_current_buf()
    local rtype0 = (rtype or "c")
    vim.highlight.range(buf, ns, "IncSearch", start, _end, rtype0)
    local function _2_()
      return nvim.buf_clear_namespace(buf, ns, a.first(start), a.inc(a.first(_end)))
    end
    return vim.defer_fn(_2_, 500)
  end
  v_0_ = highlight0
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["highlight"] = v_0_
  highlight = v_0_
end
local term_send_cur_line = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function term_send_cur_line0(name)
      local line_nr = a.dec(vim.fn.line("."))
      local _let_0_ = trim_with_pos(nvim.get_current_line())
      local line = _let_0_[1]
      local col_start = _let_0_[2]
      local col_end = _let_0_[3]
      highlight({line_nr, col_start}, {line_nr, col_end})
      return term_send(line, name)
    end
    v_0_0 = term_send_cur_line0
    _0_0["term_send_cur_line"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["term_send_cur_line"] = v_0_
  term_send_cur_line = v_0_
end
local add_maps = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function add_maps0()
      local opts = {noremap = true, silent = false}
      nvim.set_keymap("n", "<leader>tt", "<cmd>lua require'nterm'.term_toggle()<cr>", opts)
      return nvim.set_keymap("n", "<leader>tl", "<cmd>lua require'nterm'.term_send_cur_line()<cr>", opts)
    end
    v_0_0 = add_maps0
    _0_0["add-maps"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["add-maps"] = v_0_
  add_maps = v_0_
end
local add_git_maps = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function add_git_maps0()
      local opts = {noremap = true, silent = false}
      return nvim.set_keymap("n", "<leader>gp", "<cmd>lua require'nterm'.term_send('git push', 'git')<cr>", opts)
    end
    v_0_0 = add_git_maps0
    _0_0["add-git-maps"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["add-git-maps"] = v_0_
  add_git_maps = v_0_
end
local init = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function init0(options0)
      add_maps()
      return add_git_maps()
    end
    v_0_0 = init0
    _0_0["init"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["init"] = v_0_
  init = v_0_
end
-- (def term-name? default) (get-terms) (term_toggle) (term-open) (term-close) (term_send ls) (term_send_cur_line) (get-term-win default) (tab-get-open-terms) (get-terms) (term-open foo) (term-open bar) (nvim.set_current_win 1318) (term_send ls)
return nil