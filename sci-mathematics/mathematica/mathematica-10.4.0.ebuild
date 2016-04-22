# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit check-reqs eutils fdo-mime gnome2-utils multilib unpacker

DESCRIPTION="Computational software based on symbolic mathematics"
HOMEPAGE="http://www.wolfram.com/mathematica"
SRC_URI="Mathematica_${PV}_LINUX.sh"

LICENSE="Wolfram-Mathematica"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

# dev-libs/gmp:
#   requires --enable-fat -- not available in gentoo overlay

RDEPEND="
	>=virtual/jdk-1.6
	<media-libs/opencv-3.1:0/3.0
	app-accessibility/espeak
	app-text/aspell
	dev-cpp/clucene
	dev-db/sqlite:3
	dev-libs/glib:2
	dev-libs/icu
	dev-libs/libffi
	dev-libs/openssl
	media-libs/freetype
	media-libs/glu
	media-libs/harfbuzz
	media-libs/libmad
	media-libs/libogg
	media-libs/libpng:1.2
	media-libs/libraw
	media-libs/libsndfile
	media-libs/libvorbis
	media-libs/libwebp
	media-libs/mesa
	media-libs/portaudio
	media-sound/fluidsynth
	media-sound/lame
	net-dns/c-ares
	net-libs/liboauth
	net-libs/libssh2
	net-misc/curl[ssl,ssh]
	sci-libs/lemon
	sys-apps/pciutils
	sys-libs/zlib
	x11-libs/cairo
	x11-libs/pango[X]
	x11-libs/pixman
	virtual/opencl
	virtual/opengl"

RESTRICT="bindist fetch mirror"
QA_PREBUILT="*"
S="${WORKDIR}"

MY_PV="${PV}.0"
MY_ARCH=Linux$(use amd64 && echo -x86-64)
CHECKREQS_DISK_BUILD="10G"

pkg_pretend() {
	use x86 || use amd64 || die "Unsupported system architecture"
}

pkg_nofetch() {
	elog "Please download ${A} from ${HOMEPAGE} and place it in ${DISTDIR}"
}

src_unpack() {
	skip=$(grep -am1 ^offset= "${DISTDIR}/${A}" | awk '{print $3}')
	cd "${WORKDIR}"

	if [ -n "${skip}" ]; then
		skip=$(head -n "${skip}" "${DISTDIR}/${A}" | wc -c)
		unpack_makeself "${A}" "${skip}" dd
	else
		die "Failed to obtain makeself offset"
	fi

	unpack "./Unix/Files/Layout.M-LINUX-L/contents.tar.gz"
}

src_prepare() {
	echo "${MY_PV}" > .VersionID

	cat <<-EOF > .Revision
	FullVersionNumber: ${MY_PV}
	CreationID: $(cat .CreationID)
	EOF

	find -depth \
		\( \
			-name '*espeak*' -o \
			-name 'libaspell*' -o \
			-name 'libcairo*' -o \
			-name 'libclucene*' -o \
			-name 'libcrypto*' -o \
			-name 'libcurl.so*' -o \
			-name 'libcv*' -o \
			-name 'libcxcore*' -o \
			-name 'libffi*' -o \
			-name 'libfluidsynth*' -o \
			-name 'libfreetype*' -o \
			-name 'libgio*' -o \
			-name 'libglib*' -o \
			-name 'libGL*' -o \
			-name 'libGLU*' -o \
			-name 'libgmodule*' -o \
			-name 'libgobject*' -o \
			-name 'libgthread*' -o \
			-name 'libharfbuzz*' -o \
			-name 'libicu*' -o \
			-name 'liblemon*' -o \
			-name 'libmad*' -o \
			-name 'libMesa*' -o \
			-name 'libml*' -o \
			-name 'libmp3lame*' -o \
			-name 'libOAuth*' -o \
			-name 'libogg*' -o \
			-name 'libopencv*' -o \
			-name 'libpango*' -o \
			-name 'libpixman*' -o \
			-name 'libpng*' -o \
			-name 'libportaudio*' -o \
			-name 'libraw*' -o \
			-name 'libsndfile*' -o \
			-name 'libsqlite3*' -o \
			-name 'libssh2*' -o \
			-name 'libssl*' -o \
			-name 'libvorbis*' -o \
			-name 'libwebp*' -o \
			-name 'libz.so*' \
		\) -exec rm -rf '{}' \;

	find -depth \
		\( \
			-type d -a \
			\( \
				-name Linux$(use amd64 || echo -x86-64) -o \
				-name 'MacOSX*' -o \
				-name 'Windows*' \
			\) \
		\) -exec rm -rf '{}' \;

	use doc || find -depth -name Documentation -exec rm -rf '{}' \;

	# Hackery for non-mesa libGLs
	sed -i \
		-e "s/libMesaGL.so.1/libGL.so.1\x00\x00\x00\x00/g" \
		SystemFiles/FrontEnd/Binaries/${MY_ARCH}/gltest \
		SystemFiles/FrontEnd/Binaries/${MY_ARCH}/Mathematica

	(
		cd SystemFiles/Libraries/${MY_ARCH}
		ln -sf /usr/$(get_libdir)/libaspell.so libaspell.so.1
		ln -sf /usr/$(get_libdir)/libGL.so.1   libMesaGL.so.1
		ln -sf /usr/$(get_libdir)/libGLU.so.1  libMesaGLU.so.1
	)
	(
		mkdir -p SystemFiles/Links/HTTPClient/LibraryResources/${MY_ARCH}
		cd SystemFiles/Links/HTTPClient/LibraryResources/${MY_ARCH}
		ln -sf /usr/$(get_libdir)/libcrypto.so
		ln -sf /usr/$(get_libdir)/libcurl.so
		ln -sf /usr/$(get_libdir)/liboauth.so libOAuth.so
		ln -sf /usr/$(get_libdir)/libssh2.so
		ln -sf /usr/$(get_libdir)/libssl.so
	)

	rm -rf SystemFiles/Java/${MY_ARCH}
	ln -sf $(java-config --jdk-home) SystemFiles/Java/${MY_ARCH}

	mv SystemFiles/Installation .
	mv SystemFiles/SystemDocumentation .
}

src_install() {
	insinto /usr/share/mime/application
	doins Installation/*.xml
	doman SystemDocumentation/Unix/*.1

	mymts="application/mathematica;"
	mymts+="application/mathematicaplayer;"
	mymts+="application/vnd.wolfram.cdf;"
	make_desktop_entry ${PN} Mathematica "" "" "MimeType=${mymts}"

	for bin in $(ls -1 Executables); do
		dosym /opt/${PN}/Executables/${bin} /usr/bin/${bin}
	done

	for size in 32 64 128; do
		dosym  \
			/opt/${PN}/SystemFiles/FrontEnd/SystemResources/X/App.Mathematica.${size}.png \
			/usr/share/icons/hicolor/${size}x${size}/apps/mathematica.png
	done

	# Use mv over doins to save space
	mkdir -p "${D}/opt/${PN}"
	use doc && mv Documentation "${D}/opt/${PN}"

	mv \
		.CreationID \
		.Revision \
		.VersionID \
		AddOns \
		Configuration \
		Executables \
		SystemFiles \
		"${D}/opt/${PN}"
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
