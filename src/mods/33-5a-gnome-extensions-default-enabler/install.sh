#!/bin/bash
# 34-gnome-extensions-default-enabler/install.sh - يُنفذ داخل chroot

set -e
set -o pipefail
set -u


# =========================================================================
# === تـأكـيـد بـدء الـتـنـفـيـذ ===
# =========================================================================
echo ""
echo "#####################################################################"
echo "###                                                               ###"
echo "###          تـفـعـيـل إضـافـات GNOME بـشـكـل افـتـراضـي            ###"
echo "###                                                               ###"
echo "#####################################################################"
echo ""

print_ok "Applying permanent default extension activation via GSettings override..."

# 1. قائمة بجميع الـ IDs (نستخدم القائمة التي استخدمتها بالضبط لتجنب الأخطاء)
ALL_EXTENSIONS=(
    'arcmenu@arcmenu.com'
    'blur-my-shell@aunetx'
    'ProxySwitcher@flannaghan.com'
    'customize-ibus@hollowman.ml'
    'openbar@neuromorph'
    'tasks-in-panel@fthx'
    'quick-settings-tweaks@qwreey'
    'compiz-alike-magic-lamp-effect@hermes83.github.com'
    'network-stats@gnome.noroadsleft.xyz'
    'openweather-extension@penguin-teal.github.io'
    'switcher@anduinos'
    'noti-bottom-right@anduinos'
    'loc@anduinos.com'
    'lockkeys@vaina.lt'
    'tiling-assistant@leleat-on-github'
    'mediacontrols@cliffniff.github.com'
    'clipboard-indicator@tudmotu.com'
)

# 2. إنشاء سلسلة نصية بصيغة القائمة المطلوبة لملف الـ Override: 'id1', 'id2', ...
IFS=$'\n' # نستخدم فاصل سطر جديد
# نضع جميع العناصر بين علامات اقتباس مفردة ونفصلها بفاصلة، ثم نزيل الفاصلة الأخيرة.
EXTENSION_LIST=$(printf "'%s'," "${ALL_EXTENSIONS[@]}" | sed 's/,$//') 
IFS=' ' # نعيد الفاصل إلى قيمته الافتراضية

# 3. تحديد ملف الـ Override ومسار الـ Schemas
OVERRIDE_FILE="/usr/share/glib-2.0/schemas/50-vaxpos-extensions.gschema.override"
SCHEMA_DIR="/usr/share/glib-2.0/schemas"

# 4. إنشاء محتوى ملف الـ Override
# هذا الملف يحدد القيمة الافتراضية لـ enabled-extensions على مستوى النظام
cat << EOF > "$OVERRIDE_FILE"
[org.gnome.shell]
enabled-extensions=[$EXTENSION_LIST]
EOF

judge "Created GSettings override file"

# 5. تجميع (Compile) الـ Schemas لتطبيق التغييرات الافتراضية للنظام
print_ok "Compiling GSettings schemas..."
/usr/bin/glib-compile-schemas "$SCHEMA_DIR"
judge "GSettings schemas compiled successfully"

print_ok "Permanent default extensions set for all new users."