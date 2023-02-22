#!/bin/bash

# This script is a little helper to help you build a rootfs for a function, and run it into a 
# firecracker microVM with network. This will be deprectated as soon as Morty CLI will implement
# the new build system.

# To run this script, you must be root
if [ "$EUID" -ne 0 ]; then 
    echo "[ERROR] The script requires root privileges. Please run as root or use sudo."
    exit 1
fi

FUNCTION_NAME="node-$(date +"%s")"

rm -rf *.ext4
rm -rf *.cfg.json

# ============================================
# BUILD
# ============================================

# Build the docker image of the runtime, we will manipulate the rootfs after
docker build -t "${FUNCTION_NAME}:latest" ./morty-runtimes/template/node-19

# Create the ext4 mount point
dd if=/dev/zero of="${FUNCTION_NAME}.ext4" bs=1M count=300
mkfs.ext4 "${FUNCTION_NAME}.ext4"
mkdir -p "/tmp/${FUNCTION_NAME}"
mount "${FUNCTION_NAME}.ext4" "/tmp/${FUNCTION_NAME}"

# Create a script to export the rootfs from within the Docker container
cat <<EOF > /tmp/rootfs-export.sh
for d in app bin etc lib root sbin usr; do tar c "/\${d}" | tar x -C /my-rootfs; done
for dir in dev proc run sys var; do mkdir /my-rootfs/\${dir}; done
exit
EOF

# Export the rootfs of the docker image
docker run --rm -i -v /tmp/${FUNCTION_NAME}:/my-rootfs -v /dev/urandom:/dev/random ${FUNCTION_NAME}:latest sh </tmp/rootfs-export.sh

# Inject the custom /sbin/init script
cat <<EOF > $(pwd)/alpha_init
#!/bin/sh
export ALPHA_PROCESS_COMMAND="/usr/local/bin/node /app/index.js"
/usr/bin/alpha
EOF
mv "/tmp/${FUNCTION_NAME}/sbin/init" "/tmp/${FUNCTION_NAME}/sbin/init.old"
cp "$(pwd)/alpha_init" "/tmp/${FUNCTION_NAME}/sbin/init"
chmod a+x "/tmp/${FUNCTION_NAME}/sbin/init"

# Finally umount the EXT4 mount point
umount "/tmp/${FUNCTION_NAME}"

# ============================================
# RUN
# ============================================

# Get the interface connected to internet
IFNET=$(ip route get 8.8.8.8 | head -n1 | awk '{print $5}')
HOST_TAP="tap-vm"
GW_IP="172.16.0.1"
VM_IP="172.16.0.2"

# Setup the tap interface for the function
ip tuntap add "${HOST_TAP}" mode tap
ip addr add "${GW_IP}/24" dev "${HOST_TAP}"
ip link set "${HOST_TAP}" up
sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"
iptables -t nat -A POSTROUTING -o "${IFNET}" -j MASQUERADE
iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i "${HOST_TAP}" -o "${IFNET}" -j ACCEPT

# Write the microVM config file
cat <<EOF > "$(pwd)/${FUNCTION_NAME}.cfg.json"
{
    "boot-source": {
        "kernel_image_path": "$(pwd)/vmlinux.bin",
        "boot_args": "console=ttyS0 reboot=k nomodules random.trust_cpu=on panic=1 pci=off tsc=reliable i8042.nokbd i8042.noaux ipv6.disable=1  nameserver=8.8.8.8 ip=${VM_IP}::${GW_IP}:255.255.255.252::eth0:off"
    },
    "drives": [
        {
            "drive_id": "rootfs",
            "path_on_host": "$(pwd)/${FUNCTION_NAME}.ext4",
            "is_root_device": true,
            "is_read_only": false
        }
    ],
    "network-interfaces": [
        {
            "iface_id": "eth0",
            "guest_mac": "$(cat /sys/class/net/${IFNET}/address)",
            "host_dev_name": "${HOST_TAP}"
        }
    ]
}
EOF

firecracker --api-sock "/tmp/${FUNCTION_NAME}.sock" --config-file "$(pwd)/${FUNCTION_NAME}.cfg.json"
