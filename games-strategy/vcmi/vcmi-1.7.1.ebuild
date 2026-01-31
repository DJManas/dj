# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=(luajit)
# TODO: other targets (buildsystem is crazy and needs patches)

inherit cmake lua-single djs-functions

DESCRIPTION="Heroes of Might and Magic III game engine rewrite"
HOMEPAGE="http://forum.vcmi.eu/index.php"
INSTALL_PATH="/opt/vcmi"

# Get package version, get default values, if not underscore keep them
PACKAGE_VERSION=${PV}
PACKAGE_NAME=${P}
if [[ ${PACKAGE_VERSION} == *_p* ]]; then
	PACKAGE_VERSION="${PV%%_*}"
	PACKAGE_NAME="${PN}-${PACKAGE_VERSION}"
fi

FUZZYLITE_VERSION="6.0"
GOOGLETEST_VERSION="1.17.0"
LIBSQUISH_VERSION="1.15.1.3"
OBCMAKE_VERSION="0.3.11"

INNOEXTRACT_COMMIT="96e9566a35fb51ebf13ffbdadfd49a93c1ae5c1a"

SRC_URI="
	https://github.com/vcmi/vcmi/archive/refs/tags/${PACKAGE_VERSION}.tar.gz -> ${P}.tar.gz
	https://github.com/fuzzylite/fuzzylite/archive/refs/tags/v${FUZZYLITE_VERSION}.tar.gz -> vcmi-fuzzylite.tar.gz
	https://github.com/google/googletest/archive/refs/tags/v${GOOGLETEST_VERSION}.tar.gz -> vcmi-googletest.tar.gz
	https://github.com/vcmi/innoextract/archive/${INNOEXTRACT_COMMIT}.tar.gz -> vcmi-innoextract.tar.gz
	https://github.com/oblivioncth/libsquish/archive/refs/tags/v${LIBSQUISH_VERSION}.tar.gz -> vcmi-libsquish.tar.gz
	https://github.com/oblivioncth/OBCMake/archive/v${OBCMAKE_VERSION}.tar.gz -> vcmi-obcmake.tar.gz
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
# TODO: other arches
IUSE="+editor debug erm +launcher lua +nullkiller-ai +translations"

REQUIRED_USE="
	erm? ( lua )
	lua? ( ${LUA_REQUIRED_USE} )
"

RDEPEND="
	nullkiller-ai? ( dev-cpp/tbb )
	dev-lang/luajit
	dev-libs/fuzzylite
	>=dev-libs/boost-1.70:=
	launcher? (
		dev-qt/qtcore:=
		dev-qt/qtgui:=
		dev-qt/qtnetwork:=
		dev-qt/qtwidgets:=
		translations? ( dev-qt/linguist-tools )
	)
	editor? (
		dev-qt/qtcore:=
		dev-qt/qtgui:=
		dev-qt/qtnetwork:=
		dev-qt/qtwidgets
		translations? ( dev-qt/linguist-tools )
	)
	sys-libs/zlib:=[minizip]
	media-video/ffmpeg:=
	media-libs/libsdl2:=[X]
	media-libs/sdl2-image:=
	media-libs/sdl2-mixer:=
	media-libs/sdl2-ttf:=
"

BDEPEND="
	dev-vcs/git
	sci-libs/onnxruntime
"

DEPEND="${RDEPEND}"

