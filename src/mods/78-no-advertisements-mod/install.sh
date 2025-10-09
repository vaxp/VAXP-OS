set -e                  # exit on error
set -o pipefail         # exit on pipeline error
set -u                  # treat unset variable as error

#print_ok "Ensuring Ubuntu Pro advertisement is disabled"
FILE="/etc/apt/apt.conf.d/20apt-esm-hook.conf"

# التحقق من وجود الملف
if [[ -e "$FILE" ]]; then
  # إذا وُجد الملف، قم بحذفه
  sudo rm -f "$FILE"
 print_ok "File $FILE found and removed successfully."
else
  # إذا لم يُوجد الملف، قم بتخطي الخطوة بنجاح
  print_ok "File $FILE not found, nothing to remove."
fi

# يمكنك إضافة منطق judge هنا لتسجيل النجاح
judge "Ensure Ubuntu Pro advertisement is disabled"