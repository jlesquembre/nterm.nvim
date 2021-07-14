local _2afile_2a = "/nix/store/hd176n5x6v7zfmmaiyxcgdwph7r61yn0-source/src/nterm/server.fnl"
local _0_
do
  local name_0_ = "nterm.server"
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
    return {require("aniseed.core"), require("aniseed.nvim"), require("aniseed.string")}
  end
  ok_3f_0_, val_0_ = pcall(_2_)
  if ok_3f_0_ then
    _0_["aniseed/local-fns"] = {require = {a = "aniseed.core", nvim = "aniseed.nvim", s = "aniseed.string"}}
    return val_0_
  else
    return print(val_0_)
  end
end
local _local_0_ = _2_(...)
local a = _local_0_[1]
local nvim = _local_0_[2]
local s = _local_0_[3]
local _2amodule_2a = _0_
local _2amodule_name_2a = "nterm.server"
do local _ = ({nil, _0_, nil, {{}, nil, nil, nil}})[2] end
local conn_handler
do
  local v_0_
  local function conn_handler0(f)
    local function _3_(sock)
      local function _4_(err, data)
        if data then
          local function _5_()
            return f(data)
          end
          vim.schedule(_5_)
          return sock:write("OK")
        else
          return sock:close()
        end
      end
      return sock:read_start(_4_)
    end
    return _3_
  end
  v_0_ = conn_handler0
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["conn-handler"] = v_0_
  conn_handler = v_0_
end
local create_server
do
  local v_0_
  do
    local v_0_0
    local function create_server0(host, port, f)
      local server = vim.loop.new_tcp()
      server:bind(host, port)
      local function _3_(err)
        local sock = vim.loop.new_tcp()
        local on_connect = conn_handler(f)
        server:accept(sock)
        return on_connect(sock)
      end
      server:listen(128, _3_)
      return server
    end
    v_0_0 = create_server0
    _0_["create-server"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["create-server"] = v_0_
  create_server = v_0_
end
-- (print (.. TCP server on port  (a.get (server:getsockname) port))) (server:close)
return nil