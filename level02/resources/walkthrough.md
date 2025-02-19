# level02

## Steps

1. __Action__ (Guest): list the files present at the root
    ```sh
    ls -A
    ```

2. __Observation__ (Guest): the previous command reveals a PCAP file
    ```sh
    .bash_logout  .bashrc  level02.pcap  .profile
    ```

3. __Action__ (Guest): get information on the PCAP file
    ```sh
    getfacl level02.pcap
    ```

4. __Observation__ (Guest): the previous command reveals that the PCAP file is
    not readable by the `level02` user
    ```
    # file: level02.pcap
    # owner: flag02
    # group: level02
    user::---
    group::r--
    other::r--
    ```

5. __Action__ (Host): we copy the pcap file on our host machine
    to manipulate it
    ```sh
    sshpass -f snow-crash/level01/flag  \
    scp -P 4242 level02@192.168.56.101:level02.pcap ./level02.pcap
    ```

6. __Action__ (Host): we change the permissions on the `level02.pcap` file to
    be able to open it with `tshark`
    ```sh
    chmod +x level02.pcap
    ```

7. __Action__ (Host): open the file with `tshark` to read it
    ```sh
    tshark -r level02.pcap
    ```

8. __Observation__ (Host): Several packets are exchanged between two IP
    addresses following the TCP protocol
    ```
    1   0.000000 59.233.235.218 ? 59.233.235.223 TCP 74 39247 ? 12121 [SYN] Seq=0 Win=14600 Len=0 MSS=1460 SACK_PERM TSval=18592800 TSecr=0 WS=128
    2   0.000128 59.233.235.223 ? 59.233.235.218 TCP 74 12121 ? 39247 [SYN, ACK] Seq=0 Ack=1 Win=14480 Len=0 MSS=1460 SACK_PERM TSval=46280417 TSecr=18592800 WS=32
    ```

9. __Action__ (Host): we follow the TCP stream to see what was exhanged
    between the two IP addresses
    ```sh
    tshark -r level02.pcap -q -z follow,tcp,hex,0
    ```
    Only the content of the packets is displayed, in hexadecimal.

10. __Observation__ (Host): the previous manipulation reveals intersting
    lines
    ```sh
    000000D6  00 0d 0a 50 61 73 73 77  6f 72 64 3a 20           ...Passw ord:
    000000B9  66                                                f
    000000BA  74                                                t
    000000BB  5f                                                _
    000000BC  77                                                w
    000000BD  61                                                a
    000000BE  6e                                                n
    000000BF  64                                                d
    000000C0  72                                                r
    000000C1  7f                                                .
    000000C2  7f                                                .
    000000C3  7f                                                .
    000000C4  4e                                                N
    000000C5  44                                                D
    000000C6  52                                                R
    000000C7  65                                                e
    000000C8  6c                                                l
    000000C9  7f                                                .
    000000CA  4c                                                L
    000000CB  30                                                0
    000000CC  4c                                                L
    ```

11. __Observation__ (Host): after taking into account that the dots are delete
    characters, we see that the password is `ft_waNDReL0L`

12. __Action__ (Guest): log in as the `flag02` user
    ```sh
    su flag02
    ```

13. __Observation__ (Guest): we're invited to launch the command `getflag`
    ```sh
    Don't forget to launch getflag !
    ```

14. __Action__ (Guest): get the flag
    ```sh
    getflag
    ```
