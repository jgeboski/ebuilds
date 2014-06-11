# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_DEPEND="2"
RESTRICT_PYTHON_ABIS="3.*"

inherit versionator

MAJOR_BRANCH=$(get_version_component_range 1-3)

inherit cmake-utils eutils gnome2-utils python toolchain-funcs

DESCRIPTION="OpenGL compositing window manager"
HOMEPAGE="https://launchpad.net/compiz"
SRC_URI="http://launchpad.net/${PN}/${MAJOR_BRANCH}/${PV}/+download/${P}.tar.bz2"

LICENSE="GPL-2 LGPL-2.1 MIT"
SLOT="0.9"
KEYWORDS="~amd64 ~x86"
IUSE="+cairo debug dbus fuse gnome gtk kde +svg test"

COMMONDEPEND="
	!x11-wm/compiz-fusion
	!x11-libs/compiz-bcop
	!x11-libs/libcompizconfig
	!x11-libs/compizconfig-backend-gconf
	!x11-libs/compizconfig-backend-kconfig4
	!x11-plugins/compiz-plugins-main
	!x11-plugins/compiz-plugins-extra
	!x11-plugins/compiz-plugins-unsupported
	!x11-apps/ccsm
	!dev-python/compizconfig-python
	!x11-apps/fusion-icon
	dev-libs/boost
	dev-libs/glib:2
	dev-cpp/glibmm
	dev-libs/libxml2
	dev-libs/libxslt
	dev-python/pyrex
	dev-libs/protobuf
	media-libs/libpng
	x11-base/xorg-server
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXinerama
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/startup-notification
	virtual/glu
	virtual/opengl
	cairo? ( x11-libs/cairo[X] )
	dbus? ( sys-apps/dbus )
	fuse? ( sys-fs/fuse )
	gtk? (
		>=x11-libs/gtk+-2.18.0
		>=x11-libs/libwnck-2.19.4
		x11-libs/pango
		gnome? (
			gnome-base/gnome-desktop
			gnome-base/gconf
			x11-wm/metacity
		)
	)
	kde? ( kde-base/kwin:4 )
	svg? (
		gnome-base/librsvg:2
		x11-libs/cairo
	)"

DEPEND="
	${COMMONDEPEND}
	app-admin/chrpath
	virtual/pkgconfig
	x11-proto/damageproto
	x11-proto/xineramaproto
	test? (
		dev-cpp/gtest
		dev-cpp/gmock
	)"

RDEPEND="
	${COMMONDEPEND}
	dev-python/pygtk
	x11-apps/mesa-progs
	x11-apps/xvinfo
	x11-themes/hicolor-icon-theme"

pkg_setup() {
	python_set_active_version 2
}

src_prepare() {
	epatch "${FILESDIR}/${PN}-0.9.10-cmake-whitespace.patch"
	epatch "${FILESDIR}/${PN}-0.9.10-sandbox.patch"

	echo "gtk/gnome/compiz-wm.desktop.in" >> "${S}/po/POTFILES.skip"
	echo "metadata/core.xml.in" >> "${S}/po/POTFILES.skip"

	# Fix wrong path for icons
	sed -i \
	  's|DataDir = "@prefix@/share"|DataDir = "/usr/share"|' \
	  compizconfig/ccsm/ccm/Constants.py.in

	sed -i 's/\(Compiz;\)/X-\1/g' compizconfig/ccsm/ccsm.desktop.in

	# Fix missing Language headers
	for file in $(ls -1 po/*.po); do
		msgcat --lang="$(basename "${file}" .po)" -o "${file}" "${file}"
	done
}

src_configure() {
	local mycmakeargs=(
		"-DCMAKE_MODULE_PATH=$(pwd)/cmake;$(pwd)/compizconfig/libcompizconfig/cmake"
		"-DCMAKE_INSTALL_PREFIX=/usr"
		"-DCOMPIZ_DISABLE_SCHEMAS_INSTALL=ON"
		"-DCOMPIZ_PACKAGING_ENABLED=ON"
		"$(cmake-utils_use_use gnome GCONF)"
		"$(cmake-utils_use_use gnome GNOME)"
		"$(cmake-utils_use_use gnome GSETTINGS)"
		"$(cmake-utils_use_use gtk GTK)"
		"$(cmake-utils_use_use kde KDE4)"
		"$(cmake-utils_use test COMPIZ_BUILD_TESTING)"
	)

	cmake-utils_src_configure
}

src_install() {
	pushd "${CMAKE_BUILD_DIR}"

	# Fix paths to avoid sandbox access violation
	# 'emake DESTDIR=${D} install' does not work with compiz cmake files!
	for i in $(find -type f -name cmake_install.cmake); do
		sed -i "s|/usr|${D}/usr|g" ${i} || die "sed failed"
	done

	emake install
	popd
}

pkg_preinst() {
	use gnome && gnome2_gconf_savelist
}

pkg_postinst() {
	use gnome && gnome2_gconf_install
}

pkg_prerm() {
	use gnome && gnome2_gconf_uninstall
}
