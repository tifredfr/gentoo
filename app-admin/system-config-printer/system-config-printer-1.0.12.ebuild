# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="The purpose of the tool is to configure a CUPS server (often the local machine) using the CUPS API."
HOMEPAGE="http://cyberelk.net/tim/software/system-config-printer/"

SRC_URI="http://cyberelk.net/tim/data/system-config-printer/1.0.x/${P}.tar.bz2"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~x86"

DEPEND="
	>=dev-python/pycups-1.9.32
	app-text/xmlto
	!net-print/gnome-cups-manager
	net-print/cups
	dev-lang/python
	net-print/foomatic-filters
	net-print/foomatic-db
	dev-python/pyxml
	dev-python/notify-python
	dev-python/dbus-python
	dev-python/gnome-python"

RDEPEND="${DEPEND}"

src_compile(){
	econf || die "configure failed"
	emake || die "make failed"
}

src_install(){
	emake DESTDIR="${D}" install || die "emake install failed."
}


