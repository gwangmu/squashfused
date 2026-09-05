install:
	sudo mkdir -p /usr/share/containers/oci/hooks.d
	sudo mkdir -p /usr/local/libexec/squashfused
	sudo mkdir -p /usr/local/libexec/squashfused/stub
	sudo mkdir -p /usr/local/lib/squashfused
	sudo mkdir -p /etc/systemd/user
	sudo cp hooks/* /usr/share/containers/oci/hooks.d
	sudo cp libexec/* /usr/local/libexec/squashfused
	sudo cp stub/* /usr/local/libexec/squashfused/stub
	sudo cp lib/* /usr/local/lib/squashfused
	sudo cp unit/* /etc/systemd/user
	sudo find /usr/local/libexec/squashfused/stub -type f -exec sed -i 's|@SQUASHFUSED_SRCMODE@|$(or $(SRCMODE),copy)|g' {} \;
	sudo find /usr/local/libexec/squashfused/stub -type f -exec sed -i 's|@SQUASHFUSED_DSTMODE@|$(or $(DSTMODE),link)|g' {} \;
	sudo find /usr/local/libexec/squashfused/stub -type f -exec sed -i 's|@SQUASHFUSED_CONSTDST@|$(or $(CONSTDST),)|g' {} \;
	sudo find /usr/local/lib/squashfused -type f -exec sed -i 's|@SQUASHFUSED_SRCMODE@|$(or $(SRCMODE),copy)|g' {} \;
	sudo find /usr/local/lib/squashfused -type f -exec sed -i 's|@SQUASHFUSED_DSTMODE@|$(or $(DSTMODE),link)|g' {} \;
	sudo find /usr/local/lib/squashfused -type f -exec sed -i 's|@SQUASHFUSED_CONSTDST@|$(or $(CONSTDST),)|g' {} \;
	systemctl --user daemon-reload
	systemctl --user enable squashfused-server.service
	systemctl --user restart squashfused-server.service

uninstall:
	systemctl --user disable squashfused-server.service
	systemctl --user stop squashfused-server.service
	sudo rm -rf /usr/share/containers/oci/hooks.d/squashfused-*
	sudo rm -rf /usr/local/libexec/squashfused
	sudo rm -rf /usr/local/lib/squashfused
	sudo rm -rf /etc/systemd/user/squashfused-server.service
