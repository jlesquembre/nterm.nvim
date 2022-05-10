local _2afile_2a = "/nix/store/slv17irph93vfbqs49mlgdn5m7zh0ssi-source/src/nterm/main.fnl"
local _2amodule_name_2a = "nterm.main"
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
local a, nvim, s, server_utils, ui = require("aniseed.core"), require("aniseed.nvim"), require("aniseed.string"), require("nterm.server"), require("nterm.ui")
do end (_2amodule_locals_2a)["a"] = a
_2amodule_locals_2a["nvim"] = nvim
_2amodule_locals_2a["s"] = s
_2amodule_locals_2a["server-utils"] = server_utils
_2amodule_locals_2a["ui"] = ui
local filetype = "nterm"
_2amodule_2a["filetype"] = filetype
local terms = ((_2amodule_2a).terms or {})
do end (_2amodule_2a)["terms"] = terms
local options = {maps = true, size = 20, direction = "horizontal", shell = "fish", popup = 2000, popup_pos = "NE", autoclose = 2000}
_2amodule_2a["options"] = options
local loaded_3f = false
_2amodule_locals_2a["loaded?"] = loaded_3f
local function get_terms()
  return terms
end
_2amodule_2a["get-terms"] = get_terms
local function get_term_by_buf(buf_id)
  local term_info
  local function _1_(_241)
    if (buf_id == a.get(_241, "buf")) then
      return _241
    else
      return nil
    end
  end
  term_info = a.some(_1_, a.vals(get_terms()))
  return a.get(term_info, "name")
end
_2amodule_locals_2a["get-term-by-buf"] = get_term_by_buf
local function tab_get_open_terms()
  local function _3_(_241)
    return (filetype == nvim.buf_get_option(_241, "filetype"))
  end
  local function _4_(_241)
    return nvim.win_get_buf(_241)
  end
  return a.map(get_term_by_buf, a.filter(_3_, a.map(_4_, nvim.tabpage_list_wins(0))))
end
_2amodule_locals_2a["tab-get-open-terms"] = tab_get_open_terms
local function get_term_win(name)
  local name0 = (name or "default")
  local buf_id = a["get-in"](terms, {name0, "buf"})
  local wins = nvim.tabpage_list_wins(0)
  local function _5_(_241)
    local buf = nvim.win_get_buf(_241)
    if (buf == buf_id) then
      return _241
    else
      return nil
    end
  end
  return a.some(_5_, wins)
end
_2amodule_locals_2a["get-term-win"] = get_term_win
local function open_window(opts)
  do
    local open_term
    do
      local _7_ = tab_get_open_terms()
      if (nil ~= _7_) then
        local _8_ = a.last(_7_)
        if (nil ~= _8_) then
          open_term = get_term_win(_8_)
        else
          open_term = _8_
        end
      else
        open_term = _7_
      end
    end
    nvim.set_current_win((open_term or 0))
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
  nvim.buf_set_option(buf_id, "buflisted", false)
  return {win_id, buf_id}
end
_2amodule_locals_2a["open-window"] = open_window
local function valid_buf_3f(buf_id)
  if ("number" == type(buf_id)) then
    return nvim.buf_is_valid(buf_id)
  else
    return false
  end
end
_2amodule_locals_2a["valid-buf?"] = valid_buf_3f
local function check_term_21(name)
  local buf_id = a["get-in"](terms, {name, "buf"})
  if not valid_buf_3f(buf_id) then
    return a.assoc(terms, name, nil)
  else
    return nil
  end
end
_2amodule_locals_2a["check-term!"] = check_term_21
local function term_destroy(name)
  do
    local buf_id = a["get-in"](terms, {name, "buf"})
    if valid_buf_3f(buf_id) then
      nvim.buf_delete(buf_id, {force = true})
    else
    end
  end
  return a.assoc(terms, name, nil)
end
_2amodule_locals_2a["term-destroy"] = term_destroy
local function move_cur_bottom_21(name)
  local buf_id = a["get-in"](terms, {name, "buf"})
  local win_id = get_term_win(name)
  local lines = nvim.buf_line_count(buf_id)
  return nvim.win_set_cursor(win_id, {lines, 1})
end
_2amodule_locals_2a["move-cur-bottom!"] = move_cur_bottom_21
local function term_close(name)
  local name0 = (name or "default")
  local win_id = get_term_win(name0)
  if win_id then
    return nvim.win_close(win_id, false)
  else
    return nil
  end
