

local utils = {}

function utils.sleep(seconds)
    local socket = require 'socket'
    -- A hack that blocks for the amount of provided seconds.
    socket.select(nil, nil, seconds)
end

return utils
