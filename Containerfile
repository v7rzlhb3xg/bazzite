ARG BASE_IMAGE_NAME="${BASE_IMAGE_NAME:-kinoite}"
ARG BASE_IMAGE_FLAVOR="${BASE_IMAGE_FLAVOR:-main}"
ARG IMAGE_FLAVOR="${IMAGE_FLAVOR:-main}"
ARG KERNEL_FLAVOR="${KERNEL_FLAVOR:-fsync}"
ARG IMAGE_BRANCH="${IMAGE_BRANCH:-main}"
ARG SOURCE_IMAGE="${SOURCE_IMAGE:-$BASE_IMAGE_NAME-$BASE_IMAGE_FLAVOR}"
ARG BASE_IMAGE="ghcr.io/ublue-os/${SOURCE_IMAGE}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-40}"

FROM ghcr.io/ublue-os/akmods:${KERNEL_FLAVOR}-${FEDORA_MAJOR_VERSION} AS akmods
FROM ghcr.io/ublue-os/akmods-extra:${KERNEL_FLAVOR}-${FEDORA_MAJOR_VERSION} AS akmods-extra
FROM ghcr.io/ublue-os/fsync:latest AS fsync

FROM ${BASE_IMAGE}:${FEDORA_MAJOR_VERSION} AS bazzite

ARG IMAGE_NAME="${IMAGE_NAME:-bazzite}"
ARG IMAGE_VENDOR="${IMAGE_VENDOR:-ublue-os}"
ARG IMAGE_FLAVOR="${IMAGE_FLAVOR:-main}"
ARG KERNEL_FLAVOR="${KERNEL_FLAVOR:-fsync}"
ARG IMAGE_BRANCH="${IMAGE_BRANCH:-main}"
ARG BASE_IMAGE_NAME="${BASE_IMAGE_NAME:-kinoite}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-40}"
ARG JUPITER_KERNEL_VERSION="${JUPITER_KERNEL_VERSION:-jupiter-20240605.1}"

COPY system_files/desktop/shared system_files/desktop/${BASE_IMAGE_NAME} /

# Update packages that commonly cause build issues
RUN rpm-ostree override replace \
    --experimental \
    --from repo=updates \
        vulkan-loader \
        || true && \
    rpm-ostree override replace \
    --experimental \
    --from repo=updates \
        alsa-lib \
        || true && \
    rpm-ostree override replace \
    --experimental \
    --from repo=updates \
        gnutls \
        || true && \
    rpm-ostree override replace \
    --experimental \
    --from repo=updates \
        glib2 \
        || true && \
    rpm-ostree override replace \
    --experimental \
    --from repo=updates \
        gtk3 \
        || true && \
    rpm-ostree override replace \
    --experimental \
    --from repo=updates \
        atk \
        at-spi2-atk \
        || true && \
    rpm-ostree override replace \
    --experimental \
    --from repo=updates \
        libaom \
        || true && \
    rpm-ostree override replace \
    --experimental \
    --from repo=updates \
        gstreamer1 \
        gstreamer1-plugins-base \
        || true && \
    rpm-ostree override replace \
    --experimental \
    --from repo=updates \
        libdecor \
        || true && \
    rpm-ostree override replace \
    --experimental \
    --from repo=updates \
        libtirpc \
        || true && \
    rpm-ostree override replace \
    --experimental \
    --from repo=updates \
        libuuid \
        || true && \
    rpm-ostree override replace \
    --experimental \
    --from repo=updates \
        libblkid \
        || true && \
    rpm-ostree override replace \
    --experimental \
    --from repo=updates \
        libmount \
        || true && \
    rpm-ostree override replace \
    --experimental \
    --from repo=updates \
        cups-libs \
        || true && \
    rpm-ostree override replace \
    --experimental \
    --from repo=updates \
        libinput \
        || true && \
    rpm-ostree override replace \
    --experimental \
    --from repo=updates \
        libopenmpt \
        || true && \
    rpm-ostree override replace \
    --experimental \
    --from repo=updates \
        llvm-libs \
        || true && \
    rpm-ostree override replace \
    --experimental \
    --from repo=updates \
        zlib-ng-compat \
        || true && \
    rpm-ostree override replace \
    --experimental \
    --from repo=updates \
        fontconfig \
        || true && \
    rpm-ostree override remove \
        glibc32 \
        || true && \
    ostree container commit

