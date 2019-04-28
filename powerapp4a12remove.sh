if [ "$(id -u)" != "0" ]; then
echo "This install script must be run as root" 1>&2
exit 1
fi

if [ -e /jb/bin/bash ]
then
	echo "Removing..."
	rm -rf /Applications/PowerApp.app/
	echo "This needs uicache..."
	uicache
	echo "All done!"
	echo "PowerApp Removed!"
	killall -9 SpringBoard
fi
