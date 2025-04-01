# CLI POSSIBILITIES

This file will describe some cli possible to do with termux file.

# LIST

> GET
	```SHELL
	//Will return the value by key typed

	termux-config get extra-keys
	termux-config get back-key [--comment|-c]   		// Show commented value
	termux-config get [--all|-a] [--comment|-c] 		// Show commented values
	```
> CHANGE
	```SHELL
	//Will change keys/values from config

	termux-config change extra-keys --add=ESC 	//Add value (ESC)
	termux-config change extra-keys --del=/		//Delete value (/)
	termux-config change back-key --off 		//Comment
	termux-config change back-key --on 		    //Uncomment
	```
