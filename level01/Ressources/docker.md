Install ubuntu docker named john-container and run it interactively
```
docker run -it --name john-container ubuntu:latest bash
```

Install John the Ripper in the container
```
apt update
apt install -y john
```

In another terminal, copy file to container (it's copied to root cause that's
where the result will be)
```
docker cp /path/to/passwd john-container:/root/passwd
```

Go the where the file is copied
```
cd /root
```

Crack the password
```
john passwd
```

See the cracked password
```
john --show passwd
```
Results are
```
flag01:abcdefg:3001:3001::/home/flag/flag01:/bin/bash
```

Delete all traces of docker container
```
docker stop john-container
docker rm john-container
docker rmi ubuntu:latest
```