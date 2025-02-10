# level02

We see that we have a file when doing ls in the current directory:

```
ls -l
----r--r-- 1 flag02 level02 8302 Aug 30  2015 level02.pcap
```

We transfer that file to our host machine to analyze it :
```
scp -P 4242 level02@192.168.56.101:level02.pcap .
```

A quick search on the internet tells us that a PCAP file is a file containing an exact copy of every byte of every pocket as seen on the network.Read more [here](https://www.endace.com/learn/what-is-a-pcap-file).
It also tells us it can be read with Wireshark so that's we'll do.

When wanting to analyze, we have the option to follow the TCP stream, which allows us to see what was sent.
The data is originally showed as ASCII characters.

We see an intersting line in the conversation :
```
Password: ft_wandr...NDRel.L0L
```

When trying to log as flag02 using this password, it doesn't work. Let's try displaying the stream differently.

When displaying the conversation as Hex Dump rather than ASCII, we see that the dots in the password were not really dots but delete characters, the password is now `ft_waNDReL0L`.

Once logged as flag02 using the newly obtained password, we launch the getflag command and get the flag
`kooda2puivaav1idi4f57q8iq`

# level02

## Steps

1. __Observation__ (Guest): when connecting as the `level02` user,
    nothing appears on stdout

2. __Action__ (Guest): list the files present at the root
    ```sh
    ls -lA
    ```

3. __Observation__ (Guest): the previous command reveals a PCAP file
    ```sh
    ----r--r-- 1 flag02  level02 8302 Aug 30  2015 level02.pcap
    ```

7. __Action__ (Host): we copy the pcap file on our host machine
    to manipulate it
    ```sh
    scp -P 4242 level02@192.168.56.101:level02.pcap ./level02.pcap
    ```

8. __Action__ (Host): we change the permissions on the `level02.pcap` file to
    be able to open it with Wireshark
    ```sh
    chmod +x level02.pcap
    ```

9. __Action__ (Host): open the file with Wireshark to analyze it

10. __Observation__ (Host): Several packets we're exchanged between two IP
    addresses following the TCP protocol

11. __Action__ (Host): we analyze the PCAP file via following the TCP stream,
    the data is showed as ASCII characters.

12. __Observation__ (Host): the previous manipulation reveals an intersting
    line
    ```sh
    ...
    Password: ft_wandr...NDRel.L0L
    ...
    ```

13. __Action__ (GUest): try logging with this password

14. __Observation__ (Guest): the log in failed.

15. __Action__ (Host): show the data differently, it is now showed as hex dump.
    we see that the dots are delete characters.
    the password is actually `ft_waNDReL0L`.

16. __Action__ (Guest): log in as `flag02`
    ```sh
    su flag02
    Password: ft_waNDReL0L
    ```

17. __Observation__ (Guest): we're invited to launch the command `getflag`
    ```sh
    Don't forget to launch getflag !
    ```

18. __Action__ (Guest): get the flag
    ```sh
    getflag
    Check flag.Here is your token : kooda2puivaav1idi4f57q8iq
    ```
