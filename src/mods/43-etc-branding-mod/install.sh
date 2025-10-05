set -e                  # exit on error
set -o pipefail         # exit on pipeline error
set -u                  # treat unset variable as error

print_ok "Customization complete. Updating lsb/os-release files"
cat << EOF > /etc/lsb-release
DISTRIB_ID=$TARGET_BUSINESS_NAME
DISTRIB_RELEASE=$TARGET_BUILD_VERSION
DISTRIB_CODENAME=$TARGET_UBUNTU_VERSION
DISTRIB_DESCRIPTION="$TARGET_BUSINESS_NAME $TARGET_BUILD_VERSION"
EOF
judge "Update lsb-release"

# Mark ID as ubuntu to support some Ubuntu features, like add-apt-repository
cat << EOF > /etc/os-release
PRETTY_NAME="$TARGET_BUSINESS_NAME $TARGET_BUILD_VERSION"
NAME="$TARGET_BUSINESS_NAME"
VERSION_ID="$TARGET_BUILD_VERSION"
VERSION="$TARGET_BUILD_VERSION ($TARGET_UBUNTU_VERSION)"
VERSION_CODENAME=$TARGET_UBUNTU_VERSION
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.vaxpos.org/"
SUPPORT_URL="https://www.vaxpos.org/"
BUG_REPORT_URL="https://www.vaxpos.org/"
PRIVACY_POLICY_URL="https://www.vaxpos.org/"
UBUNTU_CODENAME=$TARGET_UBUNTU_VERSION
EOF
# The ID have to be ubuntu to support some Ubuntu features, like add-apt-repository
judge "Update os-release"