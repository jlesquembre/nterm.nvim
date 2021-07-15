local _2afile_2a = "/nix/store/1946766wrh6mqy6kl5gng4wk4m7p7ywv-source/src/nterm/main.fnl"
local _0_
do
  local name_0_ = "nterm.main"
  local module_0_
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
  do end (module_0_)["aniseed/local-fns"] = ((module_0_)["aniseed/local-fns"] or {})
  do end (package.loaded)[name_0_] = module_0_
  _0_ = module_0_
end
local autoload
local function _1_(...)
  return (require("aniseed.autoload")).autoload(...)
end
autoload = _1_
local function _2_(...)
  local ok_3f_0_, val_0_ = nil, nil
  local function _2_()
    return {require("aniseed.core"), require("aniseed.nvim"), require("aniseed.string"), require("nterm.server"), require("nterm.ui")}
  end
  ok_3f_0_, val_0_ = pcall(_2_)
  if ok_3f_0_ then
    _0_["aniseed/local-fns"] = {require = {["server-utils"] = "nterm.server", a = "aniseed.core", nvim = "aniseed.nvim", s = "aniseed.string", ui = "nterm.ui"}}
    return val_0_
  else
    return print(val_0_)
  end
end
local _local_0_ = _2_(...)
local a = _local_0_[1]
local nvim = _local_0_[2]
local s = _local_0_[3]
local server_utils = _local_0_[4]
local ui = _local_0_[5]
local _2amodule_2a = _0_
local _2amodule_name_2a = "nterm.main"
do local _ = ({nil, _0_, nil, {{}, nil, nil, nil}})[2] end
local filetype
do
  local v_0_
  do
    local v_0_0 = "nterm"
    _0_["filetype"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["filetype"] = v_0_
  filetype = v_0_
end
local terms
do
  local v_0_
  do
    local v_0_0 = ((_0_).terms or {})
    do end (_0_)["terms"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["terms"] = v_0_
  terms = v_0_
end
local options
do
  local v_0_
  do
    local v_0_0 = {autoclose = 2000, direction = "horizontal", maps = true, popup = 2000, popup_pos = "NE", shell = "fish", size = 20}
    _0_["options"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["options"] = v_0_
  options = v_0_
end
local loaded_3f
do
  local v_0_ = false
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["loaded?"] = v_0_
  loaded_3f = v_0_
end
local get_terms
do
  local v_0_
  do
    local v_0_0
    local function get_terms0()
      return terms
    end
    v_0_0 = get_terms0
    _0_["get-terms"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["get-terms"] = v_0_
  get_terms = v_0_
end
local get_term_by_buf
do
  local v_0_
  local function get_term_by_buf0(buf_id)
    local term_info
    local function _3_(_241)
      if (buf_id == a.get(_241, "buf")) then
        return _241
      end
    end
    term_info = a.some(_3_, a.vals(get_terms()))
    return a.get(term_info, "name")
  end
  v_0_ = get_term_by_buf0
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["get-term-by-buf"] = v_0_
  get_term_by_buf = v_0_
end
local tab_get_open_terms
do
  local v_0_
  local function tab_get_open_terms0()
    local function _3_(_241)
      return (filetype == nvim.buf_get_option(_241, "filetype"))
    end
    local function _4_(_241)
      return nvim.win_get_buf(_241)
    end
    return a.map(get_term_by_buf, a.filter(_3_, a.map(_4_, nvim.tabpage_list_wins(0))))
  end
  v_0_ = tab_get_open_terms0
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["tab-get-open-terms"] = v_0_
  tab_get_open_terms = v_0_
end
local get_term_win
do
  local v_0_
  local function get_term_win0(name)
    local name0 = (name or "default")
    local buf_id = a["get-in"](terms, {name0, "buf"})
    local wins = nvim.tabpage_list_wins(0)
    local function _3_(_241)
      local buf = nvim.win_get_buf(_241)
      if (buf == buf_id) then
        return _241
      end
    end
    return a.some(_3_, wins)
  end
  v_0_ = get_term_win0
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["get-term-win"] = v_0_
  get_term_win = v_0_
end
local open_window
do
  local v_0_
  local function open_window0(opts)
    do
      local open_term = get_term_win(a.last(tab_get_open_terms()))
      nvim.set_current_win(open_term)
      if (a.get(opts, "direction") == "horizontal") then
        if open_term then
          nvim.command("rightbelow vnew")
        else
          nvim.command("botright new")
          nvim.win_set_height(0, a.get(opts, "size"))
        end
      else
        if open_term then
          nvim.command("rightbelow new")
        else
          nvim.command("vert botright new")
          nvim.win_set_width(0, a.get(opts, "size"))
        end
      end
    end
    local win_id = nvim.get_current_win()
    nvim.win_set_option(win_id, "number", false)
    nvim.win_set_option(win_id, "relativenumber", false)
    if (a.get(opts, "direction") == "horizontal") then
      nvim.win_set_option(win_id, "winfixheight", true)
    else
      nvim.win_set_option(win_id, "winfixwidth", true)
    end
    local buf_id = nvim.win_get_buf(win_id)
    nvim.buf_set_option(12, "buflisted", false)
    return {win_id, buf_id}
  end
  v_0_ = open_window0
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["open-window"] = v_0_
  open_window = v_0_
end
local check_term_21
do
  local v_0_
  local function check_term_210(name)
    local buf_id = a["get-in"](terms, {name, "buf"})
    if not nvim.buf_is_valid(buf_id) then
      return a.assoc(terms, name, nil)
    end
  end
  v_0_ = check_term_210
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["check-term!"] = v_0_
  check_term_21 = v_0_
end
local term_destroy
do
  local v_0_
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
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["term-destroy"] = v_0_
  term_destroy = v_0_
end
local move_cur_bottom_21
do
  local v_0_
  local function move_cur_bottom_210(name)
    local buf_id = a["get-in"](terms, {name, "buf"})
    local win_id = get_term_win(name)
    local lines = nvim.buf_line_count(buf_id)
    return nvim.win_set_cursor(win_id, {lines, 1})
  end
  v_0_ = move_cur_bottom_210
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["move-cur-bottom!"] = v_0_
  move_cur_bottom_21 = v_0_
end
local term_close
do
  local v_0_
  do
    local v_0_0
    local function term_close0(name)
      local name0 = (name or "default")
      local win_id = get_term_win(name0)
      if win_id then
        return nvim.win_close(win_id, false)
      end
    end
    v_0_0 = term_close0
    _0_["term-close"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["term-close"] = v_0_
  term_close = v_0_
end
local term_stop
do
  local v_0_
  do
    local v_0_0
    local function term_stop0(name)
      term_close(name)
      local name0 = (name or "default")
      local job_id = a["get-in"](terms, {name0, "job"})
      if job_id then
        return vim.fn.jobstop(job_id)
      end
    end
    v_0_0 = term_stop0
    _0_["term-stop"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["term-stop"] = v_0_
  term_stop = v_0_
end
local shell__3escript_name
do
  local v_0_ = {fish = "nterm.fish"}
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["shell->script-name"] = v_0_
  shell__3escript_name = v_0_
end
local script_path
do
  local v_0_
  local function script_path0(shell)
    if not nvim.g.nterm_path then
      nvim.command("source ~/projects/nterm.nvim/plugin/nterm_nvim.vim")
    end
    local script = a.get(shell__3escript_name, shell)
    if script then
      return (nvim.g.nterm_path .. "/" .. script)
    end
  end
  v_0_ = script_path0
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["script-path"] = v_0_
  script_path = v_0_
end
local show_popup
do
  local v_0_
  local function show_popup0(term_name, exit_code, cmd, opts)
    local timeout = opts.popup
    if (0 < timeout) then
      local ok = (0 == exit_code)
      local msg
      if ok then
        msg = {"OK!", ("Terminal: " .. term_name), ("Cmd: " .. cmd)}
      else
        msg = {("ERROR CODE: " .. exit_code), ("Terminal: " .. term_name), ("Cmd: " .. cmd)}
      end
      local _4_
      if ok then
        _4_ = "NtermSuccess"
      else
        _4_ = "NtermError"
      end
      return ui.popup(msg, {hl = _4_, pos = opts.popup_pos, timeout = timeout})
    end
  end
  v_0_ = show_popup0
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["show-popup"] = v_0_
  show_popup = v_0_
end
local process_client_response
do
  local v_0_
  do
    local v_0_0
    local function process_client_response0(data)
      local name, exit_code, term_cmd = unpack(s.split(s.trim(data), "\13\n"))
      local exit_code0 = tonumber(exit_code)
      local _let_0_ = a["get-in"](terms, {name, "current-cmd"}, {})
      local cmd = _let_0_["cmd"]
      local opts = _let_0_["opts"]
      local opts0 = a.merge(options, (opts or {}))
      if (cmd == term_cmd) then
        show_popup(name, exit_code0, cmd, opts0)
        a["assoc-in"](terms, {name, "current-cmd"}, nil)
        if ((0 == exit_code0) and (0 < opts0.autoclose)) then
          local function _3_()
            if a["nil?"](a["get-in"](terms, {name, "current-cmd"})) then
              return term_close(name)
            end
          end
          vim.defer_fn(_3_, opts0.autoclose)
        end
        return {code = exit_code0, name = name}
      end
    end
    v_0_0 = process_client_response0
    _0_["process-client-response"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["process-client-response"] = v_0_
  process_client_response = v_0_
end
local init_server
do
  local v_0_
  do
    local v_0_0
    local function init_server0()
      if a["nil?"](_G.nterm_server) then
        nterm_server = server_utils["create-server"]("0.0.0.0", 0, process_client_response)
        nterm_port = a.get(nterm_server:getsockname(), "port")
        return nil
      else
        nterm_server:close()
        nterm_server = server_utils["create-server"]("0.0.0.0", nterm_port, process_client_response)
        return nil
      end
    end
    v_0_0 = init_server0
    _0_["init-server"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["init-server"] = v_0_
  init_server = v_0_
end
local term_new
do
  local v_0_
  local function term_new0(name, opts)
    local _let_0_ = open_window(opts)
    local win_id = _let_0_[1]
    local buf_id = _let_0_[2]
    local shell = a.get(opts, "shell")
    local script = script_path(shell)
    local extra_args
    if script then
      extra_args = (" -C 'source " .. script .. "'")
    else
      extra_args = ""
    end
    local cmd = (shell .. extra_args)
    nvim.buf_set_option(buf_id, "filetype", filetype)
    nvim.buf_set_var(buf_id, "nterm_name", name)
    local job_id
    local function _4_()
      return term_destroy(name)
    end
    job_id = vim.fn.termopen(cmd, {env = {NTERM_NAME = name, NTERM_PORT = a.get(nterm_server:getsockname(), "port"), SHELL = shell}, on_exit = _4_})
    nvim.win_set_cursor(win_id, {nvim.buf_line_count(buf_id), 1})
    return a.assoc(terms, name, {["current-cmd"] = nil, buf = buf_id, cmds = {}, job = job_id, name = name})
  end
  v_0_ = term_new0
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["term-new"] = v_0_
  term_new = v_0_
end
local term_display
do
  local v_0_
  local function term_display0(name, opts)
    local buf_id = a["get-in"](terms, {name, "buf"})
    local _let_0_ = open_window(opts)
    local win_id = _let_0_[1]
    local old_buf_id = _let_0_[2]
    nvim.command("wincmd p")
    nvim.win_set_buf(win_id, buf_id)
    return nvim.buf_delete(old_buf_id, {})
  end
  v_0_ = term_display0
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["term-display"] = v_0_
  term_display = v_0_
end
local term_open
do
  local v_0_
  do
    local v_0_0
    local function term_open0(name, opts)
      local name0 = (name or "default")
      local opts0 = (opts or options)
      local _ = check_term_21(name0)
      local cur_win = nvim.tabpage_get_win(0)
      local term_buf_id = a["get-in"](terms, {name0, "buf"})
      if term_buf_id then
        if not get_term_win(name0) then
          term_display(name0, opts0)
        end
      else
        term_new(name0, opts0)
      end
      return nvim.set_current_win(cur_win)
    end
    v_0_0 = term_open0
    _0_["term-open"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["term-open"] = v_0_
  term_open = v_0_
end
local term_toggle
do
  local v_0_
  do
    local v_0_0
    local function term_toggle0(opts)
      local opts0 = a.merge(options, (opts or {}))
      local open_terms = tab_get_open_terms()
      if (0 < a.count(open_terms)) then
        nvim.g._nterm_terms = open_terms
        return a["run!"](term_close, open_terms)
      else
        local function _3_(_241)
          return term_open(_241, opts0)
        end
        return a["run!"](_3_, (nvim.g._nterm_terms or {"default"}))
      end
    end
    v_0_0 = term_toggle0
    _0_["term_toggle"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["term_toggle"] = v_0_
  term_toggle = v_0_
end
local add_maps
do
  local v_0_
  do
    local v_0_0
    local function add_maps0()
      local opts = {noremap = true, silent = false}
      nvim.set_keymap("n", "<leader>tt", "<cmd>lua require'nterm.main'.term_toggle()<cr>", opts)
      nvim.set_keymap("n", "<leader>tl", "<cmd>lua require'nterm.main'.term_send_cur_line()<cr>", opts)
      return nvim.set_keymap("n", "<leader>tf", "<cmd>lua require'nterm.main'.term_focus()<cr>", opts)
    end
    v_0_0 = add_maps0
    _0_["add-maps"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["add-maps"] = v_0_
  add_maps = v_0_
end
local add_git_maps
do
  local v_0_
  do
    local v_0_0
    local function add_git_maps0()
      local opts = {noremap = true, silent = false}
      nvim.set_keymap("n", "<leader>gpp", "<cmd>lua require'nterm.main'.term_send('git push', 'git')<cr>", opts)
      nvim.set_keymap("n", "<leader>gps", "<cmd>lua require'nterm.main'.term_send('git push --set-upstream origin HEAD', 'git')<cr>", opts)
      nvim.set_keymap("n", "<leader>gpf", "<cmd>lua require'nterm.main'.term_send('git push --force-with-lease', 'git')<cr>", opts)
      nvim.set_keymap("n", "<leader>gpt", "<cmd>lua require'nterm.main'.term_send('git push --tags', 'git')<cr>", opts)
      nvim.set_keymap("n", "<leader>gpu", "<cmd>lua require'nterm.main'.term_send('git pull --ff-only', 'git')<cr>", opts)
      return nvim.set_keymap("n", "<leader>gt", "<cmd>lua require'nterm.main'.term_focus('git')<cr>", opts)
    end
    v_0_0 = add_git_maps0
    _0_["add-git-maps"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["add-git-maps"] = v_0_
  add_git_maps = v_0_
end
local init
do
  local v_0_
  do
    local v_0_0
    local function init0(user_options)
      do
        local user_options0 = (user_options or {})
        a["merge!"](options, user_options0)
      end
      if options.maps then
        add_maps()
        add_git_maps()
      end
      init_server()
      local loaded_3f0
      do
        local v_0_1 = true
        local t_0_ = (_0_)["aniseed/locals"]
        t_0_["loaded?"] = v_0_1
        loaded_3f0 = v_0_1
      end
      return nil
    end
    v_0_0 = init0
    _0_["init"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["init"] = v_0_
  init = v_0_
end
local term_send
do
  local v_0_
  do
    local v_0_0
    local function term_send0(cmd, name, opts)
      local name0 = (name or "default")
      local opts0 = a.merge(options, (opts or {}))
      if (false == loaded_3f) then
        init()
      end
      term_open(name0, opts0)
      move_cur_bottom_21(name0)
      if (nil ~= a["get-in"](terms, {name0, "current-cmd"})) then
        return ui.popup({"Command running in", ("terminal " .. name0)}, {hl = "NtermError", pos = opts0.popup_pos})
      else
        local size = nvim.fn.chansend(a["get-in"](terms, {name0, "job"}), (cmd .. "\n"))
        if (0 < size) then
          a["assoc-in"](terms, {name0, "current-cmd"}, {cmd = cmd, opts = opts0})
          local cmds = a["get-in"](terms, {name0, "cmds"})
          return table.insert(cmds, cmd)
        end
      end
    end
    v_0_0 = term_send0
    _0_["term_send"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["term_send"] = v_0_
  term_send = v_0_
end
local term_focus
do
  local v_0_
  do
    local v_0_0
    local function term_focus0(name, opts)
      local name0 = (name or "default")
      local opts0 = a.merge(options, (opts or {}))
      term_open(name0, opts0)
      nvim.set_current_win(get_term_win(name0))
      return vim.cmd("startinsert")
    end
    v_0_0 = term_focus0
    _0_["term_focus"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["term_focus"] = v_0_
  term_focus = v_0_
end
local trim_with_pos
do
  local v_0_
  local function trim_with_pos0(str)
    local line = s.trim(str)
    local _, start_pos = string.find(str, "^%s*(.-)")
    local end_pos = (#line + start_pos)
    return {line, start_pos, end_pos}
  end
  v_0_ = trim_with_pos0
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["trim-with-pos"] = v_0_
  trim_with_pos = v_0_
end
local highlight
do
  local v_0_
  local function highlight0(start, _end, rtype)
    local ns = nvim.create_namespace("")
    local buf = nvim.get_current_buf()
    local rtype0 = (rtype or "c")
    vim.highlight.range(buf, ns, "IncSearch", start, _end, rtype0)
    local function _3_()
      return nvim.buf_clear_namespace(buf, ns, a.first(start), a.inc(a.first(_end)))
    end
    return vim.defer_fn(_3_, 500)
  end
  v_0_ = highlight0
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["highlight"] = v_0_
  highlight = v_0_
end
local term_send_cur_line
do
  local v_0_
  do
    local v_0_0
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
    _0_["term_send_cur_line"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["term_send_cur_line"] = v_0_
  term_send_cur_line = v_0_
end
-- (init) (get-terms) (term_toggle) (term_send ls) (term_send ls foo) (term_send_cur_line) (term-open) (term-close) (term-stop) (get-term-win default) (tab-get-open-terms) (get-terms) (term-open) (term-open foo) (term-open bar) (nvim.set_current_win 1318) (term_send sleep 1; true default table: 0x7ffff7a1b7a0) (term_send sleep 2; false default)
return nil