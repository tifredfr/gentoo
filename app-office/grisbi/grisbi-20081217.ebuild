# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

IUSE="print nls ofx"

DESCRIPTION="Grisbi is a personal accounting application for Linux"
HOMEPAGE="http://www.grisbi.org"
SRC_URI="http://thelinux.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc ~x86"

RDEPEND="dev-libs/libxml2
	>=x11-libs/gtk+-2.2.0
	ofx? ( >=dev-libs/libofx-0.7.0 )
	print? (
		virtual/latex-base
		|| ( dev-texlive/texlive-latexextra >=dev-tex/latex-unicode-20041017 )
		)"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.20"

pkg_setup() {
	if ! use print; then
		elog
		elog "NOTE: The USE variable 'print' is not in your USE flags."
		elog "For printing support in grisbi, you will need to restart"
		elog "the build with USE=\"print\""
		elog
		ebeep 5
	fi
}

S="${WORKDIR}/${PN}-${PV}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Apply location patchs
	ebegin "Applying Gentoo documentation location patch"
	for i in \
		$(find ./ -name 'Makefile.*') \
		$(find ./ -name 'grisbi-manuel/html')
			do
				sed -i "s;doc/grisbi/help;doc/${PF}/help;g" "${i}"
			done
	eend 0
}

src_compile() {
	./autogen.sh || die "autogen.sh failed"
	econf \
		$(use_with ofx) \
		$(use_enable nls) || die

	emake || die
}

src_install() {
	einstall || die
	dodoc AUTHORS ChangeLog NEWS README
	insinto /usr/share/applications
	doins "${FILESDIR}"/grisbi.desktop
	newicon pixmaps/grisbi.png grisbi.png
}

pkg_postinst() {
	pkg_setup

	elog "The first thing you should do is set up the browser command in"
	elog "preferences after you start up grisbi.  Otherwise you will not"
	elog "be able to see the help and manuals"
}
