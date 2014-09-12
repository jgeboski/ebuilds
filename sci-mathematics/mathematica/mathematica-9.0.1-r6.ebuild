# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils fdo-mime gnome2-utils multilib unpacker

DESCRIPTION="Computational software based on symbolic mathematics"
HOMEPAGE="http://www.wolfram.com/mathematica"
SRC_URI="Mathematica_${PV}_LINUX.sh"

LICENSE="Wolfram-Mathematica"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc selinux"

# dev-libs/gmp:
#   requires --enable-fat -- not available in gentoo overlay

RDEPEND="
	>=virtual/jdk-1.6
	app-accessibility/espeak
	app-text/aspell
	dev-db/sqlite:3
	dev-libs/icu
	dev-libs/openssl
	media-libs/glu
	media-libs/mesa
	media-libs/opencv
	media-libs/portaudio
	media-libs/libsndfile
	net-libs/liboauth
	sys-apps/pciutils
	sys-libs/zlib
	virtual/opengl"

DEPEND="${RDEPEND}"

RESTRICT="bindist fetch mirror"
QA_PREBUILT="*"
S="${WORKDIR}"

pkg_pretend() {
	use x86 || use amd64 || die "Unsupported system architecture"
}

pkg_nofetch() {
	elog "Please download ${A} from ${HOMEPAGE} and place it in ${DISTDIR}"
}

src_unpack() {
	offset=$(grep -am1 ^offset= "${DISTDIR}/${A}" | awk '{print $3}')
	cd "${S}"

	if [ -n "$offset" ]; then
		offset=$(head -n ${offset} "${DISTDIR}/${A}" | wc -c)
		unpack_makeself "${A}" "${offset}" dd
	else
		unpack_makeself
	fi
}

src_prepare() {
	epatch_user

	find Unix/Files -maxdepth 1 -depth -type d \
		\( \
			-name "*.Linux$(use amd64 || echo -x86-64)" -o \
			-name "SystemFiles.Java.*" \
		\) -exec rm -rf '{}' \;

	use doc || find Unix/Files -maxdepth 1 -depth -type d \
		\( \
			-name "Indexer.Online.English" -o \
			-name "MasterLayout.Paclet.English" -o \
			-name "Notebooks.Online.English" -o \
			-name "Usage.Online.English" \
		\) -exec rm -rf '{}' \;
}

src_install() {
	./Unix/Installer/MathInstaller \
		-execdir="${D}/usr/bin" \
		-targetdir="${D}/opt/${PN}" \
		-selinux=$(use selinux && echo y || echo n) \
		-auto \
		-debug \
		-verbose

	# Ensure PATH includes /usr/sbin (lspci)
	sed -i \
		"s;\(PATH\)=\"\(.*\)\";\1=\"\2:/usr/sbin\";" \
		"${D}"/opt/${PN}/Executables/*

	insinto /usr/share/applications
	doins "${FILESDIR}/${PN}.desktop"

	insinto /usr/share/mime/application
	doins "${D}"/opt/${PN}/SystemFiles/Installation/*.xml

	doman "${D}"/opt/mathematica/SystemFiles/SystemDocumentation/Unix/*.1
	use doc || find "${D}" -depth -name Documentation -exec rm -rf '{}' \;

	find "${D}" -depth \
		\( \
			-name 'MacOSX*' -o \
			-name 'Windows*' -o \
			-name '*espeak*' -o \
			-name 'libaspell*' -o \
			-name 'libcrypto*' -o \
			-name 'libcv*' -o \
			-name 'libcxcore*' -o \
			-name 'libGL*' -o \
			-name 'libGLU*' -o \
			-name 'libicu*' -o \
			-name 'libMesa*' -o \
			-name 'libml*' -o \
			-name 'libOAuth*' -o \
			-name 'libportaudio*' -o \
			-name 'libsndfile*' -o \
			-name 'libsqlite3*' -o \
			-name 'libssl*' -o \
			-name 'libz*' \
		\) -exec rm -rf '{}' \;

	rm -rf \
		"${D}/opt/${PN}/InstallErrors" \
		"${D}/opt/${PN}/SystemFiles/Installation" \
		"${D}/opt/${PN}/SystemFiles/SystemDocumentation"

	archdir="Linux$(use amd64 && echo -x86-64)"
	sysfdir="/opt/${PN}/SystemFiles"
	httpdir="${sysfdir}/Links/HTTPClient/LibraryResources/${archdir}"
	xresdir="${sysfdir}/FrontEnd/SystemResources/X"

	for size in 32 64 128; do
		hicrdir="/usr/share/icons/hicolor/${size}x${size}/apps"
		dosym ${xresdir}/Mathematica-${size}.png ${hicrdir}/mathematica.png
	done

	for lib in libcrypto.so libssl.so; do
		dosym /usr/$(get_libdir)/${lib} ${httpdir}/${lib}
	done

	dosym \
		/usr/$(get_libdir)/libaspell.so \
		${sysfdir}/Libraries/${archdir}/libaspell.so.1

	dosym \
		/usr/$(get_libdir)/opengl/xorg-x11/lib/libGL.so.1 \
		${sysfdir}/Libraries/${archdir}/libMesaGL.so.1

	dosym \
		/usr/$(get_libdir)/opengl/xorg-x11/lib/libGL.so.1 \
		${sysfdir}/Libraries/${archdir}/Mesa/libGL.so.1

	dosym \
		/usr/$(get_libdir)/libGLU.so.1 \
		${sysfdir}/Libraries/${archdir}/libMesaGLU.so.1

	dosym \
		$(java-config --jdk-home) \
		${sysfdir}/Java/${archdir}
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}
