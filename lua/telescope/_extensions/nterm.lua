local _2afile_2a = "/nix/store/hd176n5x6v7zfmmaiyxcgdwph7r61yn0-source/src/telescope/_extensions/nterm.fnl"
local _0_
do
  local name_0_ = "telescope._extensions.nterm"
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
    return {require("aniseed.core"), require("telescope.actions"), require("telescope.actions.state"), require("telescope.command"), require("telescope.config"), require("telescope.pickers.entry_display"), require("telescope.finders"), require("nterm.main"), require("telescope.pickers"), require("telescope.previewers"), require("telescope.previewers.utils"), require("telescope.sorters"), require("telescope.state"), require("telescope"), require("telescope.utils")}
  end
  ok_3f_0_, val_0_ = pcall(_2_)
  if ok_3f_0_ then
    _0_["aniseed/local-fns"] = {require = {a = "aniseed.core", actions = "telescope.actions", actions_state = "telescope.actions.state", c = "telescope.command", conf = "telescope.config", entry_display = "telescope.pickers.entry_display", finders = "telescope.finders", nterm = "nterm.main", pickers = "telescope.pickers", previewers = "telescope.previewers", putils = "telescope.previewers.utils", sorters = "telescope.sorters", state = "telescope.state", telescope = "telescope", utils = "telescope.utils"}}
    return val_0_
  else
    return print(val_0_)
  end
end
local _local_0_ = _2_(...)
local a = _local_0_[1]
local previewers = _local_0_[10]
local putils = _local_0_[11]
local sorters = _local_0_[12]
local state = _local_0_[13]
local telescope = _local_0_[14]
local utils = _local_0_[15]
local actions = _local_0_[2]
local actions_state = _local_0_[3]
local c = _local_0_[4]
local conf = _local_0_[5]
local entry_display = _local_0_[6]
local finders = _local_0_[7]
local nterm = _local_0_[8]
local pickers = _local_0_[9]
local _2amodule_2a = _0_
local _2amodule_name_2a = "telescope._extensions.nterm"
do local _ = ({nil, _0_, nil, {{}, nil, nil, nil}})[2] end
local nterm_finder
do
  local v_0_
  do
    local v_0_0
    local function nterm_finder0(user_opts)
      local opts = (user_opts or {})
      local config
      local function _3_(bufnr, map)
        local function _4_(_, cmd)
          actions.close(bufnr)
          return nterm["term-open"](a.get(actions_state.get_selected_entry(), "display"))
        end
        local function _5_()
          actions.close(bufnr)
          return nterm["term-open"](actions_state.get_current_line())
        end
        do end (actions.select_default):replace(_4_, map("i", "<c-e>", _5_))
        return true
      end
      local function _4_(line)
        return {display = line, ordinal = a["get-in"](nterm["get-terms"](), line, "buf")}
      end
      config = {attach_mappings = _3_, finder = finders.new_table({entry_maker = _4_, results = a.keys(nterm["get-terms"]())}), prompt_title = "nterm", sorter = conf.values.generic_sorter()}
      return pickers.new(opts, config):find()
    end
    v_0_0 = nterm_finder0
    _0_["nterm-finder"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["nterm-finder"] = v_0_
  nterm_finder = v_0_
end
local function _3_(_241)
  local opts = (_241 or {})
  return nterm_finder(opts)
end
return telescope.register_extension({exports = {nterm = _3_}})