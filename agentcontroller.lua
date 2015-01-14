--
-- A proxy for a remote Agent Controller instance.
--

json.rpc = require('json.rpc')
module('agentcontroller', package.seeall)

--
-- Constructs a client for an Agent Controller and returns it.
--
-- Args:
--   url: the url to JSON-RPC endpoint for the Agent Controller
--
-- Returns:
--   A proxy client that Agent Controller RPC methods can be called on
--
function connect_to(url)
    local url = url or 'http://localhost:4444'
    return AgentController:new(url)
end

AgentController = {}

function AgentController:__index(method_name)
    return function(...)
        return json.rpc.call(self.__url, 'agent.' .. method_name, ...)
    end
end

function AgentController:new(url)
    local object = {__url = url}
    setmetatable(object, AgentController)
    return object
end