--
-- A proxy for a remote Agent Controller instance.
--

local json = require('json')
require 'json.rpc'
local socket = require 'socket'
local uuid = require 'uuid'; uuid.seed() -- Must be seeded somewhere after require('socket')
local netinfo = require('netinfo')

local agentcontroller = {}

--
-- Constructs a client for an Agent Controller and returns it.
--
-- Args:
--   url: the url to JSON-RPC endpoint for the Agent Controller
--   roles: an array of node roles
--   gid:
--   username:
--   password:
--   organization:
--
-- Returns:
--   A proxy client that Agent Controller RPC methods can be called on
--
-- Raises an error on communication error.
--
function agentcontroller.connect_to(url, roles, gid, password, username, organization)

  assert(url)
  assert(roles)
  assert(gid)

    local url = url or 'http://localhost:4444'

    local function init_session()
        print('THE GID IS ' .. gid)
        local session_data = {
            roles = roles,
            gid = gid,
            encrkey = '',
            start = os.time(),
            netinfo = netinfo(),
            user = username,
            passwd = password,
            organization = organization,
            id = uuid(),
        }

        local result, err =
        json.rpc.call(url, 'core.registersession', {sessiondata = session_data, ssl=false, session=false})

        if err then error(err) else return session_data.id end
    end

    local session_id = init_session()
    return agentcontroller.AgentController:new(url, session_id)
end

agentcontroller.AgentController = {}

function agentcontroller.AgentController:__index(method_name)
    return function(...)
        local params = ... or {}
        params.sessionid = self.__session_id
        local result, err = json.rpc.call(self.__url, 'agent.' .. method_name, params)
        if err then error(err) else return result end
    end
end

function agentcontroller.AgentController:new(url, session_id)
    local object = {__url = url, __session_id = session_id}
    setmetatable(object, agentcontroller.AgentController)
    return object
end

return agentcontroller