--
-- The parsing of CLI arguments.
--

args = {}

--
-- Parses the given table of system-provided CLI arguments and returns a table with that useful
-- information if they were correctly provided.
--
-- Exits with a helpful error message if the arguments are insufficient or incorrect.
--
function args.parse(arg)

  local data = {}

  data.gid = tonumber(arg[1])

  if not data.gid then
    print('Insufficient or incorrect arguments are passed.')
    print('Usage: ' .. arg[0] .. ' GID')
    os.exit(1)
  end

  return data
end

return args