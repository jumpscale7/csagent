
local socket = require 'socket'
local lfs = require 'lfs'
local tar = require 'luarocks.tools.tar'
local basexx = require 'basexx'
local jobs = require 'jobs'
local log = require 'log'
local utils = require 'utils'
local args = require 'args'

-- CS Agent Configuration parameters
local CONFIG = {
  AGENT_CONTROLLER_JSONRPC_URL = nil,      -- To be filled in later
  HOSTNAME = socket.dns.gethostname(),
  MACHINE_GUID = '080027534560183b86',     -- TODO: Needs to be dynamically determined
  USERNAME = 'root',                       -- TODO: this should be the literal 'node'
  PASSWORD = 'passwd',                     -- TODO: this should be the machine GUID
  ORGANIZATION = 'jumpscale',
  ROLES = nil,        -- To be filled in later
  GID = nil,          -- To be filled in later
  WORKING_DIRECTORY = '/tmp/' .. 'csagent-' .. tostring(os.time()),
}

local function application_init()

  -- Create working directory
  lfs.mkdir(CONFIG.WORKING_DIRECTORY)
  log('Working directory is ' .. CONFIG.WORKING_DIRECTORY, log.DEBUG)

end

--
-- Registers self on the Agent Controller.
--
-- Returns:
--  A table containing the node definition as acknowledged by the Agent Controller.
--
-- Raises an error on communication error.
--
local function register_node(agent_controller_session)
  local result = agent_controller_session.registerNode{hostname = CONFIG.HOSTNAME, machineguid = CONFIG.MACHINE_GUID}
  return result.node
end

--
-- Downloads the available jumpscripts from the AgentController to the local filesystem.
--
-- Returns:
--  The path where the jumpscripts are downloaded to
--
-- Raises an error on communication errors.
--
local function download_jumpscripts(agent_controller_session)

  local jumpscripts_tar_b64 = agent_controller_session.getJumpscripts{bz2_compressed=false, types={'luajumpscripts'}}  -- TAR content in Base64

  log('Received ' .. tostring(#jumpscripts_tar_b64) .. ' bytes of jumpscript base64 tar goodness', log.DEBUG)

  local jumpscripts_tar = basexx.from_base64(jumpscripts_tar_b64)

  -- Create the local path where the jumpscript files will be stored.
  local jumpscripts_tar_path = CONFIG.WORKING_DIRECTORY .. '/jumpscripts.tar'
  local fp = io.open(jumpscripts_tar_path, 'wb')
  assert(fp)
  fp:write(jumpscripts_tar)
  fp:close()

  local jumpscripts_path = CONFIG.WORKING_DIRECTORY .. '/jumpscripts/'
  tar.untar(jumpscripts_tar_path, jumpscripts_path)

  return jumpscripts_path
end

--
-- Polls on work from the Agent Controller ad infinitum.
--
-- Args:
--  agent_controller_session: an agentcontroller.AgentController object
--  jumpscripts_path: a str path of where the Lua Jumpscripts are stored on the local filesystem
--
local function poll_for_work(agent_controller_session, jumpscripts_path)

  local internal_commands = {
      stop = function() os.exit(0) end,
      reloadjumpscripts = function() return download_jumpscripts(agent_controller_session) end,
  }

  while true do

     log 'Polling for work..'
     local job_description = agent_controller_session.getWork()

     if job_description then     -- Why does the client unblock with a nil response? TCP timed out?

         local job = jobs.interpret(job_description, internal_commands, jumpscripts_path)

          local execution_success, execution_result = xpcall(job, debug.traceback)

          if execution_success then
              -- Execution OK
              job_description.state = 'OK'
          else
              -- Execution failed
              job_description.state = 'ERROR'
          end
          job_description.result = execution_result   -- Success result or error message

          -- Execute the work

          agent_controller_session.notifyWorkCompleted{job = job_description}
      end
  end
end

--
-- The main application logic.
--
-- Raises an error on communication error.
--
function main()

  -- Get missing CONFIG entries from CLI args
  local cli_args, err = args.parse(arg)
  if err then
    os.exit(1)
  end
  CONFIG.GID = cli_args.gid
  CONFIG.ROLES = cli_args.roles
  CONFIG.AGENT_CONTROLLER_JSONRPC_URL = cli_args.agentcontroller_jsonrpc_url

  -- Engage!

  local agentcontroller = require('agentcontroller')

  log 'Initiating a communication session with Agent Controller...'
  local ac_session = agentcontroller.connect_to(
      CONFIG.AGENT_CONTROLLER_JSONRPC_URL,
      CONFIG.ROLES,
      CONFIG.GID,
      CONFIG.MACHINE_GUID,
      CONFIG.ORGANIZATION
  )

  log 'Initiating application logic'
  application_init()

  local node = register_node(ac_session)
  log('Session registered on AgentController successfully with Node ID: ' .. node.id)

  log 'Downloading the jumpscripts from AgentController...'
  local jumpscripts_path = download_jumpscripts(ac_session)
  log('Jumpscripts downloaded to ' .. jumpscripts_path)

  log 'Entering work polling loop'
  poll_for_work(ac_session, jumpscripts_path)

  log 'Bye!'
end

local function robust_main()

  local function on_error(err)
    log(err .. ' Resetting the application in 5 seconds...', FATAL)
    utils.sleep(5)
    print '--------------------------------------------------------------------'
    return robust_main()
  end

  local success, err = pcall(main)
  if not success then return on_error(err) end
end

-- Execute robust_main() as the application entry point
robust_main()
