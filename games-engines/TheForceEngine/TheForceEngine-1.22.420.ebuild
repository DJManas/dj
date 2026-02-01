# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Modern \"Jedi Engine\" replacement supporting Dark Forces and the mods."
HOMEPAGE="https://theforceengine.github.io/"
SRC_URI="https://github.com/luciusDXL/TheForceEngine/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

IUSE="editor +midi"

DEPEND="
	>=media-libs/libsdl2-2.24
	>=media-libs/sdl2-image-2.6.3
	virtual/opengl
"

RDEPEND="${DEPEND}
	midi? ( >=media-libs/rtmidi-5.0.0[alsa(+)] )
"
BDEPEND=""

src_configure() {
	local mycmakeargs=(
		-DCMAKE_BUILD_TYPE=Release
		-DENABLE_EDITOR=$(usex editor)
	)

	cmake_src_configure
}

src_compile() {
	cmake_src_compile
}

src_install() {
	cmake_src_install
}

pkg_postinst() {
	xdg_icon_cache_update

	elog "For the game to work properly, you need to buy it, e.g. on GoG."
	elog "Dark Forces: https://www.gog.com/en/game/star_wars_dark_forces"
	elog "Outlaws: https://www.gog.com/en/game/outlaws_a_handful_of_missions"
	elog ""
	elog "Dark forces:"
	elog "Go into directory in your home, where you want to download it."
	elog "Use lgog downloader to download it, e.g."
	elog "lgogdownloader --download --game dark_forces --exclude extras"
	elog "Then use innoextract to extract"
	elog "cd star_wars_dark_forces"
	elog "innoextract -e setup_star_warstm_dark_forces_1.0.2_\(20338\).exe"

	elog ""
	elog ""

	elog "Outlaws:"
	elog "Go into directory in your home, wher you want to download it."
	elog "Use lgog downloader to download it, e.g."
	elog "lgogdownloader --download --game outlaws --exclude extras"
	elog "Then use innoextract to extract"
	elog "cd outlaws_a_handful_of_missions"
	elog "innoextract -e setup_outlaws_2.0_hotfix_\(18728\).exe"

	elog ""
	elog " Launch TheForceEngine and point it correct directories."
}
