all: do_demo

.SILENT:

define start
	# Notice no 'CAP_SYS_ADMIN' nor '--privileged'.
	podman run -d --userns=keep-id --workdir=/home/ubuntu --name sf-demo-cont squashfused-demo sleep inf >/dev/null
endef

define exec
	echo "$$ $(1)"
	podman exec sf-demo-cont bash -c $(1)
endef

define clean_up
	podman kill sf-demo-cont >/dev/null
	podman rm sf-demo-cont >/dev/null
endef

do_demo: build_demo_image
	$(call start)

	echo "$$ # Report basic config"
	$(call exec,"id")
	$(call exec,"pwd")
	echo

	echo "$$ # Prepare mount destinations"
	$(call exec,"mkdir empty_file")
	$(call exec,"mkdir small_file")
	$(call exec,"ls -l")
	echo
	
	echo "$$ # Mount empty_file.sqfs"
	$(call exec,"squashfuse empty_file.sqfs empty_file")
	$(call exec,"ls -l")
	$(call exec,"ls empty_file")
	echo 
	
	echo "$$ # Mount small_file.sqfs"
	$(call exec,"squashfuse small_file.sqfs small_file")
	$(call exec,"ls -l")
	$(call exec,"ls small_file")
	$(call exec,"cat small_file/test_doc")
	echo 
	
	echo "$$ # Unmount everyting"
	$(call exec,"umount empty_file")
	$(call exec,"umount small_file")
	$(call exec,"ls -l")
	echo 
	
	$(call clean_up)

build_demo_image:
	podman build -f Containerfile -t squashfused-demo >/dev/null
