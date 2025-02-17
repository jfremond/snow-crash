# level00

## Steps

1. __Action__ (Guest): find the files owned by the `flag00` user
    ```sh
    find / -user flag00 2>/dev/null
    ```

2. __Observation__ (Guest): the previous command reveals two files
    ```
    /usr/sbin/john
    /rofs/usr/sbin/john
    ```

3. __Action__ (Guest): check the content of the files
    ```sh
    less /usr/sbin/john /rofs/usr/sbin/john
    ```

4. __Observation__ (Guest): the previous command reveals the same content
    ```
    cdiiddwpgswtgt
    cdiiddwpgswtgt
    ```

5. __Action__ (Host): decipher the message
    the message was deciphered on [dcode](https://www.dcode.fr/chiffre-cesar).
    the shift used to decipher the message was a shift of 11
    ```
    nottoohardhere
    ```

6. __Action__ (Guest): log in as `flag00`
    ```sh
    su flag00
    ```

7. __Observation__ (Guest): we're invited to launch the command `getflag`
    ```
    Don't forget to launch getflag !
    ```

8. __Action__ (Guest): get the flag
    ```sh
    getflag
    ```
