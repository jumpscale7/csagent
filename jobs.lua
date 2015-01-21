
local log = require 'log'
local dir = require 'pl.dir'
local path = require 'pl.path'
local json = require 'json'

local jobs = {}

--
-- Interprets the given job description and returns a callable that executes the logic associated
-- with the job description received.
--
-- Args:
--  job_description: the job description table as received from the Agent Controlle
--  internal_command_handler: a table mapping internal command names to callables that execute them
--  jumpscripts_path: a str path of where the Lua Jumpscripts are stored on the local filesystem
--
function jobs.interpret(job_description, internal_command_handlers, jumpscripts_path)
  assert(job_description)
  assert(internal_command_handlers)

  local organization = job_description.category
  local name = job_description.cmd
  local args = job_description.args

  if organization == 'pm' then
    log('Received internal command: ' .. name)
    return internal_command_handlers[name]
  else
    log('Executing the jumpscript ' .. organization .. '.' .. name .. ' with args ' .. json.encode(args))
    -- Locate a jumpscript handler and return a callable executing it with its arguments
    return function() return jobs.__jumpscript_handler(organization, name, jumpscripts_path)(args) end
  end
end

--
-- Locates the corresponding jumpscript, loads it and returns the main function as a callable that accepts
-- the jumpscript main function's keyword argument table.
--
function jobs.__jumpscript_handler(organization, name, jumpscripts_path)
  assert(organization)
  assert(name)
  assert(jumpscripts_path)

  local lua_jumpscripts_path = path.join(jumpscripts_path, 'luajumpscripts', organization)

  for root, _, files in dir.walk(lua_jumpscripts_path) do
    for _, file_name in pairs(files) do
      local extensionless_file_name, extension = path.splitext(file_name)
      if extension == '.lua' and extensionless_file_name == name then
        local jumpscript_path = path.join(root, file_name)
        local jumpscript_module = loadfile(jumpscript_path)()
        return function(args) return jumpscript_module.main(args) end
      end
    end
  end

  error('Could not find a jumpscript for ' .. organization .. '.' .. name)
end

return jobs