# level01

We start the same way we started with the previous level, with this set of
commands : 
```
find / -user level01 2>/dev/null
find / -user flag01 2>/dev/null
```

We get nothing worth exploiting, just `/proc/pid/...`.

Since our goal is to find passwords, we decide to explore password files that
the current user can read, we search for those files with this command :
```
find / -name "passwd" -perm -u=r 2>/dev/null
```

This is what we get :
```
/etc/cron.daily/passwd
/etc/init.d/passwd
/etc/pam.d/passwd
/etc/passwd
/usr/bin/passwd
/usr/share/doc/passwd
/usr/share/lintian/overrides/passwd
/rofs/etc/cron.daily/passwd
/rofs/etc/init.d/passwd
/rofs/etc/pam.d/passwd
/rofs/etc/passwd
/rofs/usr/bin/passwd
/rofs/usr/share/doc/passwd
/rofs/usr/share/lintian/overrides/passwd
```
Since we know that `/etc/passwd` is the primary file containting information
about user accounts, we check its content.

When doing `cat /etc/passwd` we notice an abnormality at the `flag01` line,
the usual x for crypted password is replaced by a value:
```
flag01:42hDRfypTqqnw:3001:3001::/home/flag/flag01:/bin/bash
```
This is what the line for `flag00` looks like in comparaison.
```
flag00:x:3000:3000::/home/flag/flag00:/bin/bash
```

We then decide to crack the password with John The Ripper.
Since it's not available on the VM, we copy the `etc/passwd` file on our
host machine and launch a Docker container to install the software
and get cracking.

```
scp -P 4242 level01@192.168.56.101:/etc/passwd .
```
This means we copy the `/etc/passwd` file from the remote machine using the
port 4242 to the current directory of the host machine.

To create a docker container to run and install `John the Ripper` on, we use
this command.
```
docker run -it --name jtr ubuntu bash
```

We're not root in our container, this is how we install John the Ripper.
```
apt update
apt install -y john
```
In another terminal, copy file to container
```
docker cp /path/to/passwd john-container:~
```

Go the where the file is copied

Crack the password
```
john passwd
```

See the cracked password
```
john --show passwd
```
Results are
```
flag01:abcdefg:3001:3001::/home/flag/flag01:/bin/bash
```

We can now connect as flag01 to collect the flag.
```
su flag01
getflag -> f2av5il02puano7naaf6adaaf
```