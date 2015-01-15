--
-- A proxy for a remote Agent Controller instance.
--

json = require('json')
json.rpc = require('json.rpc')
socket = require('socket')
uuid = require('uuid'); uuid.seed() -- Must be seeded somewhere after require('socket')
netinfo = require('netinfo')

M = {}

--
-- Constructs a client for an Agent Controller and returns it.
--
-- Args:
--   url: the url to JSON-RPC endpoint for the Agent Controller
--   roles: an array of node roles
--   gid:
--   nid:
--   username:
--   password:
--   organization:
--
-- Returns:
--   A proxy client that Agent Controller RPC methods can be called on
--
function M.connect_to(url, roles, gid, nid, password, username, organization)

    local url = url or 'http://localhost:4444'

    local function init_session()
        local session_data = {
            roles = roles,
            gid = gid,
            nid = nid,
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
        if err then
            error(err)
        else
            return session_data.id
        end
    end

   local session_id = init_session()
   return M.AgentController:new(url, session_id)
end

M.AgentController = {}

function M.AgentController:__index(method_name)
    return function(...)
        local params = ...
        params.sessionid = self.__session_id
        return json.rpc.call(self.__url, 'agent.' .. method_name, params)
    end
end

function M.AgentController:new(url, session_id)
    local object = {__url = url, __session_id = session_id}
    setmetatable(object, M.AgentController)
    return object
end

return M