# Setup Copr repos
RUN curl -Lo /usr/bin/copr https://raw.githubusercontent.com/ublue-os/COPR-command/main/copr && \
    chmod +x /usr/bin/copr && \
    curl -Lo /etc/yum.repos.d/_copr_kylegospo-bazzite.repo https://copr.fedorainfracloud.org/coprs/kylegospo/bazzite/repo/fedora-"${FEDORA_MAJOR_VERSION}"/kylegospo-bazzite-fedora-"${FEDORA_MAJOR_VERSION}".repo && \
    curl -Lo /etc/yum.repos.d/_copr_kylegospo-bazzite-multilib.repo https://copr.fedorainfracloud.org/coprs/kylegospo/bazzite-multilib/repo/fedora-"${FEDORA_MAJOR_VERSION}"/kylegospo-bazzite-multilib-fedora-"${FEDORA_MAJOR_VERSION}".repo?arch=x86_64 && \
    curl -Lo /etc/yum.repos.d/_copr_ublue-os-staging.repo https://copr.fedorainfracloud.org/coprs/ublue-os/staging/repo/fedora-"${FEDORA_MAJOR_VERSION}"/ublue-os-staging-fedora-"${FEDORA_MAJOR_VERSION}".repo?arch=x86_64 && \
    curl -Lo /etc/yum.repos.d/_copr_kylegospo-latencyflex.repo https://copr.fedorainfracloud.org/coprs/kylegospo/LatencyFleX/repo/fedora-"${FEDORA_MAJOR_VERSION}"/kylegospo-LatencyFleX-fedora-"${FEDORA_MAJOR_VERSION}".repo && \
    curl -Lo /etc/yum.repos.d/_copr_kylegospo-obs-vkcapture.repo https://copr.fedorainfracloud.org/coprs/kylegospo/obs-vkcapture/repo/fedora-"${FEDORA_MAJOR_VERSION}"/kylegospo-obs-vkcapture-fedora-"${FEDORA_MAJOR_VERSION}".repo?arch=x86_64 && \
    curl -Lo /etc/yum.repos.d/_copr_kylegospo-wallpaper-engine-kde-plugin.repo https://copr.fedorainfracloud.org/coprs/kylegospo/wallpaper-engine-kde-plugin/repo/fedora-"${FEDORA_MAJOR_VERSION}"/kylegospo-wallpaper-engine-kde-plugin-fedora-"${FEDORA_MAJOR_VERSION}".repo && \
    curl -Lo /etc/yum.repos.d/_copr_ycollet-audinux.repo https://copr.fedorainfracloud.org/coprs/ycollet/audinux/repo/fedora-"${FEDORA_MAJOR_VERSION}"/ycollet-audinux-fedora-"${FEDORA_MAJOR_VERSION}".repo && \
    curl -Lo /etc/yum.repos.d/_copr_kylegospo-rom-properties.repo https://copr.fedorainfracloud.org/coprs/kylegospo/rom-properties/repo/fedora-"${FEDORA_MAJOR_VERSION}"/kylegospo-rom-properties-fedora-"${FEDORA_MAJOR_VERSION}".repo && \
    curl -Lo /etc/yum.repos.d/_copr_kylegospo-joycond.repo https://copr.fedorainfracloud.org/coprs/kylegospo/joycond/repo/fedora-"${FEDORA_MAJOR_VERSION}"/kylegospo-joycond-fedora-"${FEDORA_MAJOR_VERSION}".repo && \
    curl -Lo /etc/yum.repos.d/_copr_kylegospo-webapp-manager.repo https://copr.fedorainfracloud.org/coprs/kylegospo/webapp-manager/repo/fedora-"${FEDORA_MAJOR_VERSION}"/kylegospo-webapp-manager-fedora-"${FEDORA_MAJOR_VERSION}".repo && \
    curl -Lo /etc/yum.repos.d/_copr_hhd-dev-hhd.repo https://copr.fedorainfracloud.org/coprs/hhd-dev/hhd/repo/fedora-"${FEDORA_MAJOR_VERSION}"/hhd-dev-hhd-fedora-"${FEDORA_MAJOR_VERSION}".repo && \
    curl -Lo /etc/yum.repos.d/_copr_che-nerd-fonts.repo https://copr.fedorainfracloud.org/coprs/che/nerd-fonts/repo/fedora-"${FEDORA_MAJOR_VERSION}"/che-nerd-fonts-fedora-"${FEDORA_MAJOR_VERSION}".repo && \
    curl -Lo /etc/yum.repos.d/_copr_sentry-switcheroo-control_discrete.repo https://copr.fedorainfracloud.org/coprs/sentry/switcheroo-control_discrete/repo/fedora-"${FEDORA_MAJOR_VERSION}"/sentry-switcheroo-control_discrete-fedora-"${FEDORA_MAJOR_VERSION}".repo && \
    curl -Lo /etc/yum.repos.d/_copr_hikariknight-looking-glass-kvmfr.repo https://copr.fedorainfracloud.org/coprs/hikariknight/looking-glass-kvmfr/repo/fedora-"${FEDORA_MAJOR_VERSION}"/hikariknight-looking-glass-kvmfr-fedora-"${FEDORA_MAJOR_VERSION}".repo && \
    curl -Lo /etc/yum.repos.d/_copr_mavit-discover-overlay.repo https://copr.fedorainfracloud.org/coprs/mavit/discover-overlay/repo/fedora-"${FEDORA_MAJOR_VERSION}"/mavit-discover-overlay-fedora-"${FEDORA_MAJOR_VERSION}".repo && \
    curl -Lo /etc/yum.repos.d/_copr_matte-schwartz-sunshine.repo https://copr.fedorainfracloud.org/coprs/matte-schwartz/sunshine/repo/fedora-"${FEDORA_MAJOR_VERSION}"/matte-schwartz-sunshine-fedora-"${FEDORA_MAJOR_VERSION}".repo && \
    curl -Lo /etc/yum.repos.d/_copr_rok-cdemu.repo https://copr.fedorainfracloud.org/coprs/rok/cdemu/repo/fedora-"${FEDORA_MAJOR_VERSION}"/rok-cdemu-fedora-"${FEDORA_MAJOR_VERSION}".rep && \
    curl -Lo /etc/yum.repos.d/_copr_rodoma92-kde-cdemu-manager.repo https://copr.fedorainfracloud.org/coprs/rodoma92/kde-cdemu-manager/repo/fedora-"${FEDORA_MAJOR_VERSION}"/rodoma92-kde-cdemu-manager-fedora-"${FEDORA_MAJOR_VERSION}".repo && \
    curl -Lo /etc/yum.repos.d/_copr_rodoma92-rmlint.repo https://copr.fedorainfracloud.org/coprs/rodoma92/rmlint/repo/fedora-"${FEDORA_MAJOR_VERSION}"/rodoma92-rmlint-fedora-"${FEDORA_MAJOR_VERSION}".repo && \
    curl -Lo /etc/yum.repos.d/tailscale.repo https://pkgs.tailscale.com/stable/fedora/tailscale.repo && \
    sed -i 's@gpgcheck=1@gpgcheck=0@g' /etc/yum.repos.d/tailscale.repo && \
    ostree container commit

# Install kernel-fsync
COPY --from=fsync /tmp/rpms /tmp/fsync-rpms
RUN rpm-ostree cliwrap install-to-root / && \
    if [[ "${KERNEL_FLAVOR}" =~ "fsync" ]]; then \
        echo "Will install ${KERNEL_FLAVOR} kernel" && \
        rpm-ostree override replace \
        --experimental \
            /tmp/fsync-rpms/kernel-6*.rpm \
            /tmp/fsync-rpms/kernel-core-*.rpm \
            /tmp/fsync-rpms/kernel-modules-*.rpm \
            /tmp/fsync-rpms/kernel-uki-virt-*.rpm \
    ; else \
        echo "will use kernel from ${KERNEL_FLAVOR} images" \
    ; fi && \
    ostree container commit

