local _2afile_2a = "/nix/store/imagl8m19a5j9370629sqa0ip1pcgr9w-source/src/telescope/_extensions/nterm.fnl"
local _1_
do
  local name_4_auto = "telescope._extensions.nterm"
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
    return {require("aniseed.core"), require("telescope.actions"), require("telescope.actions.state"), require("telescope.command"), require("telescope.config"), require("telescope.pickers.entry_display"), require("telescope.finders"), require("nterm.main"), require("telescope.pickers"), require("telescope.previewers"), require("telescope.previewers.utils"), require("telescope.sorters"), require("telescope.state"), require("telescope"), require("telescope.utils")}
  end
  ok_3f_21_auto, val_22_auto = pcall(_5_)
  if ok_3f_21_auto then
    _1_["aniseed/local-fns"] = {require = {a = "aniseed.core", actions = "telescope.actions", actions_state = "telescope.actions.state", c = "telescope.command", conf = "telescope.config", entry_display = "telescope.pickers.entry_display", finders = "telescope.finders", nterm = "nterm.main", pickers = "telescope.pickers", previewers = "telescope.previewers", putils = "telescope.previewers.utils", sorters = "telescope.sorters", state = "telescope.state", telescope = "telescope", utils = "telescope.utils"}}
    return val_22_auto
  else
    return print(val_22_auto)
  end
end
local _local_4_ = _6_(...)
local a = _local_4_[1]
local previewers = _local_4_[10]
local putils = _local_4_[11]
local sorters = _local_4_[12]
local state = _local_4_[13]
local telescope = _local_4_[14]
local utils = _local_4_[15]
local actions = _local_4_[2]
local actions_state = _local_4_[3]
local c = _local_4_[4]
local conf = _local_4_[5]
local entry_display = _local_4_[6]
local finders = _local_4_[7]
local nterm = _local_4_[8]
local pickers = _local_4_[9]
local _2amodule_2a = _1_
local _2amodule_name_2a = "telescope._extensions.nterm"
do local _ = ({nil, _1_, nil, {{}, nil, nil, nil}})[2] end
local nterm_finder
do
  local v_23_auto
  do
    local v_25_auto
    local function nterm_finder0(user_opts)
      local opts = (user_opts or {})
      local config
      local function _8_(bufnr, map)
        local function _9_(_, cmd)
          actions.close(bufnr)
          return nterm["term-open"](a.get(actions_state.get_selected_entry(), "display"))
        end
        local function _10_()
          actions.close(bufnr)
          return nterm["term-open"](actions_state.get_current_line())
        end
        local function _11_()
          actions.close(bufnr)
          return nterm.term_focus(a.get(actions_state.get_selected_entry(), "display"))
        end
        do end (actions.select_default):replace(_9_, map("i", "<c-e>", _10_), map("i", "<c-f>", _11_))
        return true
      end
      local function _12_(line)
        return {display = line, ordinal = a["get-in"](nterm["get-terms"](), line, "buf")}
      end
      config = {attach_mappings = _8_, finder = finders.new_table({entry_maker = _12_, results = a.keys(nterm["get-terms"]())}), prompt_title = "nterm", sorter = conf.values.generic_sorter()}
      return pickers.new(opts, config):find()
    end
    v_25_auto = nterm_finder0
    _1_["nterm-finder"] = v_25_auto
    v_23_auto = v_25_auto
  end
  local t_24_auto = (_1_)["aniseed/locals"]
  t_24_auto["nterm-finder"] = v_23_auto
  nterm_finder = v_23_auto
end
local function _13_(_241)
  local opts = (_241 or {})
  return nterm_finder(opts)
end
return telescope.register_extension({exports = {nterm = _13_}})