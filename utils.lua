

local utils = {}

function utils.sleep(seconds)
    local socket = require 'socket'
    -- A hack that blocks for the amount of provided seconds.
    socket.select(nil, nil, seconds)
end

function utils.toboolean(expr)
  return not not expr
end

--
-- Returns true if the given file_path points to an existing filesystem file, false
-- otherwise.
--
function utils.file_exists(file_path)
  local fp, err = io.open(file_path)
  if err and utils.toboolean(err:find('No such file')) then
    return false
  else
    io.close(fp)
    return true
  end
end

return utils