# Setup firmware
RUN mkdir -p /tmp/linux-firmware-neptune && \
    curl -Lo /tmp/linux-firmware-neptune/cs35l41-dsp1-spk-cali.bin https://gitlab.com/evlaV/linux-firmware-neptune/-/raw/"${JUPITER_KERNEL_VERSION}"/cs35l41-dsp1-spk-cali.bin && \
    curl -Lo /tmp/linux-firmware-neptune/cs35l41-dsp1-spk-cali.wmfw https://gitlab.com/evlaV/linux-firmware-neptune/-/raw/"${JUPITER_KERNEL_VERSION}"/cs35l41-dsp1-spk-cali.wmfw && \
    curl -Lo /tmp/linux-firmware-neptune/cs35l41-dsp1-spk-prot.bin https://gitlab.com/evlaV/linux-firmware-neptune/-/raw/"${JUPITER_KERNEL_VERSION}"/cs35l41-dsp1-spk-prot.bin && \
    curl -Lo /tmp/linux-firmware-neptune/cs35l41-dsp1-spk-prot.wmfw https://gitlab.com/evlaV/linux-firmware-neptune/-/raw/"${JUPITER_KERNEL_VERSION}"/cs35l41-dsp1-spk-prot.wmfw && \
    xz --check=crc32 /tmp/linux-firmware-neptune/cs35l41-dsp1-spk-{cali.bin,cali.wmfw,prot.bin,prot.wmfw} && \
    mv -vf /tmp/linux-firmware-neptune/* /usr/lib/firmware/cirrus/ && \
    rm -rf /tmp/linux-firmware-neptune && \
    mkdir -p /tmp/linux-firmware-galileo && \
    curl https://gitlab.com/evlaV/linux-firmware-neptune/-/archive/"${JUPITER_KERNEL_VERSION}"/linux-firmware-neptune-"${JUPITER_KERNEL_VERSION}".tar.gz?path=ath11k/QCA206X -o /tmp/linux-firmware-galileo/ath11k.tar.gz && \
    tar --strip-components 1 --no-same-owner --no-same-permissions --no-overwrite-dir -xvf /tmp/linux-firmware-galileo/ath11k.tar.gz -C /tmp/linux-firmware-galileo && \
    xz --check=crc32 /tmp/linux-firmware-galileo/ath11k/QCA206X/hw2.1/* && \
    mv -vf /tmp/linux-firmware-galileo/ath11k/QCA206X /usr/lib/firmware/ath11k/QCA206X && \
    rm -rf /tmp/linux-firmware-galileo/ath11k && \
    rm -rf /tmp/linux-firmware-galileo/ath11k.tar.gz && \
    ln -s QCA206X /usr/lib/firmware/ath11k/QCA2066 && \
    curl -Lo /tmp/linux-firmware-galileo/hpbtfw21.tlv https://gitlab.com/evlaV/linux-firmware-neptune/-/raw/"${JUPITER_KERNEL_VERSION}"/qca/hpbtfw21.tlv && \
    curl -Lo /tmp/linux-firmware-galileo/hpnv21.309 https://gitlab.com/evlaV/linux-firmware-neptune/-/raw/"${JUPITER_KERNEL_VERSION}"/qca/hpnv21.309 && \
    curl -Lo /tmp/linux-firmware-galileo/hpnv21.bin https://gitlab.com/evlaV/linux-firmware-neptune/-/raw/"${JUPITER_KERNEL_VERSION}"/qca/hpnv21.bin && \
    curl -Lo /tmp/linux-firmware-galileo/hpnv21g.309 https://gitlab.com/evlaV/linux-firmware-neptune/-/raw/"${JUPITER_KERNEL_VERSION}"/qca/hpnv21g.309 && \
    curl -Lo /tmp/linux-firmware-galileo/hpnv21g.bin https://gitlab.com/evlaV/linux-firmware-neptune/-/raw/"${JUPITER_KERNEL_VERSION}"/qca/hpnv21g.bin && \
    xz --check=crc32 /tmp/linux-firmware-galileo/* && \
    mv -vf /tmp/linux-firmware-galileo/* /usr/lib/firmware/qca/ && \
    rm -rf /tmp/linux-firmware-galileo && \
    rm -rf /usr/share/alsa/ucm2/conf.d/acp5x/Valve-Jupiter-1.conf && \
    if [[ "${IMAGE_FLAVOR}" =~ "asus" ]]; then \
        curl -Lo /etc/yum.repos.d/_copr_lukenukem-asus-linux.repo https://copr.fedorainfracloud.org/coprs/lukenukem/asus-linux/repo/fedora-$(rpm -E %fedora)/lukenukem-asus-linux-fedora-$(rpm -E %fedora).repo && \
        rpm-ostree install \
            asusctl \
            asusctl-rog-gui && \
        git clone https://gitlab.com/asus-linux/firmware.git --depth 1 /tmp/asus-firmware && \
        cp -rf /tmp/asus-firmware/* /usr/lib/firmware/ && \
        rm -rf /tmp/asus-firmware \
    ; fi && \
    ostree container commit

# Add ublue packages, add needed negativo17 repo and then immediately disable due to incompatibility with RPMFusion
COPY --from=akmods /rpms /tmp/akmods-rpms
COPY --from=akmods-extra /rpms /tmp/akmods-rpms
RUN sed -i 's@enabled=0@enabled=1@g' /etc/yum.repos.d/_copr_ublue-os-akmods.repo && \
    curl -Lo /etc/yum.repos.d/negativo17-fedora-multimedia.repo https://negativo17.org/repos/fedora-multimedia.repo && \
    rpm-ostree install \
        /tmp/akmods-rpms/kmods/*kvmfr*.rpm \
        /tmp/akmods-rpms/kmods/*xone*.rpm \
        /tmp/akmods-rpms/kmods/*openrazer*.rpm \
        /tmp/akmods-rpms/kmods/*v4l2loopback*.rpm \
        /tmp/akmods-rpms/kmods/*wl*.rpm \
        /tmp/akmods-rpms/kmods/*gcadapter_oc*.rpm \
        /tmp/akmods-rpms/kmods/*nct6687*.rpm \
        /tmp/akmods-rpms/kmods/*evdi*.rpm \
        /tmp/akmods-rpms/kmods/*zenergy*.rpm \
        /tmp/akmods-rpms/kmods/*vhba*.rpm \
        /tmp/akmods-rpms/kmods/*ayaneo-platform*.rpm \
        /tmp/akmods-rpms/kmods/*ayn-platform*.rpm \
        /tmp/akmods-rpms/kmods/*framework-laptop*.rpm \
        /tmp/akmods-rpms/kmods/*bmi260*.rpm \
        /tmp/akmods-rpms/kmods/*ryzen-smu*.rpm && \
    sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/negativo17-fedora-multimedia.repo && \
    ostree container commit

# Install Valve's patched Mesa, Pipewire, Bluez, and Xwayland
# Install patched switcheroo control with proper discrete GPU support
RUN rpm-ostree override remove \
        mesa-va-drivers-freeworld && \
    rpm-ostree override replace \
    --experimental \
    --from repo=copr:copr.fedorainfracloud.org:kylegospo:bazzite-multilib \
        mesa-filesystem \
        mesa-libxatracker \
        mesa-libglapi \
        mesa-dri-drivers \
        mesa-libgbm \
        mesa-libEGL \
        mesa-vulkan-drivers \
        mesa-libGL \
        pipewire \
        pipewire-alsa \
        pipewire-gstreamer \
        pipewire-jack-audio-connection-kit \
        pipewire-jack-audio-connection-kit-libs \
        pipewire-libs \
        pipewire-pulseaudio \
        pipewire-utils \
        bluez \
        bluez-obexd \
        bluez-cups \
        bluez-libs \
        xorg-x11-server-Xwayland && \
    rpm-ostree install \
        mesa-va-drivers-freeworld \
        mesa-vdpau-drivers-freeworld.x86_64 \
        libaacs \
        libbdplus \
        libbluray && \
    rpm-ostree override replace \
    --experimental \
    --from repo=copr:copr.fedorainfracloud.org:sentry:switcheroo-control_discrete \
        switcheroo-control && \
    ostree container commit

# Remove unneeded packages
RUN rpm-ostree override remove \
        ublue-os-update-services \
        firefox \
        firefox-langpacks \
        htop && \
    ostree container commit

# Install new packages
RUN rpm-ostree install \
        discover-overlay \
        python3-pip \
        libadwaita \
        duperemove \
        sqlite \
        xwininfo \
        xrandr \
        compsize \
        ryzenadj \
        input-remapper \
        i2c-tools \
        udica \
        joycond \
        ladspa-caps-plugins \
        ladspa-noise-suppression-for-voice \
        python3-icoextract \
        tailscale \
        webapp-manager \
        btop \
        fish \
        lshw \
        xdotool \
        wmctrl \
        libcec \
        yad \
        f3 \
        pulseaudio-utils \
        unrar \
        lzip \
        libxcrypt-compat \
        mesa-libGLU \
        vulkan-tools \
        glibc.i686 \
        extest.i686 \
        xwiimote-ng \
        twitter-twemoji-fonts \
        google-noto-sans-cjk-fonts \
        lato-fonts \
        fira-code-fonts \
        nerd-fonts \
        fastfetch \
        glow \
        gum \
        vim \
        cockpit-networkmanager \
        cockpit-podman \
        cockpit-selinux \
        cockpit-system \
        cockpit-navigator \
        cockpit-storaged \
        ydotool \
        lsb_release && \
    pip install --prefix=/usr topgrade && \
    rpm-ostree install \
        ublue-update && \
    mkdir -p /usr/etc/xdg/autostart && \
    sed -i '1s/^/[include]\npaths = ["\/etc\/ublue-os\/topgrade.toml"]\n\n/' /usr/share/ublue-update/topgrade-user.toml && \
    sed -i 's/min_battery_percent.*/min_battery_percent = 20.0/' /usr/etc/ublue-update/ublue-update.toml && \
    sed -i 's/max_cpu_load_percent.*/max_cpu_load_percent = 100.0/' /usr/etc/ublue-update/ublue-update.toml && \
    sed -i 's/max_mem_percent.*/max_mem_percent = 90.0/' /usr/etc/ublue-update/ublue-update.toml && \
    sed -i 's/dbus_notify.*/dbus_notify = false/' /usr/etc/ublue-update/ublue-update.toml && \
    curl -Lo /usr/bin/installcab https://raw.githubusercontent.com/KyleGospo/steam-proton-mf-wmv/master/installcab.py && \
    chmod +x /usr/bin/installcab && \
    curl -Lo /usr/bin/install-mf-wmv https://github.com/KyleGospo/steam-proton-mf-wmv/blob/master/install-mf-wmv.sh && \
    chmod +x /usr/bin/install-mf-wmv && \
    curl -Lo /usr/share/thumbnailers/exe-thumbnailer.thumbnailer https://raw.githubusercontent.com/jlu5/icoextract/master/exe-thumbnailer.thumbnailer && \
    ostree container commit

