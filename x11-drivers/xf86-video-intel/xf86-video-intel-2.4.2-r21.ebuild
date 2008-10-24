# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="X.Org driver for Intel cards"

KEYWORDS="~amd64 ~arm ~ia64 ~sh ~x86 ~x86-fbsd"
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
	dri? ( x11-proto/xf86driproto
			x11-proto/glproto
			=x11-libs/libdrm-2.3.0
			x11-libs/libX11 )"

CONFIGURE_OPTIONS="$(use_enable dri)"

PATCHES=(
"${FILESDIR}/2.4/xf86-video-i810-2.4.2-fix-flicker.patch"
#"${FILESDIR}/2.4/xf86-video-i810-2.4.2-0001-Don-t-allocate-a-pipe-for-hotplug-detection.patch"
"${FILESDIR}/2.4/01_fix_compiz_video.diff"
"${FILESDIR}/2.4/05_intel_exa_force_greedy.patch"
"${FILESDIR}/2.4/11_textured_video_option.patch"
"${FILESDIR}/2.4/24_no_render_suspend"

)



pkg_setup() {
	if use dri && ! built_with_use x11-base/xorg-server dri; then
		die "Build x11-base/xorg-server with USE=dri."
	fi
}
