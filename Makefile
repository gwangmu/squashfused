install:
	mkdir -p /usr/share/containers/oci/hooks.d
	mkdir -p /usr/local/libexec/squashfused
	mkdir -p /usr/local/libexec/squashfused/stub
	mkdir -p /usr/local/lib/squashfused
	mkdir -p /etc/systemd/user
	cp hooks/* /usr/share/containers/oci/hooks.d
	cp libexec/* /usr/local/libexec/squashfused
	cp stub/* /usr/local/libexec/squashfused/stub
	cp lib/* /usr/local/lib/squashfused
	cp unit/* /etc/systemd/user
	find /usr/local/libexec/squashfused -type f -exec sed -i 's/@SQUASHFUSED_ENVS@/$(SQUASHFUSED_ENVS)/g' {} \;

clean:
	rm -rf /usr/share/containers/oci/hooks.d/squashfused-*
	rm -rf /usr/local/libexec/squashfused
	rm -rf /usr/local/lib/squashfused
	rm -rf /etc/systemd/user/squashfused-server.service
