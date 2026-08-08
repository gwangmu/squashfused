all: do_demo

.SILENT:
.IGNORE:

define start
	# Notice no 'CAP_SYS_ADMIN' nor '--privileged'.
	podman run -d --replace --userns=keep-id --workdir=/home/ubuntu --name sf-demo-cont squashfused-demo sleep inf >/dev/null
endef

define start_w_volume
	podman run -d --replace --userns=keep-id --workdir=/home/ubuntu --name sf-demo-cont -v .:/demo:z squashfused-demo sleep inf >/dev/null
endef

define exec
	echo "$$ $(1)"
	podman exec sf-demo-cont bash -c $(1)
endef

define clean_up
	podman kill sf-demo-cont >/dev/null
	podman rm sf-demo-cont >/dev/null
endef

do_demo: 
	make -C . do_demo_copy_link
	make -C . do_demo_nocopy_link 
	make -C . do_demo_copy_nolink 
	make -C . do_demo_nocopy_nolink_constdst

do_demo_copy_link: build_demo_image do_install_copy_link
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

do_demo_nocopy_link: build_demo_image do_install_nocopy_link
	$(call start_w_volume)

	echo "$$ # Report basic config"
	$(call exec,"id")
	$(call exec,"pwd")
	echo

	echo "$$ # Prepare mount destinations"
	$(call exec,"mkdir empty_file")
	$(call exec,"mkdir small_file")
	$(call exec,"ls -l")
	echo

	echo "$$ # Mount /demo/empty_file.sqfs"
	$(call exec,"squashfuse /demo/empty_file.sqfs empty_file")
	$(call exec,"ls -l")
	$(call exec,"ls empty_file")
	echo 
	
	echo "$$ # Mount ./small_file.sqfs"
	$(call exec,"squashfuse ./small_file.sqfs small_file")
	$(call exec,"ls -l")
	echo 
	
	echo "$$ # Unmount"
	$(call exec,"umount empty_file")
	$(call exec,"ls -l")
	echo 
	
	$(call clean_up)

do_demo_copy_nolink: build_demo_image do_install_copy_nolink
	$(call start)

	echo "$$ # Report basic config"
	$(call exec,"id")
	$(call exec,"pwd")
	echo

	echo "$$ # Mount /demo/empty_file.sqfs"
	$(call exec,"squashfuse empty_file.sqfs whatever")
	$(call exec,"ls /squashfused/bridge_dir")
	$(call exec,"ls /squashfused/bridge_dir/0/mount")
	echo 
	
	echo "$$ # Mount ./small_file.sqfs"
	$(call exec,"squashfuse small_file.sqfs whatever")
	$(call exec,"ls /squashfused/bridge_dir")
	$(call exec,"ls /squashfused/bridge_dir/1/mount")
	echo 
	
	echo "$$ # Unmount everything"
	$(call exec,"umount /squashfused/bridge_dir/0/mount")
	$(call exec,"umount /squashfused/bridge_dir/1/mount")
	$(call exec,"ls /squashfused/bridge_dir")
	echo 
	
	$(call clean_up)

do_demo_nocopy_nolink_constdst: build_demo_image do_install_nocopy_nolink_constdst
	$(call start_w_volume)

	echo "$$ # Report basic config"
	$(call exec,"id")
	$(call exec,"pwd")
	echo

	echo "$$ # Mount /demo/empty_file.sqfs"
	$(call exec,"squashfuse /demo/empty_file.sqfs whatever")
	$(call exec,"ls /user-environment")
	echo 
	
	echo "$$ # Mount /demo/small_file.sqfs - error: 'constdst' already mounted"
	$(call exec,"squashfuse /demo/small_file.sqfs whatever")
	$(call exec,"ls /user-environment")
	echo 
	
	echo "$$ # Unmount"
	$(call exec,"umount empty_file")
	$(call exec,"ls /user-environment")
	echo 

	echo "$$ # Remount /demo/empty_file.sqfs & unmount directly 'constdst'"
	$(call exec,"squashfuse /demo/empty_file.sqfs")
	$(call exec,"umount /user-environment")
	$(call exec,"ls /user-environment")
	echo 
	
	$(call clean_up)

build_demo_image:
	podman build -f Containerfile -t squashfused-demo >/dev/null

do_install_copy_link:
	echo "Installing... (copy, link)"
	sudo make -C .. -s install
	systemctl --user daemon-reload
	systemctl --user restart squashfused-server
	echo

do_install_nocopy_link:
	echo "Installing... (nocopy, link)"
	sudo make -C .. -s install NOCOPY=1 
	systemctl --user daemon-reload
	systemctl --user restart squashfused-server
	echo

do_install_copy_nolink:
	echo "Installing... (copy, nolink)"
	sudo make -C .. -s install NOLINK=1
	systemctl --user daemon-reload
	systemctl --user restart squashfused-server
	echo

do_install_nocopy_nolink_constdst:
	echo "Installing... (nocopy, nolink, constdst=/user-environment)"
	sudo make -C .. -s install NOCOPY=1 NOLINK=1 CONSTDST=/user-environment
	systemctl --user daemon-reload
	systemctl --user restart squashfused-server
	echo
