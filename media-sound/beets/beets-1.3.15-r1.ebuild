# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="sqlite"

inherit bash-completion-r1 distutils-r1 eutils python-r1

DESCRIPTION="A media library management system for obsessive-compulsive music geeks"
HOMEPAGE="http://beets.radbox.org"
SRC_URI="https://github.com/sampsyo/beets/archive/v${PV}.tar.gz -> ${P}.tar.gz"

MY_PLUGINS="
	beatport bpd chroma convert discogs echonest echonest_tempo fetchart
	lastgenre lyrics metasync mpdstats replaygain thumbnails web"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~*"
IUSE="doc test ${MY_PLUGINS}"

RDEPEND="
	>=dev-python/enum34-1.0.4[${PYTHON_USEDEP}]
	>=dev-python/python-musicbrainz-ngs-0.4[${PYTHON_USEDEP}]
	>=media-libs/mutagen-1.27[${PYTHON_USEDEP}]
	dev-python/jellyfish[${PYTHON_USEDEP}]
	dev-python/munkres[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/sphinx[${PYTHON_USEDEP}]
	dev-python/unidecode[${PYTHON_USEDEP}]
	beatport? ( dev-python/requests[${PYTHON_USEDEP}] )
	bpd? ( dev-python/bluelet[${PYTHON_USEDEP}] )
	chroma? ( dev-python/pyacoustid[${PYTHON_USEDEP}] )
	convert? ( media-video/ffmpeg:0[encode] )
	discogs? ( >=dev-python/discogs-client-2.1.0[${PYTHON_USEDEP}] )
	echonest? ( dev-python/pyechonest[${PYTHON_USEDEP}] )
	echonest_tempo? ( dev-python/pyechonest[${PYTHON_USEDEP}] )
	fetchart? ( dev-python/requests[${PYTHON_USEDEP}] )
	lastgenre? ( dev-python/pylast[${PYTHON_USEDEP}] )
	lyrics? ( dev-python/beautifulsoup:4[${PYTHON_USEDEP}] )
	metasync? ( dev-python/dbus-python[${PYTHON_USEDEP}] )
	mpdstats? ( dev-python/python-mpd[${PYTHON_USEDEP}] )
	replaygain? ( || (
		media-sound/aacgain
		media-sound/mp3gain
	) )
	thumbnails? (
		dev-python/pathlib[${PYTHON_USEDEP}]
		dev-python/pyxdg[${PYTHON_USEDEP}]
	)
	web? (
		dev-python/flask[${PYTHON_USEDEP}]
		dev-python/flask-cors[${PYTHON_USEDEP}]
	)"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
	)"

src_prepare() {
	epatch "${FILESDIR}/${PN}-1.3.7-fix-bashcomp-warning.patch"
	epatch_user

	for plugin in ${MY_PLUGINS}; do
		if use ${plugin}; then
			continue;
		fi

		rm -rf \
			beetsplug/${plugin}{.py,} \
			test/test_${plugin}.py

		sed -i "/beetsplug.${plugin}/d" setup.py
	done

	use bpd || rm -f test/test_player.py

	python_setup
	python_export EPYTHON
	"${EPYTHON}" ./beet completion > extra/beet-bashcomp
}

python_compile_all() {
	emake -C docs man
	use doc && emake -C docs html
}

python_test() {
	esetup.py test
}

python_install_all() {
	distutils-r1_python_install_all
	newbashcomp extra/beet-bashcomp beet

	doman docs/_build/man/*
	use doc && dohtml -r docs/_build/html
}
