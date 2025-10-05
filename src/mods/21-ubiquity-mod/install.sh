set -e                  # exit on error
set -o pipefail         # exit on pipeline error
set -u                  # treat unset variable as error

print_ok "Installing install tools..."
apt install $INTERACTIVE \
    cryptsetup-initramfs \
    secureboot-db \
    btrfs-progs \
    lvm2 \
    libfile-mimeinfo-perl \
    libnet-dbus-perl \
    libx11-protocol-perl \
    x11-utils --no-install-recommends
judge "Install install tools"

print_ok "Installing ubiquity (Ubuntu installer)..."
wait_network
apt install $INTERACTIVE \
    ubiquity \
    ubiquity-casper \
    ubiquity-frontend-gtk \
    ubiquity-slideshow-ubuntu \
    ubiquity-ubuntu-artwork --no-install-recommends
judge "Install ubiquity"