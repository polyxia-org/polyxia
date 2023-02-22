# Running MicroVM for debugging

Create a microVM through Firecracker and not through Riklet for debugging purposes.

## Prerequisites

- Firecracker

## Create a rootfs with Morty

Follow our [guide](./create-your-first-function.md).

## Download a kernel

Check firecracker [getting started](https://github.com/firecracker-microvm/firecracker/blob/main/docs/getting-started.md#running-firecracker)
to download a kernel.

## Create a configuration

Configuration file for firecracker, replace variable with your own values.

- `${KERNEL_LOCATION}`: location to your kernel (`vmlinux.bin`)
- `${ROOTFS_LOCATION}`: location to your rootfs (`rootfs.ext4`)

```json
{
  "boot-source": {
    "kernel_image_path": "${KERNEL_LOCATION}",
    "boot_args": "ip\u003d192.168.1.138::192.168.1.137:255.255.255.252::eth0:off"
  },
  "drives": [
    {
      "drive_id": "rootfs",
      "path_on_host": "${ROOTFS_LOCATION}",
      "is_root_device": true,
      "is_read_only": false
    }
  ],
  "network-interfaces": [
    {
      "iface_id": "eth0",
      "guest_mac": "AA:FC:00:00:00:01",
      "host_dev_name": "rik-fc-tap"
    }
  ]
}
```

## Run the microVM

```bash
firecracker --api-sock /tmp/firecracker.sock --config-file vm-config.cfg.json
```

- `vm-config.cfg.json` is the file from the step above

## Troubleshoot

**apk update is hanging with some errors**:

Ensure you have any nameservers in `/etc/resolv.conf`. If not, add 
`nameserver 8.8.8.8` to the file.


**if the vm download big files it got stalled**:

Try to update MTU (network packets size):
```shell
ip link set dev eth0 mtu 1000
```