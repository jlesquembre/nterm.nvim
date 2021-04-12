local _0_0 = nil
do
  local name_0_ = "nterm.server-utils"
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
local _2amodule_name_2a = "nterm.server-utils"
do local _ = ({nil, _0_0, {{}, nil, nil, nil}})[2] end
local conn_handler = nil
do
  local v_0_ = nil
  local function conn_handler0(f)
    local function _2_(sock)
      local function _3_(err, data)
        if data then
          local function _4_()
            return f(data)
          end
          vim.schedule(_4_)
          return sock:write("OK")
        else
          return sock:close()
        end
      end
      return sock:read_start(_3_)
    end
    return _2_
  end
  v_0_ = conn_handler0
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["conn-handler"] = v_0_
  conn_handler = v_0_
end
local create_server = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function create_server0(host, port, f)
      local server = vim.loop.new_tcp()
      server:bind(host, port)
      local function _2_(err)
        local sock = vim.loop.new_tcp()
        local on_connect = conn_handler(f)
        server:accept(sock)
        return on_connect(sock)
      end
      server:listen(128, _2_)
      return server
    end
    v_0_0 = create_server0
    _0_0["create-server"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["create-server"] = v_0_
  create_server = v_0_
end
-- (print (.. TCP server on port  (a.get (server:getsockname) port))) (server:close)
return nil