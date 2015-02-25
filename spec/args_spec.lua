
local args = require 'args'

describe('args.parse()', function()
  it('should complain when no GID is provided', function()
    local arg = {"-c", "irrelevant" }
    local _, err = args.parse(arg, true)
    assert.is.truthy(err)
  end)

  it('should capture the GID', function()
    local res, err = args.parse({'42'})
    assert.is.falsy(err)
    assert.is.equal(42, res.gid)
  end)

  it('should consume the provided AgentController JSONRPC URL', function()
    local result, err = args.parse({'-c', 'http://google.com', '42'}, true)
    assert.is.falsy(err)
    assert.is.equal('http://google.com', result.agentcontroller_jsonrpc_url)
  end)

  it('should fallback to the default AgentController JSONRPC URL', function()
    local result, err = args.parse({'42'})
    assert.is.falsy(err)
    assert.is.equal('http://localhost:4444', result.agentcontroller_jsonrpc_url)
  end)

  it('should consume the provided roles', function()
    local arg = {'-r', 'superagent,notsuperagent', '24'}
    local res, err = args.parse(arg, true)
    assert.is.falsy(err)
    assert.are.same({'superagent', 'notsuperagent'}, res.roles)
  end)

  it('should fall back to the default roles when none are provided', function()
    local arg = {'24'}
    local res, err = args.parse(arg, true)
    assert.is.falsy(err)
    assert.are.same({'csagent'}, res.roles)
  end)
end)