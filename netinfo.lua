
local unix = require('unix')
M = {}

--
-- When called, returns a dynamically constructed table of network devices and their information.
--
-- Note: Returns only information about the network devices with assigned IPv4 addresses.
--
-- Example output:
-- {
--      {ip = '127.0.0.1', cidr = 8, mac = '00:00:00:00:00:00', name = 'lo'},
--      {ip = '10.0.2.15', cidr = 24, mac = u'08:00:27:c5:03:64', name = 'eth0'},
--      {ip = '192.168.33.10, cidr = 24, mac = u'08:00:27:01:83:b8', name = 'eth1'}
-- }
--
local function retrieve_netinfo ()

    local function mac_address_for_interface(interface_name)
        assert(interface_name)
        local fp, err = io.open('/sys/class/net/' .. interface_name .. '/address')
        if err then
          error(err)
        end
        local address = fp:read()
        fp:close()
        return address
    end

    local info = {}
    for net_device in unix.getifaddrs() do
        if net_device.addr and net_device.family == 2 then   -- A device listing with an IP address
            local record = {
                name = net_device.name,
                ip = net_device.addr,
                cidr = net_device.prefixlen,
                mac = mac_address_for_interface(net_device.name),
            }

            table.insert(info, record)
        end
    end

    return info
end



return setmetatable(M, {__call = retrieve_netinfo})