end
_2amodule_2a["term-close"] = term_close
local function term_stop(name)
  term_close(name)
  local name0 = (name or "default")
  local job_id = a["get-in"](terms, {name0, "job"})
  if job_id then
    return vim.fn.jobstop(job_id)
  else
    return nil
  end
end
_2amodule_2a["term-stop"] = term_stop
local shell__3escript_name = {fish = "nterm.fish"}
_2amodule_locals_2a["shell->script-name"] = shell__3escript_name
local function script_path(shell)
  if not nvim.g.nterm_path then
    nvim.command("source ~/projects/nterm.nvim/plugin/nterm_nvim.vim")
  else
  end
  local script = a.get(shell__3escript_name, shell)
  if script then
    return (nvim.g.nterm_path .. "/" .. script)
  else
    return nil
  end
end
_2amodule_locals_2a["script-path"] = script_path
local function show_popup(term_name, exit_code, cmd, opts)
  local timeout = opts.popup
  if (0 < timeout) then
    local ok = (0 == exit_code)
    local msg
    if ok then
      msg = {"OK!", ("Terminal: " .. term_name), ("Cmd: " .. cmd)}
    else
      msg = {("ERROR CODE: " .. exit_code), ("Terminal: " .. term_name), ("Cmd: " .. cmd)}
    end
    local _23_
    if ok then
      _23_ = "NtermSuccess"
    else
      _23_ = "NtermError"
    end
    return ui.popup(msg, {timeout = timeout, pos = opts.popup_pos, hl = _23_})
  else
    return nil
  end
end
_2amodule_locals_2a["show-popup"] = show_popup
local function process_client_response(data)
  local name, exit_code, term_cmd = unpack(s.split(s.trim(data), "\13\n"))
  local exit_code0 = tonumber(exit_code)
  local _let_26_ = a["get-in"](terms, {name, "current-cmd"}, {})
  local cmd = _let_26_["cmd"]
  local opts = _let_26_["opts"]
  local opts0 = a.merge(options, (opts or {}))
  if (cmd == term_cmd) then
    show_popup(name, exit_code0, cmd, opts0)
    a["assoc-in"](terms, {name, "current-cmd"}, nil)
    if ((0 == exit_code0) and (0 < opts0.autoclose)) then
      local function _27_()
        if a["nil?"](a["get-in"](terms, {name, "current-cmd"})) then
          return term_close(name)
        else
          return nil
        end
      end
      vim.defer_fn(_27_, opts0.autoclose)
    else
    end
    return {name = name, code = exit_code0}
  else
    return nil
  end
end
_2amodule_2a["process-client-response"] = process_client_response
local function init_server()
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
_2amodule_2a["init-server"] = init_server
local function term_new(name, opts)
  local _let_32_ = open_window(opts)
  local win_id = _let_32_[1]
  local buf_id = _let_32_[2]
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
  local function _34_()
    return term_destroy(name)
  end
  job_id = vim.fn.termopen(cmd, {on_exit = _34_, env = {SHELL = shell, NTERM_PORT = a.get(nterm_server:getsockname(), "port"), NTERM_NAME = name}})
  nvim.win_set_cursor(win_id, {nvim.buf_line_count(buf_id), 1})
  return a.assoc(terms, name, {name = name, buf = buf_id, cmds = {}, ["current-cmd"] = nil, job = job_id})
end
_2amodule_locals_2a["term-new"] = term_new
local function term_display(name, opts)
  local buf_id = a["get-in"](terms, {name, "buf"})
  local _let_35_ = open_window(opts)
  local win_id = _let_35_[1]
  local old_buf_id = _let_35_[2]
  nvim.command("wincmd p")
  nvim.win_set_buf(win_id, buf_id)
  return nvim.buf_delete(old_buf_id, {})
end
_2amodule_locals_2a["term-display"] = term_display
local function term_open(name, opts)
  local name0 = (name or "default")
  local opts0 = (opts or options)
  local _ = check_term_21(name0)
  local cur_win = nvim.tabpage_get_win(0)
  local term_buf_id = a["get-in"](terms, {name0, "buf"})
  if term_buf_id then
    if not get_term_win(name0) then
      term_display(name0, opts0)
    else
    end
  else
    term_new(name0, opts0)
  end
  return nvim.set_current_win(cur_win)
end
_2amodule_2a["term-open"] = term_open
local function term_toggle(opts)
  local opts0 = a.merge(options, (opts or {}))
  local open_terms = tab_get_open_terms()
  if (0 < a.count(open_terms)) then
    nvim.g._nterm_terms = open_terms
    return a["run!"](term_close, open_terms)
  else
    local function _38_(_241)
      return term_open(_241, opts0)
    end
    return a["run!"](_38_, (nvim.g._nterm_terms or {"default"}))
  end
