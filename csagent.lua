
local socket = require('socket')

-- CS Agent Configuration parameters
local CONFIG = {
    AGENT_CONTROLLER_JSONRPC_URL = 'http://localhost:4444',
    HOSTNAME = socket.dns.gethostname(),
    MACHINE_GUID = '080027534560183b86',     -- TODO: Needs to be dynamically determined
    USERNAME = 'root',
    PASSWORD = 'passwd',
    ORGANIZATION = 'myorg',
    ROLES = {},
    GID = 0,
    NID = 1,
    WEBDIS_KEY = nil,       -- To be filled in later in the application
}

--
-- Registers self on the Agent Controller.
--
-- Crashes on communication error.
--
-- Returns:
--  A table containing the node data retrieved from Agent Conroller, keys include {webdis_key,}
--
local function register_node(agent_controller_session)
    local result, err = agent_controller_session.registerNode{hostname = CONFIG.HOSTNAME, machineguid = CONFIG.MACHINE_GUID }
    if err then error(err) end
    return {webdis_key = result.webdiskey}
end


-- Main Application logic

local agentcontroller = require('agentcontroller')
local ac_session = agentcontroller.connect_to(
    CONFIG.AGENT_CONTROLLER_JSONRPC_URL,
    CONFIG.ROLES,
    CONFIG.GID,
    CONFIG.NID,
    CONFIG.PASSWORD,
    CONFIG.USERNAME,
    CONFIG.ORGANIZATION
)

ac_data = register_node(ac_session)
CONFIG.WEBDIS_KEY = ac_data.webdis_key

-- TODO: Rest of the application logic
