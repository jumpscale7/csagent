
local socket = require 'socket'
local lfs = require 'lfs'
local tar = require 'luarocks.tools.tar'
basexx = require 'basexx'

-- CS Agent Configuration parameters
local CONFIG = {
    AGENT_CONTROLLER_JSONRPC_URL = 'http://localhost:4444',
    HOSTNAME = socket.dns.gethostname(),
    MACHINE_GUID = '080027534560183b86',     -- TODO: Needs to be dynamically determined
    USERNAME = 'root',
    PASSWORD = 'passwd',
    ORGANIZATION = 'myorg',
    ROLES = {'csagent'},
    GID = 0,
    NID = 5,
    WORKING_DIRECTORY = '/tmp/' .. 'csagent-' .. tostring(os.time()),
}

local function log(...)
    print(...)
end

local function application_init()

    log 'Initiating application logic'

    -- Create working directory
    lfs.mkdir(CONFIG.WORKING_DIRECTORY)
    log('Working directory is ' .. CONFIG.WORKING_DIRECTORY)

    log '---------------------'
end

--
-- Registers self on the Agent Controller.
--
-- Crashes on communication error.
--
-- Returns:
--  A table containing the node definition as acknowledged by the Agent Controller.
--
local function register_node(agent_controller_session)
    local result, err = agent_controller_session.registerNode{hostname = CONFIG.HOSTNAME, machineguid = CONFIG.MACHINE_GUID }
    if err then error(err) end
    log 'Sssion registered on AgentController successfully'
    return result.node
end

--
-- Downloads the available jumpscripts from the AgentController to the local filesystem.
--
-- Returns the path where the jumpscripts are downloaded to.
--
-- Crashes on communication error.
--
local function download_jumpscripts(agent_controller_session)

    log 'Downloading the jumpscripts from AgentController...'

    local jumpscripts_tar_b64, err = agent_controller_session.getAllJumpscripts{bz2_compressed=false}  -- TAR content in Base64
    if err then error(err) end

    log('Received ' .. tostring(#jumpscripts_tar_b64) .. ' bytes of jumpscript bae64 tar goodness')

    local jumpscripts_tar = basexx.from_base64(jumpscripts_tar_b64)

    -- Create the local path where the jumpscript files will be stored.
    local jumpscripts_tar_path = CONFIG.WORKING_DIRECTORY .. '/jumpscripts.tar'
    local fp = io.open(jumpscripts_tar_path, 'wb')
    assert(fp)
    fp:write(jumpscripts_tar)
    fp:close()

    local jumpscripts_path = CONFIG.WORKING_DIRECTORY .. '/jumpscripts/'
    tar.untar(jumpscripts_tar_path, jumpscripts_path)
    log('The jumpscripts are available locally at ' .. jumpscripts_path)

    return jumpscripts_path
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

application_init()
register_node(ac_session)
download_jumpscripts(ac_session)
log 'Bye!'

-- TODO: Rest of the application logic
