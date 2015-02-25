 script for setting up environment for travis-ci testing. 
# Sets up Lua and Luarocks. 
# LUA must be "Lua 5.1", "Lua 5.2" or "LuaJIT 2.0". 
# Source: https://github.com/Olivine-Labs/busted/blob/master/.travis_setup.sh

set -e

echo 'rocks_servers = {
  "http://rocks.moonscript.org/",
  "http://luarocks.org/repositories/rocks"
}' >> ~/config.lua


wget -O - https://github.com/wahern/lunix/archive/rel-20140819.tar.gz | tar xz


if [ "$LUA" == "LuaJIT 2.0" ]; then
  wget -O - http://luajit.org/download/LuaJIT-2.0.2.tar.gz | tar xz
  cd LuaJIT-2.0.2
  make && sudo make install INSTALL_TSYMNAME=lua;

else
  if [ "$LUA" == "Lua 5.1" ]; then
    cd lunix-rel-20140819 ; make all5.1 ; cd ..
    wget -O - http://www.lua.org/ftp/lua-5.1.5.tar.gz | tar xz
    cd lua-5.1.5;
  elif [ "$LUA" == "Lua 5.2" ]; then
    cd lunix-rel-20140819 ; make all5.2 ; cd ..
    wget -O - http://www.lua.org/ftp/lua-5.2.3.tar.gz | tar xz
    cd lua-5.2.3;
  fi
  sudo make linux install;
fi

cd ..
wget -O - http://luarocks.org/releases/luarocks-2.2.0.tar.gz | tar xz
cd luarocks-2.2.0

make && sudo make install
cd ..

