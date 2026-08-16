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
	echo "$$ ${1}"
	podman exec sf-demo-cont bash -c $(1)
endef

define clean_up
	podman kill sf-demo-cont >/dev/null
	podman rm sf-demo-cont >/dev/null
endef

do_demo: 
	make -C . do_demo_copy_link
	make -C . do_demo_map_link 
	make -C . do_demo_rootfs_link 
	make -C . do_demo_copy_null 
	make -C . do_demo_map_const
	make -C . do_demo_rootfs_const

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
	$(call exec,"fusermount -u empty_file")
	$(call exec,"fusermount -u small_file")
	$(call exec,"ls -l")
	echo 
	
	$(call clean_up)

do_demo_map_link: build_demo_image do_install_map_link
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
	$(call exec,"fusermount -u empty_file")
	$(call exec,"ls -l")
	echo 
	
	$(call clean_up)

do_demo_rootfs_link: build_demo_image do_install_rootfs_link
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
	$(call exec,"fusermount -u empty_file")
	$(call exec,"fusermount -u small_file")
	$(call exec,"ls -l")
	echo 
	
	$(call clean_up)

do_demo_rootfs_bind: build_demo_image do_install_rootfs_bind
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
	$(call exec,"findmnt --type fuse.squashfuse --output target -n")
	$(call exec,"ls /squashfused/bridge_dir")
	$(call exec,"ls empty_file")
	echo 
	
	echo "$$ # Mount small_file.sqfs"
	$(call exec,"squashfuse small_file.sqfs small_file")
	$(call exec,"ls -l")
	$(call exec,"findmnt --type fuse.squashfuse --output=target -n")
	$(call exec,"ls /squashfused/bridge_dir")
	$(call exec,"cat small_file/test_doc")
	echo 
	
	echo "$$ # Unmount everyting"
	$(call exec,"fusermount -u empty_file")
	$(call exec,"fusermount -u small_file")
	$(call exec,"ls -l")
	$(call exec,"findmnt --type fuse.squashfuse --output=target -n")
	$(call exec,"ls /squashfused/bridge_dir")
	$(call exec,"ls -l")
	$(call exec,"ls small_file")
	echo 
	
	$(call clean_up)

do_demo_copy_null: build_demo_image do_install_copy_null
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
	$(call exec,"fusermount -u /squashfused/bridge_dir/0/mount")
	$(call exec,"fusermount -u /squashfused/bridge_dir/1/mount")
	$(call exec,"ls /squashfused/bridge_dir")
	echo 
	
	$(call clean_up)

do_demo_map_const: build_demo_image do_install_map_const
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
	$(call exec,"fusermount -u")
	$(call exec,"ls /user-environment")
	echo 

	echo "$$ # Remount /demo/empty_file.sqfs & unmount directly 'constdst'"
	$(call exec,"squashfuse /demo/empty_file.sqfs")
	$(call exec,"fusermount -u /user-environment")
	$(call exec,"ls /user-environment")
	echo 
	
	$(call clean_up)

do_demo_rootfs_const: build_demo_image do_install_rootfs_const
	$(call start_w_volume)

	echo "$$ # Report basic config"
	$(call exec,"id")
	$(call exec,"pwd")
	echo

	echo "$$ # Mount ./empty_file.sqfs"
	$(call exec,"squashfuse ./empty_file.sqfs whatever")
	$(call exec,"ls /user-environment")
	echo 
	
	echo "$$ # Mount ./small_file.sqfs - error: 'constdst' already mounted"
	$(call exec,"squashfuse ./small_file.sqfs whatever")
	$(call exec,"ls /user-environment")
	echo 
	
	echo "$$ # Unmount"
	$(call exec,"fusermount -u")
	$(call exec,"ls /user-environment")
	echo 

	echo "$$ # Remount /demo/empty_file.sqfs & unmount directly 'constdst'"
	$(call exec,"squashfuse /demo/empty_file.sqfs")
	$(call exec,"fusermount -u /user-environment")
	$(call exec,"ls /user-environment")
	echo 
	
	$(call clean_up)

build_demo_image:
	podman build -f Containerfile -t squashfused-demo >/dev/null

do_install_copy_link:
	echo "Installing... (copy, link)"
	sudo make -C .. -s install SRCMODE=copy DSTMODE=link
	systemctl --user daemon-reload
	systemctl --user restart squashfused-server
	echo

do_install_map_link:
	echo "Installing... (map, link)"
	sudo make -C .. -s install SRCMODE=map DSTMODE=link
	systemctl --user daemon-reload
	systemctl --user restart squashfused-server
	echo

do_install_rootfs_link:
	echo "Installing... (rootfs, link)"
	sudo make -C .. -s install SRCMODE=rootfs DSTMODE=link
	systemctl --user daemon-reload
	systemctl --user restart squashfused-server
	echo

do_install_rootfs_bind:
	echo "Installing... (rootfs, bind)"
	sudo make -C .. -s install SRCMODE=rootfs DSTMODE=bind
	systemctl --user daemon-reload
	systemctl --user restart squashfused-server
	echo

do_install_copy_null:
	echo "Installing... (copy, null)"
	sudo make -C .. -s install SRCMODE=copy DSTMODE=null
	systemctl --user daemon-reload
	systemctl --user restart squashfused-server
	echo

do_install_map_const:
	echo "Installing... (map, const, constdst=/user-environment)"
	sudo make -C .. -s install SRCMODE=map DSTMODE=const CONSTDST=/user-environment
	systemctl --user daemon-reload
	systemctl --user restart squashfused-server
	echo

do_install_rootfs_const:
	echo "Installing... (rootfs, const, constdst=/user-environment)"
	sudo make -C .. -s install SRCMODE=rootfs DSTMODE=const CONSTDST=/user-environment
	systemctl --user daemon-reload
	systemctl --user restart squashfused-server
	echo
