
describe('machineguid()', function()

  local machineguid = require 'machineguid'

  it('should return the same value when called multiple times', function()
    assert.are.equal(machineguid(), machineguid(), machineguid()) -- three times is multiple enough?
  end)
end)
