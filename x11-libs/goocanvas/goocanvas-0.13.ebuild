# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit libtool gnome2

DESCRIPTION="GooCanvas is a canvas widget for GTK+ using the cairo 2D library for drawing."
HOMEPAGE="http://live.gnome.org/GooCanvas"
#SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.10
	x11-libs/cairo"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_unpack() {
	unpack ${A}
	cd "${S}"
	#removing errorneus demo application from makefiles
	sed -i -e 's/ demo / /g' Makefile.am
	sed -i -e 's/ demo / /g' Makefile.in

	# Needed for FreeBSD - Please do not remove
	elibtoolize
}

src_compile() {
	econf --disable-dependency-tracking --disable-gtk-doc
	emake || die "emake failed."
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc AUTHORS ChangeLog NEWS README TODO
}