end
_2amodule_2a["term_toggle"] = term_toggle
local function add_maps()
  local opts = {noremap = true, silent = false}
  nvim.set_keymap("n", "<leader>tt", "<cmd>lua require'nterm.main'.term_toggle()<cr>", opts)
  nvim.set_keymap("n", "<leader>tl", "<cmd>lua require'nterm.main'.term_send_cur_line(nil, {autoclose=0})<cr>", opts)
  return nvim.set_keymap("n", "<leader>tf", "<cmd>lua require'nterm.main'.term_focus()<cr>", opts)
end
_2amodule_2a["add-maps"] = add_maps
local function add_git_maps()
  local opts = {noremap = true, silent = false}
  nvim.set_keymap("n", "<leader>gpp", "<cmd>lua require'nterm.main'.term_send('git push', 'git')<cr>", opts)
  nvim.set_keymap("n", "<leader>gps", "<cmd>lua require'nterm.main'.term_send('git push --set-upstream origin HEAD', 'git')<cr>", opts)
  nvim.set_keymap("n", "<leader>gpf", "<cmd>lua require'nterm.main'.term_send('git push --force-with-lease', 'git')<cr>", opts)
  nvim.set_keymap("n", "<leader>gpt", "<cmd>lua require'nterm.main'.term_send('git push --tags', 'git')<cr>", opts)
  nvim.set_keymap("n", "<leader>gpu", "<cmd>lua require'nterm.main'.term_send('git pull --ff-only', 'git')<cr>", opts)
  return nvim.set_keymap("n", "<leader>gt", "<cmd>lua require'nterm.main'.term_focus('git')<cr>", opts)
end
_2amodule_2a["add-git-maps"] = add_git_maps
local function init(user_options)
  do
    local user_options0 = (user_options or {})
    a["merge!"](options, user_options0)
  end
  if options.maps then
    add_maps()
    add_git_maps()
  else
  end
  init_server()
  local loaded_3f0 = true
  _2amodule_locals_2a["loaded?"] = loaded_3f0
end
_2amodule_2a["init"] = init
local function term_send(cmd, name, opts)
  local name0 = (name or "default")
  local opts0 = a.merge(options, (opts or {}))
  if (false == loaded_3f) then
    init()
  else
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
    else
      return nil
    end
  end
end
_2amodule_2a["term_send"] = term_send
local function term_focus(name, opts)
  local name0 = (name or "default")
  local opts0 = a.merge(options, (opts or {}))
  term_open(name0, opts0)
  nvim.set_current_win(get_term_win(name0))
  return vim.cmd("startinsert")
end
_2amodule_2a["term_focus"] = term_focus
local function trim_with_pos(str)
  local line = s.trim(str)
  local _, start_pos = string.find(str, "^%s*(.-)")
  local end_pos = (#line + start_pos)
  return {line, start_pos, end_pos}
end
_2amodule_locals_2a["trim-with-pos"] = trim_with_pos
local function highlight(start, _end, rtype)
  local ns = nvim.create_namespace("")
  local buf = nvim.get_current_buf()
  local rtype0 = (rtype or "c")
  vim.highlight.range(buf, ns, "IncSearch", start, _end, rtype0)
  local function _44_()
    return nvim.buf_clear_namespace(buf, ns, a.first(start), a.inc(a.first(_end)))
  end
  return vim.defer_fn(_44_, 500)
end
_2amodule_locals_2a["highlight"] = highlight
local function term_send_cur_line(name, opts)
  local line_nr = a.dec(vim.fn.line("."))
  local _let_45_ = trim_with_pos(nvim.get_current_line())
  local line = _let_45_[1]
  local col_start = _let_45_[2]
  local col_end = _let_45_[3]
  highlight({line_nr, col_start}, {line_nr, col_end})
  return term_send(line, name, opts)
end
_2amodule_2a["term_send_cur_line"] = term_send_cur_line
--[[ (init) (get-terms) (term_toggle) (term_send "ls") (term_send "ls" "foo") (term_send_cur_line) (term-open) (term-close) (term-stop) (get-term-win "default") (tab-get-open-terms) (get-terms) (term-open) (term-open "foo") (term-open "bar") (nvim.set_current_win 1318) (term_send "sleep 1; true" "default" {:autoclose 1000 :popup 1000 :popup_pos "NW"}) (term_send "sleep 2; false" "default") ]]--
return _2amodule_2a