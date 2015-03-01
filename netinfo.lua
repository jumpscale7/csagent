--
-- Exposes functions for introspecting the available network interfaces and their assigned addresses.
--

local unix = require 'unix'
local dir = require 'pl.dir'
local path = require 'pl.path'

local netinfo = {}


local AF_INET   = 2     -- IPv4 address family
local AF_INET6  = 10    -- IPv6 address family

-- Returns MAC address for the given interface name, or nil if not available
function netinfo.mac_address(interface_name)
  assert(interface_name)
  local mac_address_fp = '/sys/class/net/' .. interface_name .. '/address'
  local fp, err = io.open(mac_address_fp)
  if err then
    error(err)
  end
  local address = fp:read()
  fp:close()
  return address
end

-- Returns a sequence of available network interface names
function netinfo.interfaces()
  local interfaces = {}
  for i, interface_path in pairs(dir.getdirectories('/sys/class/net')) do
    interfaces[i] = path.basename(interface_path)
  end
  return interfaces
end

function netinfo.ip4_address(interface_name)
  for address in unix.getifaddrs() do
    if address.name == interface_name and address.family == AF_INET then
      return address.addr
    end
  end
end

function netinfo.ip6_address(interface_name)
  for address in unix.getifaddrs() do
    if address.name == interface_name and address.family == AF_INET6 then
      return address.addr
    end
  end
end

function netinfo.ip4_network_prefix_length(interface_name)
  for address in unix.getifaddrs() do
    if address.name == interface_name and address.family == AF_INET then
      return address.prefixlen
    end
  end
end

function netinfo.ip6_network_prefix_length(interface_name)
  for address in unix.getifaddrs() do
    if address.name == interface_name and address.family == AF_INET6 then
      return address.prefixlen
    end
  end
end

return netinfo