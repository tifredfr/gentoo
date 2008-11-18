# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnome2 eutils

#MY_PV=${PV/_*/}
MY_PV=${PV/_/-}

DESCRIPTION="Gnome applet for NetworkManager."
HOMEPAGE="http://people.redhat.com/dcbw/NetworkManager/"

SRC_URI="http://ftp.gnome.org/pub/GNOME/sources/network-manager-applet/0.7/network-manager-applet-${MY_PV}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="debug doc libnotify"

RDEPEND=">=sys-apps/dbus-0.60
	>=sys-apps/hal-0.5
	sys-apps/iproute2
	>=net-misc/dhcdbd-1.4
	>=net-misc/networkmanager-20081005
	>=net-wireless/wireless-tools-28_pre9
	>=net-wireless/wpa_supplicant-0.4.8
	>=dev-libs/glib-2.10
	libnotify? ( >=x11-libs/libnotify-0.4.3 )
	>=x11-libs/gtk+-2.10
	>=gnome-base/libglade-2
	>=gnome-base/gnome-keyring-0.4
	>=gnome-base/gnome-panel-2
	>=gnome-base/gconf-2
	>=gnome-base/libgnomeui-2"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	>=dev-util/intltool-0.35"

DOCS="AUTHORS COPYING ChangeLog INSTALL NEWS README"
USE_DESTDIR="1"

G2CONF="${G2CONF} \
	--disable-more-warnings \
	--localstatedir=/var \
	--with-dbus-sys=/etc/dbus-1/system.d \
	$(use_with libnotify notify) \
	--prefix=/usr"


S=${WORKDIR}/${PN}-0.7.0


src_unpack() {
	unpack ${A}
	cd "${S}"
#	epatch "${FILESDIR}/nm-applet-changeconf.patch"
}

src_compile() {
	econf || die "Configure failed"
	emake || die "Make failed"
}

pkg_postinst() {
	gnome2_pkg_postinst
	elog "Your user needs to be in the plugdev group in order to use this"
	elog "package.  If it doesn't start in Gnome for you automatically after"
	elog 'you log back in, simply run "nm-applet --sm-disable"'
	elog "You also need the notification area applet on your panel for"
	elog "this to show up."
}