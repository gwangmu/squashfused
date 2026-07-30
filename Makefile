install:
	mkdir -p /usr/share/containers/oci/hooks.d
	mkdir -p /usr/local/libexec/squashfused
	mkdir -p /usr/local/lib/squashfused
	cp hooks/* /usr/share/containers/oci/hooks.d
	cp libexec/* /usr/local/libexec/squashfused
	cp lib/* /usr/local/lib/squashfused

clean:
	rm -rf /usr/share/containers/oci/hooks.d/squashfused-*
	rm -rf /usr/local/libexec/squashfused
	rm -rf /usr/local/lib/squashfused
