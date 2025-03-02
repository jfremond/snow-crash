# level00

## Steps

1. __Action__ (Guest): find the files owned by the `flag00` user
	```sh
	find / -user flag00 2>/dev/null
	```

2. __Observation__ (Guest): the previous command reveals two files, both named `john`
	```
	/usr/sbin/john
	/rofs/usr/sbin/john
	```

3. __Action__ (Guest): check the content of both the `john` files
	```sh
	cat /usr/sbin/john /rofs/usr/sbin/john
	```

4. __Observation__ (Guest): the previous command reveals that both files have the same content
	```
	cdiiddwpgswtgt
	cdiiddwpgswtgt
	```
	which resembles a ciphered token

5. __Action__ (Guest): decipher the content of the `/usr/sbin/john` file,  
	shifting every letter by 11 positions forward (`a` becomes `l`, `b` becomes `m`, etc...),  
	wrapping around when reaching the end of the alphabet (after `z` comes `a`, etc...)
	```sh
	tr a-z l-za-k </usr/sbin/john
	```

6. __Observation__ (Guest): the previous command reveals the message `nottoohardhere`
	```
	nottoohardhere
	```

7. __Action__ (Host): try to connect as the `flag00` user with the deciphered token
	```sh
	sshpass -p nottoohardhere 2>/dev/null \
		ssh -p 4242 flag00@192.168.122.214 \
			exit \
	&& echo 'Great! The token is correct!' \
	|| echo 'Nop, the token is incorrect!'
	```

8. __Observation__ (Host): the following message appears on stdout: `Great! The token is correct!`  
	confirming that the cracked password is indeed the password of the `flag00` user

9. __Action__ (Host): run the `getflag` command as the `flag00` user
	and save the token in the `flag` file
	```sh
	sshpass -p nottoohardhere 2>/dev/null \
		ssh -p 4242 flag00@192.168.122.214 \
			getflag \
	| egrep -o '[^ ]+$' >level00/flag
	```