src_unpack() {
	# Unpack ALL Packages
	unpack ${A}

	# Move if not equal
	if [[ "${P}" != "${PACKAGE_NAME}" ]]; then
		mv "${WORKDIR}/${PACKAGE_NAME}" "${WORKDIR}/${P}"
	fi

	# Delete target directories
	rmdir "${WORKDIR}/${P}/AI/FuzzyLite" || die "FuzzyLite dir not deleted"
	rmdir "${WORKDIR}/${P}/launcher/lib/innoextract" || die "innoextract dir not deleted"
	rmdir "${WORKDIR}/${P}/test/googletest" || die "Googletest dir not deleted"

	# Create external libraries
	mkdir -p "${WORKDIR}/${P}/external" || die "Cannot create external directory"

	# Make symlinks, mostly mv is used, but I will try to go using ln -s, dosym doesnt work here
	ln -s "${WORKDIR}/fuzzylite-${FUZZYLITE_VERSION}" "${WORKDIR}/${P}/AI/FuzzyLite"\
		|| die "FuzzyLite symlink not created"
	ln -s "${WORKDIR}/googletest-${GOOGLETEST_VERSION}" "${WORKDIR}/${P}/test/googletest"\
		|| die "Googletest symlink not created"
	ln -s "${WORKDIR}/innoextract-${INNOEXTRACT_COMMIT}" "${WORKDIR}/${P}/launcher/lib/innoextract"\
		|| die "innoextract symlink not created"
	ln -s "${WORKDIR}/libsquish-${LIBSQUISH_VERSION}" "${WORKDIR}/${P}/external/libsquish"\
		|| die "libsquish symlink not created"
	# Symlink OBCMake into libsquish's expected location
	#ln -s "${WORKDIR}/OBCMake-${OBCMAKE_VERSION}" "${WORKDIR}/libsquish-${LIBSQUISH_VERSION}/cmake/OBCMake"\
	#	|| die "OBCMake symlink not created"
}

src_prepare() {
  # Since I need dependencies for CMake file to work and I need to apply pathes to it
  # I will do most magic here
	eapply_user

	# OBC/libsquish git workaround
	cd "${WORKDIR}/OBCmake-${OBCMAKE_VERSION}" || die "False git failed"
	git init || die
	git config user.email "portage@gentoo.org" || die
	git config user.name "Gentoo Portage" || die
	git add -A || die
	git commit -m "Fake commit for vcmi ebuild" || die
	git tag "v${OBCMAKE_VERSION}" || die

	# Also do the same for libsquish if needed
	cd "${WORKDIR}/libsquish-${LIBSQUISH_VERSION}" || die
	git init || die
	git config user.email "portage@gentoo.org" || die
	git config user.name "Gentoo Portage" || die
	git add -A || die
	git commit -m "Fake commit for vcmi ebuild" || die
	cd "${S}" || die

  patchPackage "${FILESDIR}" "${PN}" "${PVR}"

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_ERM=$(usex erm)
		-DENABLE_LUA=$(usex lua)
		-DENABLE_LAUNCHER=$(usex launcher)
		-DENABLE_EDITOR=$(usex editor)
		-DENABLE_TRANSLATIONS=$(usex translations)
		-DENABLE_PCH=$(usex !debug)
		-DENABLE_NULLKILLER_AI=$(usex nullkiller-ai)
		-DENABLE_MONOLITHIC_INSTALL=OFF
		-DFORCE_BUNDLED_FL=OFF
		-DFORCE_BUNDLED_MINIZIP=OFF
		-DENABLE_GITVERSION=OFF
		-DBoost_NO_BOOST_CMAKE=ON
		# Tell FetchContent to use our local OBCMake
		-DFETCHCONTENT_SOURCE_DIR_OBCMAKE="${WORKDIR}/OBCmake-${OBCMAKE_VERSION}"
		# Disable OBCMake's git versioning feature
		#-DOB_STANDARD_PROJECT_SETUP_VERBOSITY="QUIET"
	)

	cmake_src_configure
}

pkg_postinst() {
	elog "For the game to work properly, please copy your"
	elog 'Heroes Of Might and Magic ("The Wake Of Gods" or'
	elog '"Shadow of Death" or "Complete edition")'
	elog "game directory into /usr/share/${PN}."
	elog "or use 'vcmibuilder' utility on your:"
	elog "   a) One or two CD's or CD images"
	elog "   b) gog.com installer"
	elog "   c) Directory with installed game"
	elog "(although installing it in such way is 'bad practices')."
	elog "For more information, please visit:"
	elog "http://wiki.vcmi.eu/index.php?title=Installation_on_Linux"
	elog ""
	elog "Also, you may want to install VCMI Extras and Wake of Gods"
	elog "mods from the launcher after you'll start the game"
}
