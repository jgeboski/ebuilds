# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
PYTHON_COMPAT=( python{2_6,2_7} )

inherit eutils git-2 multilib python-single-r1 systemd user

DESCRIPTION="IRC to IM gateway that support multiple IM protocols"
HOMEPAGE="http://www.bitlbee.org/"
EGIT_REPO_URI="https://github.com/bitlbee/bitlbee.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug doc gnutls ipv6 +jabber libevent msn nss +oscar otr +plugins
      purple selinux skype ssl test twitter +yahoo xinetd"

COMMON_DEPEND="
	>=dev-libs/glib-2.14
	libevent? ( dev-libs/libevent )
	otr? ( >=net-libs/libotr-4 )
	purple? ( net-im/pidgin )
	gnutls? ( net-libs/gnutls )
	!gnutls? (
		nss? ( dev-libs/nss )
		!nss? ( ssl? ( dev-libs/openssl ) )
	)"

DEPEND="
	${COMMON_DEPEND}
	virtual/pkgconfig
	doc? (
		app-text/xmlto
		dev-libs/libxslt
	)
	selinux? ( sec-policy/selinux-bitlbee )
	skype? ( app-text/asciidoc )
	test? ( dev-libs/check )"

RDEPEND="
	${COMMON_DEPEND}
	virtual/logger
	skype? (
		dev-python/skype4py[${PYTHON_USEDEP}]
		net-im/skype
	)
	xinetd? ( sys-apps/xinetd )"

REQUIRED_USE="
	|| ( jabber msn oscar purple yahoo )
	jabber? ( !nss )
	msn? ( || ( gnutls nss ssl ) )"

pkg_setup() {
	enewgroup bitlbee
	enewuser  bitlbee -1 -1 /var/lib/bitlbee bitlbee
	python-single-r1_pkg_setup
}

src_prepare() {
	epatch_user
	python_fix_shebang utils/convert_purple.py

	use doc   || epatch "${FILESDIR}/bitlbee-disable-docs.patch"
	use skype && python_fix_shebang protocols/skype/skyped.py
}

src_configure() {
	FLAGS="debug ipv6 jabber msn oscar otr plugins purple skype \
	       twitter yahoo"

	for flag in ${FLAGS}; do
		if use ${flag}; then
			myconf="${myconf} --${flag}=1"
		else
			myconf="${myconf} --${flag}=0"
		fi
	done

	if use gnutls; then
		myconf="${myconf} --ssl=gnutls"
		einfo "Using gnutls for SSL support"
	elif use ssl; then
		myconf="${myconf} --ssl=openssl"
		einfo "Using openssl for SSL support"
	elif use nss; then
		myconf="${myconf} --ssl=nss"
		einfo "Using nss for SSL support"
	else
		myconf="${myconf} --ssl=bogus"
		einfo "You will not have any encryption support enabled."
	fi

	if use libevent; then
		myconf="${myconf} --events=libevent"
	else
		myconf="${myconf} --events=glib"
	fi

	./configure \
		--prefix=/usr\
		--etcdir=/etc/bitlbee \
		--plugindir=/usr/$(get_libdir)/bitlbee \
		--systemdsystemunitdir=$(systemd_get_unitdir) \
		--strip=0 \
		${myconf} || die "econf failed"

	sed -i \
		-e "/^EFLAGS/s:=:&${LDFLAGS} :" \
		Makefile.settings || die "sed failed"
}

src_compile() {
	emake
	use doc && emake -C doc/user-guide
}

src_install() {
	emake \
		install \
		install-dev \
		install-etc \
		install-systemd \
		DESTDIR="${D}"

	if use doc; then
		dodoc  doc/user-guide/*.txt
		dohtml doc/user-guide/*.html
	fi

	keepdir /var/lib/bitlbee
	fperms  0700 /var/lib/bitlbee
	fowners bitlbee:bitlbee /var/lib/bitlbee

	dodoc doc/{AUTHORS,CHANGES,CREDITS,FAQ,README}
	doman doc/bitlbee.8 doc/bitlbee.conf.5

	newinitd "${FILESDIR}/bitlbee.initd-r1" bitlbee
	newconfd "${FILESDIR}/bitlbee.confd-r1" bitlbee

	exeinto /usr/share/bitlbee
	newexe utils/convert_purple.py convert_purple.py
	newexe utils/bitlbee-ctl.pl    bitlbee-ctl.pl

	if use skype; then
		newdoc protocols/skype/NEWS   NEWS-skype
		newdoc protocols/skype/README README-skype
	fi

	if use xinetd; then
		insinto /etc/xinetd.d
		newins doc/bitlbee.xinetd bitlbee
	fi
}
