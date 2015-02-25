[![Build Status](https://travis-ci.org/Jumpscale/csagent.svg?branch=master)](https://travis-ci.org/Jumpscale/csagent)

# CSAgent #
A JumpScale Agent for the JumpScale7 platform, written in Lua.

More information about the concepts behind the project is available on the [project wiki](https://github.com/Jumpscale/csagent/wiki).

## Installation and running ##
Manageable via the the jpackage system:
```bash
jpackage install -n csagent GID
```

Where `GID` is the designated numerical ID of your Grid.

## Manual Execution ##
Having fulfilled the execution dependencies, CSAgent is started from the [`csagent.lua`](https://github.com/Jumpscale/csagent/blob/master/csagent.lua) script and its execution logic can be followed from there and onwards in a fairly straightforward and well-documented manner.

## Testing it out ##
You can test it out by sending the CSAgent something to do using `jsac` (after replacing GID with your Grid ID):
```bash
jsac exec -gid GID -r csagent -o jumpscale -n lua_add -a 'x:30,y:12'
```
