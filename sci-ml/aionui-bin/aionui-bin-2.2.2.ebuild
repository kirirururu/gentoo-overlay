# Copyright 2026 Kirill Kirilenko

EAPI=8

inherit desktop unpacker xdg

DESCRIPTION="A Cowork platform where AI agents work alongside you on your computer"
HOMEPAGE="https://www.aionui.com"
SRC_URI="https://static.aionui.com/releases/${PV}/AionUi-${PV}-linux-amd64.deb"
S="${WORKDIR}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64"
RESTRICT="strip"

NODEJS_VERSION="24.11.0"

IUSE="+system-nodejs"

RDEPEND="
    system-nodejs? ( >=net-libs/nodejs-${NODEJS_VERSION} )
"

IDEPEND="
	dev-util/desktop-file-utils
	dev-util/gtk-update-icon-cache
"

src_install() {
    rm -r opt/AionUi/resources/app.asar.unpacked/node_modules/@napi-rs/canvas-linux-x64-musl

    if use system-nodejs; then
        rm -r opt/AionUi/resources/bundled-aioncore/linux-x64/managed-resources/node
    fi

	insinto /opt
	doins -r "opt/AionUi"

    fperms 755 /opt/AionUi/AionUi
    fperms 755 /opt/AionUi/chrome-sandbox
    fperms 755 /opt/AionUi/chrome_crashpad_handler
    fperms 755 /opt/AionUi/resources/bundled-aioncore/linux-x64/aioncore

    if ! use system-nodejs; then
	    fperms 755 /opt/AionUi/resources/bundled-aioncore/linux-x64/managed-resources/node/node-v${NODEJS_VERSION}-linux-x64/bin/{corepack,node,npm,npx}
	fi

	find . -type f \( -name "*.so" -o -name "*.so.*" \) -printf "/%P\0" | xargs -0 fperms 755

	doicon -s scalable usr/share/icons/hicolor/1024x1024/apps/AionUi.png

    sed -i "s/\${description}/${DESCRIPTION}/" usr/share/applications/AionUi.desktop
	domenu usr/share/applications/AionUi.desktop
}

pkg_postinst() {
	xdg_pkg_postinst
}

pkg_postrm() {
	xdg_pkg_postrm
}
