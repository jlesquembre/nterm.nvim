local _2afile_2a = "/nix/store/02ncnrv0wjaadw8nv406wqvcrs27i3dr-source/src/nterm/server.fnl"
local _2amodule_name_2a = "nterm.server"
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
local a, nvim, s = require("aniseed.core"), require("aniseed.nvim"), require("aniseed.string")
do end (_2amodule_locals_2a)["a"] = a
_2amodule_locals_2a["nvim"] = nvim
_2amodule_locals_2a["s"] = s
local function conn_handler(f)
  local function _1_(sock)
    local function _2_(err, data)
      if data then
        local function _3_()
          return f(data)
        end
        vim.schedule(_3_)
        return sock:write("OK")
      else
        return sock:close()
      end
    end
    return sock:read_start(_2_)
  end
  return _1_
end
_2amodule_locals_2a["conn-handler"] = conn_handler
local function create_server(host, port, f)
  local server = vim.loop.new_tcp()
  server:bind(host, port)
  local function _5_(err)
    local sock = vim.loop.new_tcp()
    local on_connect = conn_handler(f)
    server:accept(sock)
    return on_connect(sock)
  end
  server:listen(128, _5_)
  return server
end
_2amodule_2a["create-server"] = create_server
--[[ (print (.. "TCP server on port " (a.get (server:getsockname) "port"))) (server:close) ]]--
return nil