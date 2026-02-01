# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="DREAMM is a bespoke emulator for LucasArts games."
HOMEPAGE="https://aarongiles.com/dreamm/"
SRC_URI="https://aarongiles.com/dreamm/releases/dreamm-${PV}-linux-x64.tgz"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"

DEPEND="media-libs/libsdl2"
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}"

src_unpack() {
	default
}

src_compile() {
	:
}

src_install() {
	# Install
	insinto /opt/dreamm
	doins -r *

	# Set to executable
	fperms +x /opt/dreamm/dreamm

	# Install icon
	insinto /usr/share/icons/hicolor/256x256/apps
	newins "${FILESDIR}/icon-dreamm.png" dreamm.png || die "Failed to install icon!"

	# Install .desktop
	insinto /usr/share/applications
	newins "${FILESDIR}/dreamm.desktop" dreamm.desktop || die "Desktop file install failed!"
}
