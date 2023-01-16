#!/bin/bash

# This script is for a "bash-only console", meaning that no system commands are available to copy data over a TCP connection
# As a minimal example, you can creare a 'nanocontainer' with these commands:
### #!/bin/cat
### 
### mkdir minibash
### mkdir minibash/bin
### mkdir minibash/lib64
### 
### # here you should run this command to get the minimal set of libraries, necessary to run /bin/bash:
### #
### #    ldd /bin/bash
### #
### # and eventually edit the cp here below.
### cp -av /bin/bash /lib64/libc.* /lib64/libtinfo.* minibash/lib64
### 
### tar c -C minibash . | podman import
### rm -Rfv minibash
### 
### # here you should take note of image id (IMAGEID)
### podman image list 
### 
### podman image tag IMAGEID minibash
### 
### podman run -it --rm minibash
### bash-5.1# echo "it works!"
### bash-5.1# exit

# write these lines in your bash-only console (the example is for copying 'chmod')
export OUTFILE=chmod
# change 'aaa.bbb.ccc.ddd' with the IP addres of the server that will push data to this bash
mapfile -d '' -n 0 NEWLINES < /dev/tcp/aaa.bbb.ccc.ddd/5555
for NEWLINE in "${NEWLINES[@]}" ; do
   # never use 'echo' here, because if $NEWLINE starts with a dash (-) you'll have unpredictable results!
   printf "%s\0" "$NEWLINE"
done > "/bin/$OUTFILE"

# run OUTFILE (yes, also if +x attribute is missing) with:
/lib64/ld-linux-x86-64.so.2 "/bin/$OUTFILE"
