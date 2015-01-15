
local unix = require('unix')
M = {}

--
-- When called, returns a dynamically constructed table of network devices and their information.
--
local function retrieve_netinfo ()
    local info_table = {}
    for net_device in unix.getifaddrs() do
        if net_device.addr and net_device.family == 2 or net_device.family == 10 then   -- A device listing with MAC or an IP address
            local record = info_table[net_device.name] or {name = net_device.name}

            if net_device.family == 2 then
                record.ip = net_device.addr
                record.cidr = net_device.prefixlen
            elseif net_device.family == 10 then
                record.mac, _ = net_device.addr:match('[:a-zA-Z0-9]+')
            end

            info_table[net_device.name] = record
        end
    end

    local info_array = {}
    for _, value in pairs(info_table) do
        if value.mac then -- Server only accepts entries with MAC address
            table.insert(info_array, value)
        end
    end
    return info_array
end

return setmetatable(M, {__call = retrieve_netinfo})