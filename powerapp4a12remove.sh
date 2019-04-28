
	echo "Removing..."
	rm -rf /Applications/PowerApp.app/
	echo "This needs uicache..."
	uicache
	echo "All done!"
	echo "PowerApp Removed!"
	killall -9 SpringBoard
