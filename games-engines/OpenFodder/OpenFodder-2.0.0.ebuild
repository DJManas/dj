# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake desktop xdg-utils

DESCRIPTION="An open source port of Cannon Fodder"
HOMEPAGE="https://openfodder.com/"
SRC_URI="
	https://github.com/OpenFodder/openfodder/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/OpenFodder/data/releases/download/1.6.0/Data.pack.1.6.0.zip -> Data.pack.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	media-libs/libsdl2
	media-libs/sdl2-mixer"
RDEPEND="${DEPEND}"
BDEPEND=""

src_unpack() {
	# Unpack everything
	unpack "${P}.tar.gz" || die "Failed to extract package sources."

	local data_pack_dir="${WORKDIR}/pack"
	mkdir -p "${data_pack_dir}" || die "Failed to create data pack directory."
	unzip -q "${DISTDIR}/Data.pack.zip" -d "${data_pack_dir}" || die "Failed to extrat data pack"

	# Just create link
	ln -s "${WORKDIR}/openfodder-${PV}" "${WORKDIR}/${P}"
}

src_install() {
	# Create libraries
	local data_dir="${WORKDIR}/pack"
	local pack_dir="${D}/usr/share/OpenFodder"
	local exe_dir="${D}/usr/bin"

	# Create destination folder
	if [ ! -d "${pack_dir}" ]; then
		mkdir -p "${pack_dir}" || die "Pack directory in image could not be created"
	fi

	if [ ! -d "${exe_dir}" ]; then
		mkdir -p "${exe_dir}" || die "Executable directory could not be created"
	fi

	if [ -d "${data_dir}" ]; then
		cp -r "${data_dir}" "${pack_dir}" || die "Could not copy pack data into target destination"
	else
		die "${pack_dir} dir doesnt exist in ${WORKDIR}"
	fi

	# Install openfodder executable
	cp "${WORKDIR}/${P}_build/openfodder" "${exe_dir}"

    # Install icon
    newicon "${FILESDIR}/${PN}.jpg" "${PN}.jpg" || die "Icon creation error"

    # Install desktop file
    cp "${FILESDIR}/${PN}.desktop" "${S}"
    domenu "${S}/${PN}.desktop" || die "Menu creation error"
}

pkg_postinst() {
	xdg_icon_cache_update

	elog "Default pack files had been installed to /usr/share/OpenFodder"
	elog "Please put your CF game files (e.g. amiga/PC to correct folder in your home"
	elog "E.g. when you download game from GoG.com, put CF_ENG.DAT from CF 1"
	elog "to folder ~/.local/share/OpenFodder/Data/Dos_CD/"
	elog "More can be found here: https://github.com/OpenFodder/openfodder/blob/master/INSTALL.md"
}
