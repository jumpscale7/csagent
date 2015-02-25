--
-- The parsing of CLI arguments.
--

local args = {}

require('pl.stringx').import()

--
-- Parses the given table of system-provided CLI arguments and returns a table with that useful
-- information if they were correctly provided, and an error if any.
--
-- Returns: {
--    gid = ...,
--    agentcontroller_jsonrpc_url = ...,
--    roles = ...,
-- }, err
--
--
function args.parse(arg, silent_error)

  package.loaded['cliargs'] = nil
  local cli = require 'cliargs'

  cli:set_name('csagent')

  cli:add_argument('GID', 'ID of your grid')

  cli:add_option('-c AGENTCONTROLLER_JSONRPC_URL', 'the JSONRPC URL to AgentController', 'http://localhost:4444')

  cli:add_option('-r ROLES_CSV', 'comma-separated list of roles', 'csagent')

  local parsed, err = cli:parse(arg, silent_error)

  if err then
    return _, err
  end

  return {
    gid = tonumber(parsed.GID),
    agentcontroller_jsonrpc_url = parsed.c,
    roles = parsed.r:split(',')
  }
end

return args