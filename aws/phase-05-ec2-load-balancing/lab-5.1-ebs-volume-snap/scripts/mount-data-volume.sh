#!/bin/bash
# cloud-config script to mount EBS volume to /data

set -e

echo "=== Starting EBS volume mount script ==="

# Update and install required packages
apt-get update -y
apt-get upgrade -y
apt-get install -y parted xfsprogs

# Determine the actual device name (Nitro instances use NVMe)
if [ -b /dev/nvme1n1 ]; then
  DEVICE="/dev/nvme1n1"
elif [ -b /dev/sdf ]; then
  DEVICE="/dev/sdf"
else
  echo "ERROR: Could not find EBS volume device!" >&2
  exit 1
fi

MOUNT_POINT="/data"
FS_TYPE="xfs"

echo "Using device: $DEVICE"

# Create mount point
mkdir -p ${MOUNT_POINT}

# Format only if the volume is not already formatted
if ! blkid ${DEVICE} > /dev/null 2>&1; then
  echo "Formatting ${DEVICE} with ${FS_TYPE}..."
  mkfs.${FS_TYPE} -f ${DEVICE}
else
  echo "Device ${DEVICE} is already formatted."
fi

# Get UUID
UUID=$(blkid -s UUID -o value ${DEVICE})

# Add to /etc/fstab if not present
if ! grep -q "${UUID}" /etc/fstab; then
  echo "Adding entry to /etc/fstab..."
  echo "UUID=${UUID}  ${MOUNT_POINT}  ${FS_TYPE}  defaults,nofail,discard  0  2" >> /etc/fstab
fi

# Mount all
mount -a

echo "=== Volume successfully mounted to ${MOUNT_POINT} ==="
df -h ${MOUNT_POINT}