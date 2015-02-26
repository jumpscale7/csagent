set -e

sudo apt-get install -y lua5.1  liblua5.1-dev liblua5.1 git curl

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


# Get the dependencies list and install those marked with a luarocks source using luarocks
for dep in `curl https://raw.githubusercontent.com/Jumpscale/csagent/master/dependencies.txt | sed -e1d `; do
  pkg_name=`echo $dep | cut -d, -f2`
  source=`echo $dep | cut -d, -f1`
  pkg_version=`echo $dep | cut -d, -f3`
  if [ "$source" = "luarocks" ]; then
    echo "Installing ${pkg_name} ${pkg_version}"
    sudo luarocks install --server=http://rocks.moonscript.org/manifests/amrhassan ${pkg_name} ${pkg_version}
  fi
done
