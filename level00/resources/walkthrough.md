# level00

## Steps

1. __Observation__ (Guest): when connecting as the `level00` user,
    nothing appears on stdout

2. __Action__ (Guest): find the files owned by the `flag00` user
    ```sh
    find / -user flag00 2>/dev/null
    ```

3. __Observation__ (Guest): the previous command reveals two files
    ```sh
    /usr/sbin/john
    /rofs/usr/sbin/john
    ```

4. __Action__ (Guest): check the content of the files
    ```sh
    cat /usr/sbin/john /rofs/usr/sbin/john
    ```

5. __Observation__ (Guest): the previous command reveals the same content
    ```sh
    cdiiddwpgswtgt
    cdiiddwpgswtgt
    ```

6. __Action__ (Host): decipher the message
    the message was deciphered on [dcode](https://www.dcode.fr/chiffre-cesar).
    the shift used to decipher the message was a shift of 15
    ```sh
    nottoohardhere
    ```

7. __Action__ (Guest): log in as `flag00`
    ```sh
    su flag00
    Password: nottoohardhere
    ```

8. __Observation__ (Guest): we're invited to launch the command `getflag`
    ```sh
    Don't forget to launch getflag !
    ```

9. __Action__ (Guest): get the flag
    ```sh
    getflag
    Check flag.Here is your token : x24ti5gi3x0ol2eh4esiuxias
    ```