# Install Steam & Lutris, plus supporting packages
RUN rpm-ostree install \
        jupiter-sd-mounting-btrfs \
        at-spi2-core.i686 \
        atk.i686 \
        vulkan-loader.i686 \
        alsa-lib.i686 \
        fontconfig.i686 \
        gtk2.i686 \
        libICE.i686 \
        libnsl.i686 \
        libxcrypt-compat.i686 \
        libpng12.i686 \
        libXext.i686 \
        libXinerama.i686 \
        libXtst.i686 \
        libXScrnSaver.i686 \
        NetworkManager-libnm.i686 \
        nss.i686 \
        pulseaudio-libs.i686 \
        libcurl.i686 \
        systemd-libs.i686 \
        libva.i686 \
        libvdpau.i686 \
        libdbusmenu-gtk3.i686 \
        libatomic.i686 \
        pipewire-alsa.i686 \
        gobject-introspection \
        clinfo && \
    sed -i '0,/enabled=1/s//enabled=0/' /etc/yum.repos.d/fedora-updates.repo && \
    rpm-ostree install \
        mesa-vulkan-drivers.i686 \
        mesa-va-drivers-freeworld.i686 \
        mesa-vdpau-drivers-freeworld.i686 && \
    sed -i '0,/enabled=0/s//enabled=1/' /etc/yum.repos.d/rpmfusion-nonfree-steam.repo && \
    sed -i '0,/enabled=1/s//enabled=0/' /etc/yum.repos.d/rpmfusion-nonfree.repo && \
    sed -i '0,/enabled=1/s//enabled=0/' /etc/yum.repos.d/rpmfusion-nonfree-updates.repo && \
    sed -i '0,/enabled=1/s//enabled=0/' /etc/yum.repos.d/rpmfusion-nonfree-updates-testing.repo && \
    rpm-ostree install \
        steam && \
    sed -i '0,/enabled=1/s//enabled=0/' /etc/yum.repos.d/rpmfusion-nonfree-steam.repo && \
    sed -i '0,/enabled=0/s//enabled=1/' /etc/yum.repos.d/rpmfusion-nonfree.repo && \
    sed -i '0,/enabled=0/s//enabled=1/' /etc/yum.repos.d/rpmfusion-nonfree-updates.repo && \
    sed -i '0,/enabled=0/s//enabled=1/' /etc/yum.repos.d/rpmfusion-nonfree-updates-testing.repo && \
    sed -i '0,/enabled=0/s//enabled=1/' /etc/yum.repos.d/fedora-updates.repo && \
    rpm-ostree install \
        lutris \
        wine-core.x86_64 \
        wine-core.i686 \
        wine-pulseaudio.x86_64 \
        wine-pulseaudio.i686 \
        winetricks \
        protontricks \
        latencyflex-vulkan-layer \
        vkBasalt.x86_64 \
        vkBasalt.i686 \
        obs-vkcapture.x86_64 \
        libobs_vkcapture.x86_64 \
        libobs_glcapture.x86_64 \
        obs-vkcapture.i686 \
        libobs_vkcapture.i686 \
        libobs_glcapture.i686 \
        mangohud.x86_64 \
        mangohud.i686 && \
    ln -s wine32 /usr/bin/wine && \
    ln -s wine32-preloader /usr/bin/wine-preloader && \
    ln -s wineserver64 /usr/bin/wineserver && \
    sed -i 's@\[Desktop Entry\]@\[Desktop Entry\]\nNoDisplay=true@g' /usr/share/applications/winetricks.desktop && \
    curl -Lo /tmp/latencyflex.tar.xz $(curl https://api.github.com/repos/ishitatsuyuki/LatencyFleX/releases/latest | jq -r '.assets[] | select(.name| test(".*.tar.xz$")).browser_download_url') && \
    mkdir -p /tmp/latencyflex && \
    tar --no-same-owner --no-same-permissions --no-overwrite-dir --strip-components 1 -xvf /tmp/latencyflex.tar.xz -C /tmp/latencyflex && \
    rm -f /tmp/latencyflex.tar.xz && \
    cp -r /tmp/latencyflex/wine/usr/lib/wine/* /usr/lib64/wine/ && \
    rm -rf /tmp/latencyflex && \
    curl -Lo /usr/bin/latencyflex https://raw.githubusercontent.com/KyleGospo/LatencyFleX-Installer/main/install.sh && \
    chmod +x /usr/bin/latencyflex && \
    sed -i 's@/usr/lib/wine/@/usr/lib64/wine/@g' /usr/bin/latencyflex && \
    sed -i 's@"dxvk.conf"@"/usr/share/latencyflex/dxvk.conf"@g' /usr/bin/latencyflex && \
    chmod +x /usr/bin/latencyflex && \
    ostree container commit

# Configure KDE & GNOME
RUN if grep -q "kinoite" <<< "${BASE_IMAGE_NAME}"; then \
        rpm-ostree install \
            qt && \
        rpm-ostree override remove \
            plasma-welcome && \
        rpm-ostree override replace \
        --experimental \
        --from repo=copr:copr.fedorainfracloud.org:ublue-os:staging \
            kf6-kio-doc \
            kf6-kio-widgets-libs \
            kf6-kio-core-libs \
            kf6-kio-widgets \
            kf6-kio-file-widgets \
            kf6-kio-core \
            kf6-kio-gui && \
        rpm-ostree install \
            steamdeck-kde-presets-desktop \
            wallpaper-engine-kde-plugin \
            kdeconnectd \
            kdeplasma-addons \
            rom-properties-kf6 \
            joystickwake \
            fcitx5-mozc \
            fcitx5-chinese-addons \
            ptyxis && \
        git clone https://github.com/catsout/wallpaper-engine-kde-plugin.git --depth 1 --branch qt6 /tmp/wallpaper-engine-kde-plugin && \
        kpackagetool6 --type=Plasma/Wallpaper --global --install /tmp/wallpaper-engine-kde-plugin/plugin && \
        rm -rf /tmp/wallpaper-engine-kde-plugin && \
        sed -i '/<entry name="launchers" type="StringList">/,/<\/entry>/ s/<default>[^<]*<\/default>/<default>preferred:\/\/browser,applications:steam.desktop,applications:net.lutris.Lutris.desktop,applications:org.gnome.Ptyxis.desktop,applications:org.kde.discover.desktop,preferred:\/\/filemanager<\/default>/' /usr/share/plasma/plasmoids/org.kde.plasma.taskmanager/contents/config/main.xml && \
        sed -i '/<entry name="favorites" type="StringList">/,/<\/entry>/ s/<default>[^<]*<\/default>/<default>preferred:\/\/browser,steam.desktop,net.lutris.Lutris.desktop,systemsettings.desktop,org.kde.dolphin.desktop,org.kde.kate.desktop,org.gnome.Ptyxis.desktop,org.kde.discover.desktop,system-update.desktop<\/default>/' /usr/share/plasma/plasmoids/org.kde.plasma.kickoff/contents/config/main.xml && \
        sed -i 's@\[Desktop Action new-window\]@\[Desktop Action new-window\]\nX-KDE-Shortcuts=Ctrl+Alt+T@g' /usr/share/applications/org.gnome.Ptyxis.desktop && \
        sed -i 's@Exec=ptyxis@Exec=kde-ptyxis@g' /usr/share/applications/org.gnome.Ptyxis.desktop && \
        sed -i 's@Keywords=@Keywords=konsole;console;@g' /usr/share/applications/org.gnome.Ptyxis.desktop && \
        cp /usr/share/applications/org.gnome.Ptyxis.desktop /usr/share/kglobalaccel/org.gnome.Ptyxis.desktop && \
        sed -i 's@\[Desktop Entry\]@\[Desktop Entry\]\nNoDisplay=true@g' /usr/share/applications/org.kde.konsole.desktop && \
        sed -i 's@\[Desktop Entry\]@\[Desktop Entry\]\nNoDisplay=true@g' /usr/share/applications/yad-icon-browser.desktop && \
        rm -f /usr/share/kglobalaccel/org.kde.konsole.desktop && \
        systemctl enable kde-sysmonitor-workaround.service \
    ; else \
        rpm-ostree override replace \
        --experimental \
        --from repo=copr:copr.fedorainfracloud.org:ublue-os:staging \
            mutter \
            mutter-common \
            gnome-shell && \
        rpm-ostree install \
            ptyxis \
            nautilus-open-any-terminal \
            nautilus-gsconnect \
            steamdeck-backgrounds \
            gnome-randr-rust \
            gnome-shell-extension-user-theme \
            gnome-shell-extension-gsconnect \
            gnome-shell-extension-compiz-windows-effect \
            gnome-shell-extension-compiz-alike-magic-lamp-effect \
            gnome-shell-extension-just-perfection \
            gnome-shell-extension-blur-my-shell \
            gnome-shell-extension-hanabi \
            gnome-shell-extension-gamerzilla \
            gnome-shell-extension-bazzite-menu \
            gnome-shell-extension-hotedge \
            gnome-shell-extension-caffeine \
            rom-properties-gtk3 \
            ibus-mozc \
            openssh-askpass && \
        rpm-ostree override remove \
            gnome-software-rpm-ostree \
            gnome-classic-session \
            gnome-classic-session-xsession \
            gnome-tour \
            gnome-extensions-app \
            gnome-terminal-nautilus \
            gnome-initial-setup && \
        sed -i 's@\[Desktop Entry\]@\[Desktop Entry\]\nNoDisplay=true@g' /usr/share/applications/org.gnome.Terminal.desktop && \
        sed -i 's@\[Desktop Entry\]@\[Desktop Entry\]\nNoDisplay=true@g' /usr/share/applications/org.gnome.SystemMonitor.desktop && \
        systemctl enable dconf-update.service \
    ; fi && \
    ostree container commit

# Install Gamescope, ROCM, and Waydroid on non-Nvidia images
RUN rpm-ostree install \
        gamescope.x86_64 \
        gamescope-libs.i686 \
        gamescope-shaders \
        rocm-hip \
        rocm-opencl \
        rocm-clinfo \
        waydroid \
        cage \
        wlr-randr && \
    sed -i~ -E 's/=.\$\(command -v (nft|ip6?tables-legacy).*/=/g' /usr/lib/waydroid/data/scripts/waydroid-net.sh && \
    ostree container commit

# Homebrew
RUN touch /.dockerenv && \
    mkdir -p /var/home && \
    mkdir -p /var/roothome && \
    curl -Lo /tmp/brew-install https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh && \
    chmod +x /tmp/brew-install && \
    /tmp/brew-install && \
    tar --zstd -cvf /usr/share/homebrew.tar.zst /home/linuxbrew/.linuxbrew && \
    ostree container commit

# Cleanup & Finalize
COPY system_files/overrides /
RUN rm -f /etc/profile.d/toolbox.sh && \
    cp --no-dereference --preserve=links /usr/lib/libdrm.so.2 /usr/lib/libdrm.so && \
    cp --no-dereference --preserve=links /usr/lib64/libdrm.so.2 /usr/lib64/libdrm.so && \
    sed -i 's@/usr/bin/steam@/usr/bin/bazzite-steam@g' /usr/share/applications/steam.desktop && \
    mkdir -p /usr/etc/skel/.config/autostart/ && \
    cp "/usr/share/applications/steam.desktop" "/usr/etc/skel/.config/autostart/steam.desktop" && \
    sed -i 's@/usr/bin/bazzite-steam %U@/usr/bin/bazzite-steam -silent %U@g' /usr/etc/skel/.config/autostart/steam.desktop && \
    sed -i 's@\[Desktop Entry\]@\[Desktop Entry\]\nNoDisplay=true@g' /usr/share/applications/fish.desktop && \
    sed -i 's@\[Desktop Entry\]@\[Desktop Entry\]\nNoDisplay=true@g' /usr/share/applications/nvtop.desktop && \
    sed -i 's@\[Desktop Entry\]@\[Desktop Entry\]\nNoDisplay=true@g' /usr/share/applications/btop.desktop && \
    sed -i 's/#UserspaceHID.*/UserspaceHID=true/' /etc/bluetooth/input.conf && \
    rm -f /usr/share/vulkan/icd.d/lvp_icd.*.json && \
    mkdir -p "/usr/etc/profile.d/" && \
    ln -s "/usr/share/ublue-os/firstboot/launcher/login-profile.sh" \
    "/usr/etc/profile.d/ublue-firstboot.sh" && \
    mkdir -p "/usr/etc/xdg/autostart" && \
    cp "/usr/share/applications/discover_overlay.desktop" "/usr/etc/xdg/autostart/discover_overlay.desktop" && \
    sed -i 's@Exec=discover-overlay@Exec=/usr/bin/bazzite-discover-overlay@g' /usr/etc/xdg/autostart/discover_overlay.desktop && \
    sed -i 's@\[Desktop Entry\]@\[Desktop Entry\]\nNoDisplay=true@g' /usr/share/applications/discover_overlay.desktop && \
    cp "/usr/share/ublue-os/firstboot/yafti.yml" "/etc/yafti.yml" && \
    echo "import \"/usr/share/ublue-os/just/80-bazzite.just\"" >> /usr/share/ublue-os/justfile && \
    echo "import \"/usr/share/ublue-os/just/81-bazzite-fixes.just\"" >> /usr/share/ublue-os/justfile && \
    echo "import \"/usr/share/ublue-os/just/82-bazzite-apps.just\"" >> /usr/share/ublue-os/justfile && \
    echo "import \"/usr/share/ublue-os/just/82-bazzite-cdemu.just\"" >> /usr/share/ublue-os/justfile && \
    echo "import \"/usr/share/ublue-os/just/82-bazzite-sunshine.just\"" >> /usr/share/ublue-os/justfile && \
    echo "import \"/usr/share/ublue-os/just/82-bazzite-rmlint.just\"" >> /usr/share/ublue-os/justfile && \
    echo "import \"/usr/share/ublue-os/just/82-bazzite-waydroid.just\"" >> /usr/share/ublue-os/justfile && \
    echo "import \"/usr/share/ublue-os/just/83-bazzite-audio.just\"" >> /usr/share/ublue-os/justfile && \
    echo "import \"/usr/share/ublue-os/just/84-bazzite-virt.just\"" >> /usr/share/ublue-os/justfile && \
    echo "import \"/usr/share/ublue-os/just/85-bazzite-image.just\"" >> /usr/share/ublue-os/justfile && \
    echo "import \"/usr/share/ublue-os/just/90-bazzite-de.just\"" >> /usr/share/ublue-os/justfile && \
    pip install --prefix=/usr yafti && \
    sed -i 's/stage/none/g' /etc/rpm-ostreed.conf && \
    sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/_copr_ublue-os-akmods.repo && \
    sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/_copr_kylegospo-bazzite.repo && \
    sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/_copr_kylegospo-bazzite-multilib.repo && \
    sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/_copr_ublue-os-staging.repo && \
    sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/_copr_kylegospo-latencyflex.repo && \
    sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/_copr_kylegospo-obs-vkcapture.repo && \
    sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/_copr_kylegospo-wallpaper-engine-kde-plugin.repo && \
    sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/_copr_ycollet-audinux.repo && \
    sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/_copr_kylegospo-rom-properties.repo && \
    sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/_copr_kylegospo-joycond.repo && \
    sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/_copr_kylegospo-webapp-manager.repo && \
    sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/_copr_hhd-dev-hhd.repo && \
    sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/_copr_che-nerd-fonts.repo && \
    sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/_copr_sentry-switcheroo-control_discrete.repo && \
    sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/_copr_mavit-discover-overlay.repo && \
    sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/_copr_hikariknight-looking-glass-kvmfr.repo && \
    sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/tailscale.repo && \
    sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/charm.repo && \
    sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/rpmfusion-nonfree.repo && \
    sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/rpmfusion-nonfree-updates.repo && \
    sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/rpmfusion-nonfree-updates-testing.repo && \
    mkdir -p /usr/etc/flatpak/remotes.d && \
    curl -Lo /usr/etc/flatpak/remotes.d/flathub.flatpakrepo https://dl.flathub.org/repo/flathub.flatpakrepo && \
    systemctl enable brew-dir-fix.service && \
    systemctl enable brew-setup.service && \
    systemctl enable brew-upgrade.timer && \
    systemctl enable brew-update.timer && \
    systemctl enable btrfs-dedup@var-home.timer && \
    systemctl enable displaylink.service && \
    systemctl enable input-remapper.service && \
    systemctl unmask bazzite-flatpak-manager.service && \
    systemctl enable bazzite-flatpak-manager.service && \
    systemctl disable rpm-ostreed-automatic.timer && \
    systemctl enable ublue-update.timer && \
    systemctl enable gamescope-workaround.service && \
    systemctl enable waydroid-workaround.service && \
    systemctl enable incus-workaround.service && \
    systemctl enable bazzite-hardware-setup.service && \
    systemctl enable tailscaled.service && \
    systemctl enable dev-hugepages1G.mount && \
    systemctl disable joycond.service && \
    systemctl --global enable bazzite-user-setup.service && \
    systemctl --global enable podman.socket && \
    systemctl --global enable systemd-tmpfiles-setup.service && \
    if grep -q "kinoite" <<< "${BASE_IMAGE_NAME}"; then \
        sed -i '/^PRETTY_NAME/s/Kinoite/Bazzite/' /usr/lib/os-release \
    ; else \
        sed -i 's@\[Desktop Entry\]@\[Desktop Entry\]\nNoDisplay=true@g' /usr/share/applications/yad-icon-browser.desktop && \
        sed -i '/^PRETTY_NAME/s/Silverblue/Bazzite GNOME/' /usr/lib/os-release \
    ; fi && \
    systemctl disable waydroid-container.service && \
    curl -Lo /usr/etc/dxvk-example.conf https://raw.githubusercontent.com/doitsujin/dxvk/master/dxvk.conf && \
    curl -Lo /usr/bin/waydroid-choose-gpu https://raw.githubusercontent.com/KyleGospo/waydroid-scripts/main/waydroid-choose-gpu.sh && \
    chmod +x /usr/bin/waydroid-choose-gpu && \
    curl -Lo /usr/lib/sysctl.d/99-bore-scheduler.conf https://github.com/CachyOS/CachyOS-Settings/raw/master/usr/lib/sysctl.d/99-bore-scheduler.conf && \
    /usr/libexec/containerbuild/image-info && \
    /usr/libexec/containerbuild/build-initramfs && \
    ostree container commit

FROM bazzite AS bazzite-deck

ARG IMAGE_NAME="${IMAGE_NAME:-bazzite-deck}"
ARG IMAGE_VENDOR="${IMAGE_VENDOR:-ublue-os}"
ARG IMAGE_FLAVOR="${IMAGE_FLAVOR:-main}"
ARG KERNEL_FLAVOR="${KERNEL_FLAVOR:-fsync}"
ARG IMAGE_BRANCH="${IMAGE_BRANCH:-main}"
ARG BASE_IMAGE_NAME="${BASE_IMAGE_NAME:-kinoite}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-40}"
ARG STEAM_PACKAGE_VERSION="${STEAM_PACKAGE_VERSION:-steam-jupiter-stable-1.0.0.79-1-x86_64}"

COPY system_files/deck/shared system_files/deck/${BASE_IMAGE_NAME} /

# Setup Copr repos
RUN sed -i 's@enabled=0@enabled=1@g' /etc/yum.repos.d/_copr_ublue-os-akmods.repo && \
    sed -i 's@enabled=0@enabled=1@g' /etc/yum.repos.d/_copr_kylegospo-bazzite.repo && \
    sed -i 's@enabled=0@enabled=1@g' /etc/yum.repos.d/_copr_kylegospo-bazzite-multilib.repo && \
    sed -i 's@enabled=0@enabled=1@g' /etc/yum.repos.d/_copr_kylegospo-latencyflex.repo && \
    sed -i 's@enabled=0@enabled=1@g' /etc/yum.repos.d/_copr_kylegospo-obs-vkcapture.repo && \
    sed -i 's@enabled=0@enabled=1@g' /etc/yum.repos.d/_copr_kylegospo-wallpaper-engine-kde-plugin.repo && \
    sed -i 's@enabled=0@enabled=1@g' /etc/yum.repos.d/_copr_hhd-dev-hhd.repo && \
    sed -i 's@enabled=0@enabled=1@g' /etc/yum.repos.d/_copr_ycollet-audinux.repo && \
    ostree container commit

# Configure KDE & GNOME
RUN rpm-ostree override remove \
        jupiter-sd-mounting-btrfs && \
    if grep -q "kinoite" <<< "${BASE_IMAGE_NAME}"; then \
        rpm-ostree override remove \
            steamdeck-kde-presets-desktop && \
        rpm-ostree install \
            steamdeck-kde-presets \
    ; else \
        rpm-ostree install \
            steamdeck-gnome-presets \
            gnome-shell-extension-caribou-blocker \
            sddm \
    ; fi && \
    ostree container commit

# Install new packages
# Dock updater - done manually due to proprietary parts preventing it from being on Copr
# Neptune firmware - done manually due to "TBD" license on needed audio firmware
RUN rpm-ostree install \
    jupiter-fan-control \
    jupiter-hw-support-btrfs \
    galileo-mura \
    steamdeck-dsp \
    powerbuttond \
    hhd \
    hhd-ui \
    adjustor \
    vpower \
    ds-inhibit \
    steam_notif_daemon \
    sdgyrodsu \
    ibus-pinyin \
    ibus-table-chinese-cangjie \
    ibus-table-chinese-quick \
    socat \
    zstd \
    zenity \
    newt \
    qt6-qtvirtualkeyboard \
    xorg-x11-server-Xvfb \
    python-vdf \
    python-crcmod && \
    git clone https://gitlab.com/evlaV/jupiter-dock-updater-bin.git \
        --depth 1 \
        /tmp/jupiter-dock-updater-bin && \
    mv -v /tmp/jupiter-dock-updater-bin/packaged/usr/lib/jupiter-dock-updater /usr/libexec/jupiter-dock-updater && \
    rm -rf /tmp/jupiter-dock-updater-bin && \
    ln -s /usr/bin/steamos-logger /usr/bin/steamos-info && \
    ln -s /usr/bin/steamos-logger /usr/bin/steamos-notice && \
    ln -s /usr/bin/steamos-logger /usr/bin/steamos-warning && \
    ostree container commit

# Install Steam Deck patched UPower
RUN rpm-ostree override replace \
    --experimental \
    --from repo=copr:copr.fedorainfracloud.org:kylegospo:bazzite \
        upower \
        upower-libs && \
    ostree container commit

# Install Gamescope Session & Supporting changes
# Add bootstraplinux_ubuntu12_32.tar.xz used by gamescope-session (Thanks ChimeraOS! - https://chimeraos.org/)
RUN curl -Lo /tmp/steam-jupiter.pkg.tar.zst https://steamdeck-packages.steamos.cloud/archlinux-mirror/jupiter-main/os/x86_64/"${STEAM_PACKAGE_VERSION}".pkg.tar.zst && \
    mkdir -p /usr/etc/first-boot && \
    tar --no-same-owner --no-same-permissions --no-overwrite-dir -I zstd -xvf /tmp/steam-jupiter.pkg.tar.zst usr/lib/steam/bootstraplinux_ubuntu12_32.tar.xz -o > /usr/etc/first-boot/bootstraplinux_ubuntu12_32.tar.xz && \
    rm -f /tmp/steam-jupiter.pkg.tar.zst && \
    rpm-ostree install \
        gamescope-session-plus \
        gamescope-session-steam && \
    ostree container commit

# Cleanup & Finalize
RUN /usr/libexec/containerbuild/image-info && \
    mkdir -p "/usr/etc/xdg/autostart" && \
    mv "/usr/etc/skel/.config/autostart/steam.desktop" "/usr/etc/xdg/autostart/steam.desktop" && \
    sed -i 's@Exec=waydroid first-launch@Exec=/usr/bin/waydroid-launcher first-launch\nX-Steam-Library-Capsule=/usr/share/applications/Waydroid/capsule.png\nX-Steam-Library-Hero=/usr/share/applications/Waydroid/hero.png\nX-Steam-Library-Logo=/usr/share/applications/Waydroid/logo.png\nX-Steam-Library-StoreCapsule=/usr/share/applications/Waydroid/store-logo.png\nX-Steam-Controller-Template=Desktop@g' /usr/share/applications/Waydroid.desktop && \
    if grep -q "kinoite" <<< "${BASE_IMAGE_NAME}"; then \
        sed -i 's/Exec=.*/Exec=systemctl start return-to-gamemode.service/' /etc/skel/Desktop/Return.desktop \
    ; fi && \
    sed -i 's@\[Desktop Entry\]@\[Desktop Entry\]\nNoDisplay=true@g' /usr/share/applications/input-remapper-gtk.desktop && \
    cp "/usr/share/ublue-os/firstboot/yafti.yml" "/usr/etc/yafti.yml" && \
    sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/_copr_ublue-os-akmods.repo && \
    sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/_copr_kylegospo-bazzite.repo && \
    sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/_copr_kylegospo-bazzite-multilib.repo && \
    sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/_copr_kylegospo-latencyflex.repo && \
    sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/_copr_kylegospo-obs-vkcapture.repo && \
    sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/_copr_kylegospo-wallpaper-engine-kde-plugin.repo && \
    sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/_copr_hhd-dev-hhd.repo && \
    sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/_copr_ycollet-audinux.repo && \
    if grep -q "silverblue" <<< "${BASE_IMAGE_NAME}"; then \
        systemctl disable gdm.service && \
        systemctl enable sddm.service \
    ; fi && \
    systemctl enable bazzite-autologin.service && \
    systemctl enable wireplumber-workaround.service && \
    systemctl enable wireplumber-sysconf.service && \
    systemctl enable pipewire-workaround.service && \
    systemctl enable pipewire-sysconf.service && \
    systemctl enable btrfs-dedup@run-media-mmcblk0p1.timer && \
    systemctl enable ds-inhibit.service && \
    systemctl enable cec-onboot.service && \
    systemctl enable cec-onpoweroff.service && \
    systemctl enable cec-onsleep.service && \
    systemctl enable bazzite-tdpfix.service && \
    systemctl --global enable steam-web-debug-portforward.service && \
    systemctl --global disable sdgyrodsu.service && \
    systemctl disable input-remapper.service && \
    systemctl disable ublue-update.timer && \
    systemctl disable jupiter-fan-control.service && \
    systemctl disable vpower.service && \
    systemctl disable jupiter-biosupdate.service && \
    systemctl disable jupiter-controller-update.service && \
    systemctl disable batterylimit.service && \
    ostree container commit

FROM ghcr.io/ublue-os/akmods-nvidia:${KERNEL_FLAVOR}-${FEDORA_MAJOR_VERSION} AS nvidia-akmods

FROM bazzite AS bazzite-nvidia

ARG IMAGE_NAME="${IMAGE_NAME:-bazzite-nvidia}"
ARG IMAGE_VENDOR="${IMAGE_VENDOR:-ublue-os}"
ARG IMAGE_FLAVOR="${IMAGE_FLAVOR:-nvidia}"
ARG KERNEL_FLAVOR="${KERNEL_FLAVOR:-fsync}"
ARG IMAGE_BRANCH="${IMAGE_BRANCH:-main}"
ARG BASE_IMAGE_NAME="${BASE_IMAGE_NAME:-kinoite}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-40}"

# Fetch NVIDIA driver
COPY system_files/nvidia/shared system_files/nvidia/${BASE_IMAGE_NAME} /

# Remove everything that doesn't work well with NVIDIA
# Install X11 session (Remove me for Fedora 41)
RUN rpm-ostree override remove \
        rocm-hip \
        rocm-opencl \
        rocm-clinfo && \
    if [[ "${BASE_IMAGE_NAME}" == "kinoite" ]]; then \
        rpm-ostree install \
            plasma-workspace-x11 \
    ; fi && \
    ostree container commit

# Install NVIDIA driver
COPY --from=nvidia-akmods /rpms /tmp/akmods-rpms
RUN curl -Lo /tmp/nvidia-install.sh https://raw.githubusercontent.com/ublue-os/hwe/main/nvidia-install.sh && \
    chmod +x /tmp/nvidia-install.sh && \
    IMAGE_NAME="${BASE_IMAGE_NAME}" /tmp/nvidia-install.sh && \
    rm -f /usr/share/vulkan/icd.d/nouveau_icd.*.json && \
    ostree container commit

# Cleanup & Finalize
RUN echo "import \"/usr/share/ublue-os/just/95-bazzite-nvidia.just\"" >> /usr/share/ublue-os/justfile && \
    /usr/libexec/containerbuild/image-info && \
    /usr/libexec/containerbuild/build-initramfs && \
    ostree container commit
