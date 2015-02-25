

describe('netinfo()', function()
  it('each record must contain ip, cidr, mac, and name', function()
    local netinfo = require 'netinfo'
    for _, record in pairs(netinfo()) do
      assert.is.truthy(record['ip'])
      assert.is.truthy(record['cidr'])
      assert.is.truthy(record['mac'])
      assert.is.truthy(record['name'])
    end
  end)
end)