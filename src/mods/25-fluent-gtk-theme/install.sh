#!/bin/bash

set -e                  # exit on error
set -o pipefail         # exit on pipeline error
set -u                  # treat unset variable as error

# هذا السكربت يتم تشغيله داخل بيئة chroot، والمسار الحالي هو مجلد المود

print_ok "Installing WhiteSur-Dark"

# إنشاء المجلدات اللازمة في جذر نظام الـ chroot (/)
mkdir -p "/usr/share/themes" "/usr/share/icons"
judge "Prepare directories"

# نسخ ثيم الواجهة (GTK)
print_ok "Installing VAXP Dark solid blue GTK theme"
# نستخدم ./tools لأن المجلد tools يقع بجوار install.sh
cp -r "./tools/WhiteSur-Dark" "/usr/share/themes/"
judge "Install WhiteSur-Dark"

# نسخ ثيم الأيقونات
print_ok "Installing vaxp-icon theme"
cp -r "./tools/vaxp-icon" "/usr/share/icons/"
judge "Install vaxp-icon theme"

# نسخ ثيم المؤشرات (Cursors)
print_ok "Installing VAXP cursors theme"
cp -r "./tools/Sunity-cursors" "/usr/share/icons/" 
judge "Install Sunity-cursors theme"

