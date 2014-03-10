# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

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
	media-libs/mesa
	media-libs/opencv
	media-libs/portaudio
	media-libs/libsndfile
	net-libs/liboauth
	sys-libs/zlib"

DEPEND="${RDEPEND}"

RESTRICT="bindist fetch mirror"
QA_PREBUILT="*"
S="${WORKDIR}/"

pkg_pretend() {
	use x86 || use amd64 || die "Unsupported system architecture"
}

pkg_nofetch() {
	elog "Please download ${A} from ${HOMEPAGE} and place it in ${DISTDIR}"
}

src_unpack() {
	offset=$(grep -anm 1 '^offset=`head' ${DISTDIR}/${A} | awk '{print $3}')
	cd "${S}"

	if [ -n "$offset" ]; then
		offset=$(head -n ${offset} ${DISTDIR}/${A} | wc -c)
		unpack_makeself ${A} ${offset} dd
	else
		unpack_makeself
	fi

	if use doc; then
		packages="
			MasterLayout.Paclet.English
			Notebooks.Online.English
			Usage.Online.English"

		for package in ${packages}; do
			unpacker "${S}"/Unix/Files/${package}/contents.tar.gz
		done
	fi

	F="${S}/Unix/Files"
	unpacker $(find "${F}" -path "${F}/*" -maxdepth 1 -type d \
		\( \
			! -name "*.Linux$(use amd64 || echo -x86-64)" -a \
			! -name "Indexer.Online.English" -a \
			! -name "MasterLayout.Paclet.English" -a \
			! -name "Notebooks.Online.English" -a \
			! -name "SystemFiles.Java.*" -a \
			! -name "Usage.Online.English" \
		\) -printf "%p/contents.tar.gz\n")
}

src_prepare() {
	fields="
		CreationID
		MinorReleaseNumber
		ReleaseNumber
		VersionNumber"

	for field in ${fields}; do
		read ${field} <<< $(\
			find Unix -name info -exec cat {} \; | \
			grep ^${field} | awk '{print $2}' | sort | uniq)
	done

	FullVersionNumber="${VersionNumber}.${ReleaseNumber}.${MinorReleaseNumber}"

	echo "${CreationID}"        > .CreationID
	echo "${FullVersionNumber}" > .VersionID

	echo "FullVersionNumber: ${FullVersionNumber}" >> .Revision
	echo "CreationID: ${CreationID}"               >> .Revision

	find -depth -name '*.so*' -a \
		\( \
			-name 'libaspell*' -o \
			-name 'libcrypto*' -o \
			-name 'libcv*' -o \
			-name 'libcxcore*' -o \
			-name 'libespeak*' -o \
			-name 'libicu*' -o \
			-name 'libml*' -o \
			-name 'libOAuth*' -o \
			-name 'libportaudio*' -o \
			-name 'libsndfile*' -o \
			-name 'libsqlite3*' -o \
			-name 'libssl*' -o \
			-name 'libz*' \
		\) -exec rm -rf {} \;
}

src_install() {
	insinto /usr/share/applications
	doins ${FILESDIR}/${PN}.desktop

	doman SystemFiles/SystemDocumentation/Unix/*.1
	rm -rf SystemFiles/SystemDocumentation

	insinto /usr/share/mime/application
	doins SystemFiles/Installation/*.xml
	rm -rf SystemFiles/Installation/

	insinto /opt/${PN}
	doins .CreationID .Revision .VersionID

	find . -path "./*" -maxdepth 1 -type d \
		\( \
			! -name Files -a \
			! -name Installer -a \
			! -name Unix \
		\) -exec mv {} ${D}/opt/${PN} \;

	for size in 32 64 128; do
		xresdir=/opt/${PN}/SystemFiles/FrontEnd/SystemResources/X
		hicrdir=/usr/share/icons/hicolor/${size}x${size}

		dosym \
			${xresdir}/Mathematica-${size}.png \
			${hicrdir}/apps/mathematica.png
	done

	for executable in $(ls -1 ${D}/opt/${PN}/Executables); do
		dosym /opt/${PN}/Executables/${executable} /opt/bin/${executable}
	done

	DIRARCH=$(use amd64 && echo -x86-64)
	SYSFDIR="/opt/${PN}/SystemFiles"
	LIBSDIR="${SYSFDIR}/Libraries/Linux${DIRARCH}"
	JAVADIR="${SYSFDIR}/Java/Linux${DIRARCH}"
	HTTPDIR="${SYSFDIR}/Links/HTTPClient/LibraryResources/Linux${DIRARCH}"

	dosym /opt/${PN}/Executables/Mathematica /opt/bin/mathematica
	dosym /usr/$(get_libdir)/libaspell.so    ${LIBSDIR}/libaspell.so.1
	dosym /usr/$(get_libdir)/libcrypto.so    ${HTTPDIR}/libcrypto.so
	dosym /usr/$(get_libdir)/libssl.so       ${HTTPDIR}/libssl.so
	dosym $(java-config --jdk-home)          ${JAVADIR}

	use doc     || find ${D} -depth -name Documentation -exec rm -rf {} \;
	use selinux && find ${D} -name "*.so*" -exec chcon -t textrel_shlib_t {} \;
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
