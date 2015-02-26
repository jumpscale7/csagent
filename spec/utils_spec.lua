
local utils = require 'utils'

describe('file_exists()', function()
  it('should return true for exsiting files', function()
    assert.True(utils.file_exists('args.lua'))
  end)

  it('should return false for nonexisting files', function()
    assert.False(utils.file_exists('nofile.lua'))
  end)
end)