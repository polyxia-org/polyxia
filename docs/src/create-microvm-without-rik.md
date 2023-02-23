# Create your first function with Firecracker (without RIK)

This guide will help you set up your first function into a Firecracker microVM, and trigger it.

## Requirements

- `firecracker` installed into your `$PATH`
- `docker`

## Steps

First of all, you should create a temporary directory on your host and place the `start-vm.sh` script into it:

```bash
mkdir -p /tmp/getting-started-fc
cp scripts/start-vm.sh /tmp/getting-started-fc/
cd /tmp/getting-started-fc
```

**For the rest of the commands above, we assume that you are in the `/tmp/getting-started-fc` directory.**

Download the kernel :

```bash
curl -k -o vmlinux.bin https://162.38.112.10:13808/swift/v1/AUTH_9ab97b0fd6984ca2a6261286b66f4cae/polyxia-dev/vmlinux
```

Clone the runtimes :

```bash
# SSH
git clone git@github.com:polyxia-org/morty-runtimes.git

# HTTPS
git clone https://github.com/polyxia-org/morty-runtimes.git
```

You should have the following folder architecture :

```bash
ls -la
#...
drwxr-xr-x  4 debian debian      4096 Feb 22 21:57 morty-runtimes
-rwxr-xr-x  1 debian debian      3240 Feb 22 21:59 start-vm.sh
-rw-r--r--  1 debian debian  45614488 Feb 22 22:07 vmlinux
```

Now, you simply need to run the following command to build and run the template function into a microVM. The `<TEMPLATE>` argument is optional and if you omit it, `node-19` will be automatically selected for you. You can check the list of the available templates [here](https://github.com/polyxia-org/morty-runtimes/tree/main/template).

```bash
# You must run the script as root
sudo bash start-vm.sh <TEMPLATE>

# Once everything has booted, you should see at the end of the logs the following lines :
INFO[0000] Started process /usr/local/bin/node /app/index.js (pid=482)
INFO[0000] Alpha server listening on 0.0.0.0:8080
```

From another terminal, you can now invoke your function by using the following command :

```bash
curl http://172.16.0.2:8080
```

You should see a similar output :

```json
{
  "payload": "My first function !",
  "process_metadata": {
    "execution_time_ms": 19,
    "logs": [
      "I can log some messages..."
    ]
  }
}
```

To exit your VM, get the PID of your firecracker process and kill it :

```bash
ps -auxf | grep firecracker
sudo kill -9 <PID>
```
