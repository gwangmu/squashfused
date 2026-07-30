install:
	mkdir -p /usr/share/containers/oci/hooks.d
	cp squashfused-init-hook.json /usr/share/containers/oci/hooks.d
	cp squashfused-forward-hook.json /usr/share/containers/oci/hooks.d
	cp squashfused-clean-hook.json /usr/share/containers/oci/hooks.d
	cp squashfused-init /usr/local/bin
	cp squashfused-forward /usr/local/bin
	cp squashfused-daemon /usr/local/bin
	cp squashfused-clean /usr/local/bin
