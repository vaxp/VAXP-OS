set -e                  # exit on error
set -o pipefail         # exit on pipeline error
set -u                  # treat unset variable as error

print_ok "Enabling gnome extensions for root..."
/root/.local/bin/gext -F enable arcmenu@arcmenu.com
/root/.local/bin/gext -F enable blur-my-shell@aunetx
/root/.local/bin/gext -F enable ProxySwitcher@flannaghan.com
/root/.local/bin/gext -F enable customize-ibus@hollowman.ml
/root/.local/bin/gext -F enable openbar@neuromorph
/root/.local/bin/gext -F enable tasks-in-panel@fthx
/root/.local/bin/gext -F enable quick-settings-tweaks@qwreey
/root/.local/bin/gext -F enable compiz-alike-magic-lamp-effect@hermes83.github.com
/root/.local/bin/gext -F enable network-stats@gnome.noroadsleft.xyz
/root/.local/bin/gext -F enable openweather-extension@penguin-teal.github.io
/root/.local/bin/gext -F enable switcher@anduinos
/root/.local/bin/gext -F enable noti-bottom-right@anduinos
/root/.local/bin/gext -F enable loc@anduinos.com
/root/.local/bin/gext -F enable lockkeys@vaina.lt
/root/.local/bin/gext -F enable tiling-assistant@leleat-on-github
/root/.local/bin/gext -F enable mediacontrols@cliffniff.github.com
/root/.local/bin/gext -F enable clipboard-indicator@tudmotu.com
judge "Enable gnome extensions"

# Install jq:
print_ok "Updating gnome extensions to force enable for gnome 48..."
apt install $INTERACTIVE jq --no-install-recommends
find /usr/share/gnome-shell/extensions -type f -name metadata.json | while IFS= read -r file; do
    if jq -e 'has("shell-version")' "$file" > /dev/null; then
        if jq -e '.["shell-version"] | index("48")' "$file" > /dev/null; then
            print_info "$file already supports gnome \"48\"."
        else
            print_warn "$file does not contain \"48\", updating file..."
            tmpfile=$(mktemp)
            jq '.["shell-version"] += ["48"]' "$file" > "$tmpfile" && mv "$tmpfile" "$file"
            chmod 644 "$file"
        fi
    else
        print_error "$file does not contain \"shell-version\"!"
        exit 1
    fi
done

#=================================================
# التعديل: تطبيق التفعيل الدائم عبر GSETTINGS Override
#=================================================

print_ok "Applying permanent default extension activation via GSettings override..."

# 1. قائمة بجميع الـ IDs (القائمة التي استخدمتها بالفعل)
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

# 2. إنشاء سلسلة نصية بصيغة القائمة المطلوبة لملف Override: 'id1', 'id2', ...
# نستخدم printf و sed لإنشاء سلسلة واحدة مفصولة بفواصل ومحاطة بعلامات اقتباس فردية
IFS=$'\n' # نغير الفاصل مؤقتاً لضم عناصر المصفوفة بشكل صحيح
EXTENSION_LIST=$(printf "'%s'," "${ALL_EXTENSIONS[@]}" | sed 's/,$//') # إزالة الفاصلة الأخيرة
IFS=' ' # إعادة الفاصل إلى قيمته الافتراضية

# 3. تحديد ملف الـ Override ومسار الـ Schemas
OVERRIDE_FILE="/usr/share/glib-2.0/schemas/50-vaxpos-extensions.gschema.override"
SCHEMA_DIR="/usr/share/glib-2.0/schemas"

# 4. إنشاء محتوى ملف الـ Override
# هذا الملف يخبر النظام أن القيمة الافتراضية لـ org.gnome.shell::enabled-extensions هي القائمة المحددة
cat << EOF > "$OVERRIDE_FILE"
[org.gnome.shell]
enabled-extensions=[$EXTENSION_LIST]
EOF

judge "Created GSettings override file: $OVERRIDE_FILE"

# 5. تجميع (Compile) الـ Schemas
# هذه الخطوة ضرورية ليقرأ النظام ملف الـ Override ويطبقه
print_ok "Compiling GSettings schemas..."
/usr/bin/glib-compile-schemas "$SCHEMA_DIR"
judge "GSettings schemas compiled successfully"

print_ok "Permanent default extensions set for new users."