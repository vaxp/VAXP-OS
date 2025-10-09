set -e
set -o pipefail
set -u

# ----------------------------------------------------------------------
# تثبيت "المتحكم المطلق" (VAXP S M) من GitHub Releases
# ----------------------------------------------------------------------

# الرابط المباشر للملف
DOWNLOAD_URL="https://github.com/vaxp/vaxpsam/releases/download/vaxpsam/vaxpsam.deb"
TEMP_FILE="/tmp/vaxpsam.deb"

print_ok "Downloading The Absolute Controller (VAXP S M)"

# 1. سحب حزمة DEB إلى مجلد مؤقت (/tmp)
wget "$DOWNLOAD_URL" -O "$TEMP_FILE"
judge "Download VAXP S M DEB"

# 2. تثبيت الحزمة باستخدام dpkg
print_ok "Installing The Absolute Controller"
dpkg -i "$TEMP_FILE"
judge "Install VAXP S M"

# 3. حل التبعيات المفقودة بشكل تلقائي ومؤتمت (الخطوة الأهم)
print_ok "Fixing missing dependencies automatically"
apt install -f -y 
judge "Resolve VAXP S M dependencies"

# 4. حذف الملف المؤقت بعد الانتهاء
rm "$TEMP_FILE"
judge "Clean up temporary files"

# ----------------------------------------------------------------------
# يمكن الآن استكمال بقية عملية الأتمتة (مثل تثبيت Lunaris Eye)
# ----------------------------------------------------------------------