# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-drivers/xf86-video-i810/xf86-video-i810-2.2.1.ebuild,v 1.2 2008/03/15 02:16:33 dberkholz Exp $

# Must be before x-modular eclass is inherited
# Enable snapshot to get the man page in the right place
# This should be fixed with a XDP patch later
SNAPSHOT="yes"
XDPVER=-1

inherit x-modular

# This really needs a pkgmove...
SRC_URI="http://xorg.freedesktop.org/archive/individual/driver/xf86-video-intel-${PV}.tar.bz2"

S="${WORKDIR}/xf86-video-intel-${PV}"

DESCRIPTION="X.Org driver for Intel cards"

KEYWORDS="amd64 arm ia64 sh x86 x86-fbsd"
IUSE="dri"

RDEPEND=">=x11-base/xorg-server-1.2
	x11-libs/libXvMC"
DEPEND="${RDEPEND}
	x11-proto/fontsproto
	x11-proto/randrproto
	x11-proto/renderproto
	x11-proto/xextproto
	x11-proto/xineramaproto
	x11-proto/xproto
	x11-proto/glproto
	dri? ( x11-proto/xf86driproto
			>=x11-libs/libdrm-2.2
			x11-libs/libX11 )"
src_unpack() {
	unpack ${A}
	cd "${S}"

epatch "${FILESDIR}/0001-fixup-pciaccess-version-detect.patch"
epatch "${FILESDIR}/01_fix_compiz_video.diff"
epatch "${FILESDIR}/01_gen_pci_ids.diff"
epatch "${FILESDIR}/03_dell_1535_quirk.diff"
epatch "${FILESDIR}/04_dell_1735_quirk.diff"
epatch "${FILESDIR}/05_intel_exa_force_greedy.patch"
epatch "${FILESDIR}/08_945gm_quirk.diff"
epatch "${FILESDIR}/10_hw_overlay.diff"
epatch "${FILESDIR}/11_hw_overlay_option.diff"
epatch "${FILESDIR}/12_quirk_sync.patch"
epatch "${FILESDIR}/13_dpms_low_power_overlay.patch"
epatch "${FILESDIR}/14_sysfs_fujitsu_backlight.patch"
epatch "${FILESDIR}/15_quirk_sony_vaio_vgn-sz4mn.patch"
epatch "${FILESDIR}/16_legacy_backlight_blc_pwn_ctl.patch"
epatch "${FILESDIR}/17_lockup_virtual_size_2048.patch"

}

CONFIGURE_OPTIONS="$(use_enable dri)"

pkg_setup() {
	if use dri && ! built_with_use x11-base/xorg-server dri; then
		die "Build x11-base/xorg-server with USE=dri."
	fi
}
