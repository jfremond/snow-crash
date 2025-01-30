# level00

We need to find the files owned by user flag00.

We start with the following command:

`find / -user flag00`

This means we want to find from the root all files belonging to user `flag00`.

We get a lot of permission errors like this:

`find: '/path/to/file': Permission denied`

We redirect all our errors to `/dev/null` for clarity, We now have the following command :

`find / -user flag00 2>/dev/null`

We now have this:

```
/usr/sbin/john
/rofs/usr/sbin/john
```

When checking the rights of both files, we see that they're read-only.
```
----r--r-- 1 flag00 flag00 15 Mar  5  2016 /usr/sbin/john
----r--r-- 1 flag00 flag00 15 Mar  5  2016 /rofs/usr/sbin/john
```

When looking at the contents of both files, we can see they both contain the same line.
```
cdiiddwpgswtgt
cdiiddwpgswtgt
```

We try to decipher the message using a Cesar shift of 11, and once we do, we get

`nottoohardhere`

We then log as `flag00` with `nottoohardhere` as a password. It works! We get the following message:
> Don't forget to launch getflag !

Once we get the token `x24ti5gi3x0ol2eh4esiuxias
` we can connect to level01.
