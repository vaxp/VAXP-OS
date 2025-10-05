set -e                  # exit on error
set -o pipefail         # exit on pipeline error
set -u                  # treat unset variable as error


# STORE_PROVIDER = none, flatpak, web, snap

if [ "$STORE_PROVIDER" == "none" ]; then
    print_ok "No need to install a store because STORE_PROVIDER is set to none, please check the config file"
elif [ "$STORE_PROVIDER" == "flatpak" ]; then
    print_ok "Installing gnome software and flatpak support"
    apt install $INTERACTIVE \
        flatpak \
        gnome-software \
        gnome-software-plugin-flatpak --no-install-recommends
    install_opt gnome-software-plugin-deb
    judge "Install gnome software with flatpak support"

    print_ok "Adding official flathub repository..."
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    judge "Add official flatpak repository"

    if [ -n "$FLATHUB_MIRROR" ]; then
        print_warn "Using mirror for flatpak. Replacing flathub repository with mirror $FLATHUB_MIRROR..."

        # FLATHUB_GPG
        if [ -n "$FLATHUB_GPG" ]; then
            print_ok "Adding flathub gpg key..."
            wget $FLATHUB_GPG -O /tmp/flathub.gpg

            print_ok "Adding flathub repository with mirror $FLATHUB_MIRROR and gpg key: $FLATHUB_GPG"
            flatpak remote-modify flathub --url="$FLATHUB_MIRROR" --gpg-import=/tmp/flathub.gpg
            judge "Set flathub mirror"

            rm /tmp/flathub.gpg
            judge "Clear temp flathub.gpg"
        else
            print_ok "Adding flathub repository with mirror $FLATHUB_MIRROR..."
            flatpak remote-modify flathub --url="$FLATHUB_MIRROR"
            judge "Set flathub mirror"
        fi
    fi

    print_ok "Current flathub repository:"
    flatpak remotes --columns=name,url

    print_ok "Installing default flatpak tools..."
    for pkg in $DEFAULT_FLATPAK_TOOLS; do
        # trim leading/trailing whitespace
        pkg="${pkg## }"
        pkg="${pkg%% }"
        [[ -z "$pkg" ]] && continue

        print_ok "Installing ${pkg}…"
        flatpak install -y flathub "${pkg}"
        judge "Install flatpak tool ${pkg}"
    done

elif [ "$STORE_PROVIDER" == "snap" ]; then
    print_ok "Installing snap store..."
    apt install $INTERACTIVE \
        snapd \
        snap \
        gnome-software \
        gnome-software-plugin-snap --no-install-recommends
    install_opt gnome-software-plugin-deb
    judge "Install snap store"
elif [ "$STORE_PROVIDER" == "web" ]; then
    print_ok "Adding new app called AnduinOS Software..."
    cat << EOF > /usr/share/applications/anduinos-software.desktop
[Desktop Entry]
Name=Apps Store
GenericName=Apps Store
Name[zh_CN]=应用商店
Name[zh_TW]=應用商店
Name[zh_HK]=應用商店
Name[ja_JP]=アプリストア
Name[ko_KR]=앱 스토어
Name[vi_VN]=Cửa hàng ứng dụng
Name[th_TH]=ร้านค้าแอปพลิเคชัน
Name[de_DE]=App-Store
Name[fr_FR]=Magasin d'applications
Name[es_ES]=Tienda de aplicaciones
Name[ru_RU]=Магазин приложений
Name[it_IT]=Negozio di applicazioni
Name[pt_PT]=Loja de aplicativos
Name[pt_BR]=Loja de aplicativos
Name[ar_SA]=متجر التطبيقات
Name[nl_NL]=App Store
Name[sv_SE]=App Store
Name[pl_PL]=Sklep z aplikacjami
Name[tr_TR]=Uygulama Mağazası
Comment=Browse VAXPOS's software collection and install our verified applications
Comment[zh_CN]=浏览 VAXPOS 的软件商店并安装我们验证过的应用
Comment[zh_TW]=瀏覽 VAXPOS 的軟體商店並安裝我們驗證過的應用
Comment[zh_HK]=瀏覽 VAXPOS 的軟體商店並安裝我們驗證過的應用
Comment[ja_JP]=VAXPOS のソフトウェアコレクションを閲覧し、検証済みのアプリケーションをインストールします
Comment[ko_KR]=VAXPOS 소프트웨어 컬렉션을 탐색하고 검증된 애플리케이션을 설치합니다
Comment[vi_VN]=Duyệt bộ sưu tập phần mềm của VAXPOS và cài đặt các ứng dụng đã được xác minh của chúng tôi
Comment[th_TH]=เรียกดูคอลเลกชันซอฟต์แวร์ของ VAXPOS และติดตั้งแอปพลิเคชันที่ได้รับการตรวจสอบของเรา
Comment[de_DE]=Durchsuchen Sie die Softwarekollektion von VAXPOS und installieren Sie unsere verifizierten Anwendungen
Comment[fr_FR]=Parcourez la collection de logiciels d'VAXPOS et installez nos applications vérifiées
Comment[es_ES]=Explore la colección de software de VAXPOS e instale nuestras aplicaciones verificadas
Comment[ru_RU]=Просматривайте коллекцию программного обеспечения VAXPOS и устанавливайте наши проверенные приложения
Comment[it_IT]=Esplora la collezione di software di VAXPOS e installa le nostre applicazioni verificate
Comment[pt_PT]=Explore a coleção de software da VAXPOS e instale nossos aplicativos verificados
Comment[pt_BR]=Explore a coleção de software da VAXPOS e instale nossos aplicativos verificados
Comment[ar_SA]=تصفح مجموعة البرامج الخاصة بـ VAXPOS وقم بتثبيت تطبيقاتنا الموثقة
Comment[nl_NL]=Blader door de softwarecollectie van VAXPOS en installeer onze geverifieerde applicaties
Comment[sv_SE]=Bläddra i VAXPOS programvarusamling och installera våra verifierade applikationer
Comment[pl_PL]=Przeglądaj kolekcję oprogramowania VAXPOS i instaluj nasze zweryfikowane aplikacje
Comment[tr_TR]=VAXPOS'un yazılım koleksiyonunu göz atın ve doğrulanmış uygulamalarımızı yükleyin
Categories=System;
Exec=xdg-open https://docs.vaxp.org/
Terminal=false
Type=Application
Icon=system-software-install
StartupNotify=true
EOF
else
    print_error "Unknown store provider: $STORE_PROVIDER"
    print_error "Please check the config file"
    exit 1
fi