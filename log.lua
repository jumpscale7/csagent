
--
-- Primitive logging facilities.
--

json = require 'json'

local log = {}

log.INFO = 'INFO'
log.DEBUG = 'DEBUG'
log.WARNING = 'WARNING'

local function log_something(self, message, type)
  type = type or log.INFO
  print(type .. ' ' .. message)
end

return setmetatable(log, {__call=log_something})