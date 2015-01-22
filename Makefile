LUAROCKS=luarocks
DEPS_FILE=dependencies.txt --server=http://rocks.moonscript.org/manifests/amrhassan

dependencies:
	install -dm0755 $(destdir)/usr/share/csagent
	for dep in `cat dependencies.txt`; do $(LUAROCKS) install --tree=$(destdir)/usr/share/csagent/ $${dep} ; done

install: dependencies
	install -Dm0755 exe/csagent $(destdir)/usr/bin/csagent
