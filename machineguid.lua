
-- Calling this module returns a globally unique identifier of the host machine that should never change for the
-- same installation.

local socket = require 'socket' -- Required by UUID
local uuid = require 'uuid'; uuid.seed() -- Must be seeded somewhere after require('socket')

local datafile = require 'datafile'
local xdg_datafile_opener = require 'datafile.openers.xdg'
datafile.openers = {xdg_datafile_opener.opener}   -- We're only interested in the XDG BaseDirectory scheme
local file = require 'pl.file'
local dir = require 'pl.dir'

local function get_cached()
  local path = datafile.path('csagent/machineguid')
  if path then
    return file.read(path)
  end
end

local function cache_it(guid)
  local data_base_path = datafile.path('') .. 'csagent'
  dir.makepath(data_base_path)
  file.write(data_base_path .. '/machineguid', guid)
end

local function introspect_anew()
  local new_one = uuid()
  cache_it(new_one)
  return new_one
end

return setmetatable({}, {__call = function() return get_cached() or introspect_anew() end})