#!/bin/bash

check () {
        if ! dracut_module_included "systemd"; then
                "luks-2fa needs systemd in the initramfs"
                return 1
        fi
        return 255
}

depends () {
        echo "systemd"
        return 0
}

install () {
        inst "$moddir/luks-2fa-generator.sh" "/etc/systemd/system-generators/luks-2fa-generator.sh"
        inst "$systemdutildir/systemd-cryptsetup"
        mkdir -p "$initdir/luks-2fa"

        inst "$moddir/luks-2fa.target" "/etc/systemd/system/luks-2fa.target"
        mkdir -p "$initdir/etc/systemd/system/luks-2fa.target.wants"

        mkdir -p "$initdir/etc/systemd/system/sysinit.target.wants"
        ln -sf "/etc/systemd/system/luks-2fa.target" "$initdir/etc/systemd/system/sysinit.target.wants/"
}
