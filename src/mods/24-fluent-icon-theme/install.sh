set -e                  # exit on error
set -o pipefail         # exit on pipeline error
set -u                  # treat unset variable as error


# ==============================================
# تثبيت ثيم أيقونات Nordzy
# ==============================================

print_ok "Cloning Nordzy Icon theme repository"
mkdir -p ./themes/
# نستخدم مجلد فرعي مؤقت لعملية الاستنساخ/التثبيت
git clone https://github.com/MolassesLover/Nordzy-icon.git ./themes/Nordzy-icon
judge "Clone Nordzy Icon repository"

print_ok "Installing Nordzy Icon theme (default)"
(
    cd ./themes/Nordzy-icon && \
    # الخيار -t default: لتعيين الثيم الافتراضي، -c: لتعيين الألوان، -p: لتثبيت الثيم
    ./install.sh -t default -c -p
)
judge "Install Nordzy Icon theme"

# ==============================================
# تثبيت ثيم مؤشر Sunity Cursors
# ==============================================

print_ok "Cloning Sunity Cursors repository"
git clone https://github.com/alvatip/sunity-cursors.git ./themes/sunity-cursors
judge "Clone Sunity Cursors repository"

print_ok "Installing Sunity Cursors theme"
(
    cd ./themes/sunity-cursors && \
    ./install.sh
)
judge "Install Sunity Cursors theme"
