local _2afile_2a = "/nix/store/imagl8m19a5j9370629sqa0ip1pcgr9w-source/src/nterm/server.fnl"
local _1_
do
  local name_4_auto = "nterm.server"
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
local _2amodule_name_2a = "nterm.server"
do local _ = ({nil, _1_, nil, {{}, nil, nil, nil}})[2] end
local conn_handler
do
  local v_23_auto
  local function conn_handler0(f)
    local function _8_(sock)
      local function _9_(err, data)
        if data then
          local function _10_()
            return f(data)
          end
          vim.schedule(_10_)
          return sock:write("OK")
        else
          return sock:close()
        end
      end
      return sock:read_start(_9_)
    end
    return _8_
  end
  v_23_auto = conn_handler0
  local t_24_auto = (_1_)["aniseed/locals"]
  t_24_auto["conn-handler"] = v_23_auto
  conn_handler = v_23_auto
end
local create_server
do
  local v_23_auto
  do
    local v_25_auto
    local function create_server0(host, port, f)
      local server = vim.loop.new_tcp()
      server:bind(host, port)
      local function _12_(err)
        local sock = vim.loop.new_tcp()
        local on_connect = conn_handler(f)
        server:accept(sock)
        return on_connect(sock)
      end
      server:listen(128, _12_)
      return server
    end
    v_25_auto = create_server0
    _1_["create-server"] = v_25_auto
    v_23_auto = v_25_auto
  end
  local t_24_auto = (_1_)["aniseed/locals"]
  t_24_auto["create-server"] = v_23_auto
  create_server = v_23_auto
end
-- (print (.. "TCP server on port " (a.get (server:getsockname) "port"))) (server:close)
return nil