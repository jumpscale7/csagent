[![Build Status](https://travis-ci.org/Jumpscale/csagent.svg?branch=master)](https://travis-ci.org/Jumpscale/csagent)

# CSAgent #
A JumpScale Agent for the JumpScale7 platform, written in Lua.

More information about the concepts behind the project is available on the [project wiki](https://github.com/Jumpscale/csagent/wiki).

## Installation and execution ##

### In a JumpScale environment ###
```bash
jpackage install -n csagent
```

### In OpenWRT ###
After adding the [JumpScale OpenWRT package feed](https://github.com/Jumpscale/openwrt-packages) to your [buildroot](http://wiki.openwrt.org/doc/howto/build):
```bash
./script/feeds update jumpscale
./scipt/feeds install csagent
make menuconfig     # And include JumpScale/CSAgent
```
In your OpenWRT image, the `csagent` service should be enabled by default. You can edit its configuration
parameters in `/etc/config/csagent` then hit `/etc/init.d/csagent reload` to apply your changes.

## Testing it out ##
You can test it out by sending the CSAgent something to do using `jsac` (after replacing GID with your Grid ID):
```bash
jsac exec -gid GID -r csagent -o jumpscale -n lua_add -a 'x:30,y:12'
```
