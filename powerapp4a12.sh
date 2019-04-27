if [ "$(id -u)" != "0" ]; then
echo "This install script must be run as root" 1>&2
exit 1
fi

pushd /tmp

if [ -e /jb/bin/bash ]
then
	echo "Install or Remove PowerApp?"
	read -p "i = Install, r = Remove: " whatdo
	if [ $whatdo = "i" ]; then
		echo "Downloading PowerApp..."
		wget https://github.dave1482.com/PowerApp/tars/powerapp4a12.tar.gz
		echo "Installing PowerApp..."
		rm -rf /Applications/PowerApp.app/
		tar -C / -xpf powerapp4a12.tar.gz
		rm -rf powerapp4a12.tar.gz

		echo "Setting Permissions..."

		chown root:wheel /Applications/PowerApp.app/*
		chown mobile:mobile /Applications/PowerApp.app/Base.lproj
		chown mobile:mobile /Applications/PowerApp.app/*/*
		chown mobile:mobile /Applications/PowerApp.app/*/*/*
		chown mobile:mobile /Applications/PowerApp.app/*/*/*/*
		chmod 0755 /Applications/PowerApp.app/*
		chmod 0755 /Applications/PowerApp.app/*/*
		chmod 0755 /Applications/PowerApp.app/*/*/*
		chmod 0755 /Applications/PowerApp.app/*/*/*/*
		chown root:admin /Applications/PowerApp.app/PowerApp8

		chown mobile:mobile /Applications/PowerApp.app/PowerAppLock
		chown mobile:mobile /Applications/PowerApp.app/PowerAppLock32
		chown mobile:mobile /Applications/PowerApp.app/PowerAppLock64
		chmod 6755 /Applications/PowerApp.app/PowerApp8
		chmod +x /Applications/PowerApp.app/PowerApp8
		chmod +x /Applications/PowerApp.app/PowerAppLock
		chmod +x /Applications/PowerApp.app/PowerAppLock32
		chmod +x /Applications/PowerApp.app/PowerAppLock64

		inject /Applications/PowerApp.app/PowerApp8
		inject /Applications/PowerApp.app/PowerAppLock64

		ln -s /jb/bin/sh /bin/sh
		ln -s /jb/usr/bin/killall /usr/bin/killall
		ln -s /jb/usr/bin/uicache /usr/bin/uicache
		ln -s /jb/bin/touch /bin/touch

		echo "This needs uicache..."
		uicache
		echo "All done!"
		echo "Thank you for installing PowerApp!"
		killall -9 SpringBoard
	elif [ $whatdo = "r" ]; then
		echo "Removing..."
		rm -rf /Applications/PowerApp.app/
		echo "This needs uicache..."
		uicache
		echo "All done!"
		echo "PowerApp Removed!"
		killall -9 SpringBoard
	else
		echo "Error, re-run script"
	fi
    popd
fi
