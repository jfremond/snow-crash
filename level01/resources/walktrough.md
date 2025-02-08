# level01

## Steps

1. __Observation__ (Guest): when connecting as the `level01` user,
    nothing appears on stdout

2. __Action__ (Guest): find the files owned by users `level01` and `flag01`
    ```sh
    find / -user flag01 2>/dev/null
    find / -user level01 2>/dev/null
    ```

3. __Observation__ (Guest): the previous commands reveals processes running for
    `level01`, so nothing worth exploiting

4. __Action__ (Guest): since our goal is to find passwords, we find the list
    of password files the current user can read
    ```sh
    find / -name "passwd" -perm -u=r 2>/dev/null
    ```

5. __Observation__ (Guest): the previous command reveals password files
    ```sh
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

6. __Action__ (Guest): we check the contents of the primary file containing
    information about user accounts
    ```sh
    cat /etc/passwd
    ```

7. __Observation__ (Guest): the previous command reveals an abnormality at
    the `flag01` line
    ```sh
    ...
    flag00:x:3000:3000::/home/flag/flag00:/bin/bash
    flag01:42hDRfypTqqnw:3001:3001::/home/flag/flag01:/bin/bash
    ...
    ```

8. __Action__ (Host): we copy the password file on our host machine
    to manipulate it
    ```sh
    scp -P 4242 level01@192.168.56.101:/etc/passwd ./level01_passwd
    ```

9. __Action__ (Host): we create and start a docker container to crack the
    password in `level01_passwd` using `John the Ripper`
    ```sh
    docker run -it --name jtr ubuntu bash
    ```

10. __Action__ (Host): we install `John the Ripper` in our container
    ```sh
    apt update
    apt install -y john
    ```

11. __Action__ (Host): in another terminal, we copy our file in our container
    ```sh
    docker cp level01_passwrd jtr:level01_passwd
    ```

12. __Action__ (Host): in our container, crack the password
    ```sh
    john level01_passwd --show
    ```

13. __Observation__ (Host): the previous command reveals the cracked password
    ```sh
    flag01:abcdefg:3001:3001::/home/flag/flag01:/bin/bash

    1 password hash cracked, 0 left
    ```

14. __Action__ (Guest): log in as `flag01`
    ```sh
    su flag00
    Password: abcdefg
    ```

8. __Observation__ (Guest): we're invited to launch the command `getflag`
    ```sh
    Don't forget to launch getflag !
    ```

9. __Action__ (Guest): get the flag
    ```sh
    getflag
    Check flag.Here is your token : f2av5il02puano7naaf6adaaf
    ```
