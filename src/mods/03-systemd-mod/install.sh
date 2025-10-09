set -e                  # exit on error
set -o pipefail         # exit on pipeline error
set -u                  # treat unset variable as error

# we need to install systemd first, to configure machine id
print_ok "Installing essential systemd components for Noble (24.04 LTS)"

#wait_network
apt update
apt install $INTERACTIVE \
    libterm-readline-gnu-perl \
    systemd-sysv \
    wget \
    krb5-locales \
    publicsuffix \
    libnss-systemd \
    networkd-dispatcher \
    cryptsetup \
    shared-mime-info \
    dmsetup \
    xdg-user-dirs \
    ca-certificates \
    --no-install-recommends
judge "Install systemd components"