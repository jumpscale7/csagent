set -e

sudo apt-get install -y lua5.1  liblua5.1-dev liblua5.1 git

# Install luarocks
wget -O - http://luarocks.org/releases/luarocks-2.2.0.tar.gz | tar xz
cd luarocks-2.2.0
sudo ./configure && make && sudo make install

# Installing the dependencies now
cd ~
git clone -b rel-20140819 https://github.com/wahern/lunix.git
cd lunix
sudo make all5.1 prefix=/usr/
sudo make install5.1 prefix=/usr/

# TODO: parse dependencies.txt and install via luarocks
