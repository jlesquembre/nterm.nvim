local _2afile_2a = "/nix/store/02ncnrv0wjaadw8nv406wqvcrs27i3dr-source/src/telescope/_extensions/nterm.fnl"
local _2amodule_name_2a = "telescope._extensions.nterm"
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
local a, actions, actions_state, c, conf, entry_display, finders, nterm, pickers, previewers, putils, sorters, state, telescope, utils = require("aniseed.core"), require("telescope.actions"), require("telescope.actions.state"), require("telescope.command"), require("telescope.config"), require("telescope.pickers.entry_display"), require("telescope.finders"), require("nterm.main"), require("telescope.pickers"), require("telescope.previewers"), require("telescope.previewers.utils"), require("telescope.sorters"), require("telescope.state"), require("telescope"), require("telescope.utils")
do end (_2amodule_locals_2a)["a"] = a
_2amodule_locals_2a["actions"] = actions
_2amodule_locals_2a["actions_state"] = actions_state
_2amodule_locals_2a["c"] = c
_2amodule_locals_2a["conf"] = conf
_2amodule_locals_2a["entry_display"] = entry_display
_2amodule_locals_2a["finders"] = finders
_2amodule_locals_2a["nterm"] = nterm
_2amodule_locals_2a["pickers"] = pickers
_2amodule_locals_2a["previewers"] = previewers
_2amodule_locals_2a["putils"] = putils
_2amodule_locals_2a["sorters"] = sorters
_2amodule_locals_2a["state"] = state
_2amodule_locals_2a["telescope"] = telescope
_2amodule_locals_2a["utils"] = utils
local function nterm_finder(user_opts)
  local opts = (user_opts or {})
  local config
  local function _1_(line)
    return {ordinal = a["get-in"](nterm["get-terms"](), line, "buf"), display = line}
  end
  local function _2_(bufnr, map)
    local function _3_(_, cmd)
      actions.close(bufnr)
      return nterm["term-open"](a.get(actions_state.get_selected_entry(), "display"))
    end
    local function _4_()
      actions.close(bufnr)
      return nterm["term-open"](actions_state.get_current_line())
    end
    local function _5_()
      actions.close(bufnr)
      return nterm.term_focus(a.get(actions_state.get_selected_entry(), "display"))
    end
    do end (actions.select_default):replace(_3_, map("i", "<c-e>", _4_), map("i", "<c-f>", _5_))
    return true
  end
  config = {prompt_title = "nterm", finder = finders.new_table({results = a.keys(nterm["get-terms"]()), entry_maker = _1_}), attach_mappings = _2_, sorter = conf.values.generic_sorter()}
  return pickers.new(opts, config):find()
end
_2amodule_2a["nterm-finder"] = nterm_finder
local function _6_(_241)
  local opts = (_241 or {})
  return nterm_finder(opts)
end
return telescope.register_extension({exports = {nterm = _6_}})