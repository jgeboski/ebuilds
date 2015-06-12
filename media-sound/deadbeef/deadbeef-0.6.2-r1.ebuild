# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils fdo-mime gnome2-utils

DESCRIPTION="GTK+ audio player for GNU/Linux"
HOMEPAGE="http://deadbeef.sourceforge.net/"
SRC_URI="http://downloads.sourceforge.net/${PN}/${P}.tar.bz2"

LICENSE="
	GPL-2
	LGPL-2.1
	ZLIB
	dumb? ( DUMB-0.9.2 )
	psf? ( BSD XMAME )
	shn? ( shorten )"

SLOT="0"
KEYWORDS="~*"

IUSE="
	+gtk2 aac adplug alac alsa ape cdda converter cover cover-imlib2 curl dts
	dumb ffmpeg flac gme gtk3 hotkeys lastfm m3u midi mms mono2stereo mp3
	musepack nls notify nullout oss psf pulseaudio shellexec shn sid sndfile
	src static supereq threads tta vorbis vtx wavpack wma zip"

LANGS="
	be bg bn ca cs da de el en_GB es et eu fa fi fr gl he hr hu id it ja kk
	km lg lt nl pl pt pt_BR ro ru si_LK sk sl sr sr@latin sv te tr ug uk vi
	zh_CN zh_TW"

for lang in ${LANGS}; do
	IUSE+=" linguas_${lang}"
done

REQUIRED_USE="
	cover? ( curl )
	lastfm? ( curl )
	|| (
		alsa
		nullout
		oss
		pulseaudio
	)"

RDEPEND="
	aac? ( media-libs/faad2 )
	alsa? ( media-libs/alsa-lib )
	alac? ( media-libs/faad2 )
	cdda? (
		>=dev-libs/libcdio-0.90
		media-libs/libcddb
	)
	cover? ( media-libs/imlib2 )
	curl? ( net-misc/curl )
	ffmpeg? ( >=media-video/ffmpeg-1.0.7 )
	flac? ( media-libs/flac )
	gtk2? ( x11-libs/gtk+:2 x11-libs/gtkglext )
	gtk3? ( x11-libs/gtk+:3 )
	midi? ( media-sound/timidity-freepats )
	mms? ( media-libs/libmms )
	mp3? ( media-libs/libmad )
	musepack? ( media-sound/musepack-tools )
	notify? ( sys-apps/dbus )
	pulseaudio? ( media-sound/pulseaudio )
	sndfile? ( media-libs/libsndfile )
	src? ( media-libs/libsamplerate )
	vorbis? ( media-libs/libvorbis )
	wavpack? ( media-sound/wavpack )
	zip? (
		>=dev-libs/libzip-1.0.0
		sys-libs/zlib
	)"

DEPEND="
	${RDEPEND}
	dev-util/intltool"

pkg_pretend() {
	if use psf || use dumb || use shn && use static ; then
		die "ao, converter, dumb or shn plugin(s) cannot be built statically"
	fi
}

src_prepare() {
	epatch "${FILESDIR}/${PN}-desktop-cleanup.patch"
	epatch "${FILESDIR}/${P}-libzip-1.0.0.patch"
	epatch_user

	if use midi ; then
		tmpath="/usr/share/timidity/freepats/timidity.cfg"

		sed -i \
		    "s;\(#define DEFAULT_TIMIDITY_CONFIG\).*;\1 \"$tmpath\";g" \
		  "${S}/plugins/wildmidi/wildmidiplug.c"
	fi

	# Only use specified linguas
	echo > po/LINGUAS

	for lang in ${LANGS}; do
		if use linguas_${lang}; then
			echo ${lang} >> po/LINGUAS
		fi
	done
}

src_configure() {
	econf \
		--docdir=/usr/share/doc/${PF} \
		--disable-rpath \
		$(use_enable aac) \
		$(use_enable adplug) \
		$(use_enable alac) \
		$(use_enable alsa) \
		$(use_enable ape ffap) \
		$(use_enable cdda) \
		$(use_enable converter) \
		$(use_enable cover artwork) \
		$(use_enable cover-imlib2 artwork-imlib2) \
		$(use_enable curl vfs-curl) \
		$(use_enable dts dca) \
		$(use_enable dumb) \
		$(use_enable ffmpeg) \
		$(use_enable flac) \
		$(use_enable gme) \
		$(use_enable gtk2) \
		$(use_enable gtk3) \
		$(use_enable hotkeys) \
		$(use_enable lastfm lfm) \
		$(use_enable m3u) \
		$(use_enable midi wildmidi) \
		$(use_enable mms) \
		$(use_enable mono2stereo) \
		$(use_enable mp3 mad) \
		$(use_enable musepack) \
		$(use_enable nls) \
		$(use_enable notify) \
		$(use_enable nullout) \
		$(use_enable oss) \
		$(use_enable psf) \
		$(use_enable pulseaudio pulse) \
		$(use_enable shellexec) \
		$(use_enable shellexec shellexecui) \
		$(use_enable shn) \
		$(use_enable sid) \
		$(use_enable sndfile) \
		$(use_enable src) \
		$(use_enable static) \
		$(use_enable static staticlink) \
		$(use_enable supereq) \
		$(use_enable threads) \
		$(use_enable tta) \
		$(use_enable vorbis) \
		$(use_enable vtx) \
		$(use_enable wavpack) \
		$(use_enable zip vfs-zip) \
		$(use_enable wma)
}

src_install() {
	emake DESTDIR="${D}" install

	for lang in pt_BR ru; do
		if use linguas_${lang}; then
			docompress -x /usr/share/doc/${PF}/help.${lang}.txt
		else
			rm -f ${D}/usr/share/doc/${PF}/help.${lang}.txt
		fi
	done

	docompress -x \
		/usr/share/doc/${PF}/about.txt \
		/usr/share/doc/${PF}/ChangeLog \
		/usr/share/doc/${PF}/COPYING.GPLv2 \
		/usr/share/doc/${PF}/COPYING.LGPLv2.1 \
		/usr/share/doc/${PF}/help.txt \
		/usr/share/doc/${PF}/translators.txt
}

pkg_preinst() {
	gnome2_icon_savelist
	gnome2_schemas_savelist
}

pkg_postinst() {
	if use midi ; then
		einfo "enable freepats support for timidity via"
		einfo "eselect timidity set --global freepats"
	fi

	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update

	gnome2_icon_cache_update
	gnome2_schemas_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update

	gnome2_icon_cache_update
	gnome2_schemas_update
}
