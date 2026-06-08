# Copyright 2026 Kirill Kirilenko
EAPI=8

inherit unpacker

DESCRIPTION="Proxmox Backup Client"
HOMEPAGE="https://proxmox.com"
SRC_URI="http://download.proxmox.com/debian/pbs-client/dists/trixie/main/binary-amd64/proxmox-backup-client-static_${PV}-1_amd64.deb"
S="${WORKDIR}"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="amd64"
RESTRICT="strip"

IUSE="+bash-completion +man zsh-completion"

src_install() {
	insinto /usr/bin
	doins usr/bin/proxmox-backup-client
	fperms 755 usr/bin/proxmox-backup-client
	doins usr/bin/pxar
	fperms 755 usr/bin/pxar

    if use bash-completion; then
	    insinto /usr/share/bash-completion/completions
	    doins usr/share/bash-completion/completions/proxmox-backup-client
	    doins usr/share/bash-completion/completions/pxar
	fi

    if use man; then
        unpack usr/share/man/man1/proxmox-backup-client.1.gz
        doman proxmox-backup-client.1
        unpack usr/share/man/man1/pxar.1.gz
        doman pxar.1
    fi

    if use zsh-completion; then
	    insinto /usr/share/zsh/vendor-completions
	    doins usr/share/zsh/vendor-completions/_proxmox-backup-client
	    doins usr/share/zsh/vendor-completions/_pxar
	fi
}
