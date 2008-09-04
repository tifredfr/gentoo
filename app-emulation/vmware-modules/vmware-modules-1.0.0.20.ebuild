# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/vmware-modules/vmware-modules-1.0.0.20.ebuild,v 1.2 2008/06/18 09:18:03 ikelos Exp $

KEYWORDS="~amd64 ~x86"
VMWARE_VER="VME_V604" # THIS VALUE IS JUST A PLACE HOLDER

inherit eutils linux-info vmware-mod 

VMWARE_MODULE_LIST="vmmon vmnet vmblock"
SRC_URI="x86? ( mirror://vmware/software/vmplayer/VMware-player-2.0.4-93057.i386.tar.gz )
		 amd64? ( mirror://vmware/software/vmplayer/VMware-player-2.0.4-93057.x86_64.tar.gz )"
VMWARE_MOD_DIR="vmware-player-distrib/lib/modules/source/"

kernel_check() {
         get_version
         ebegin "Checking kernel options"
	 if kernel_is 2 6 ; then
            if ! { linux_chkconfig_present UNUSED_SYMBOLS; }; then
                ewarn "[UNUSED_SYMBOLS] is not set in the kernel."
            else
               einfo "[UNUSED_SYMBOLS].... is enabled in your kernel :-)"
            fi
         fi
         eend $?
}


src_unpack() {
        kernel_check
	vmware-mod_src_unpack
	cd "${S}/vmblock-only"
	epatch "${FILESDIR}/patches/vmblock/010_all_kernel-2.6.25.patch"
	cd "${S}"
	epatch "${FILESDIR}/${PV}-makefile-kernel-dir.patch"
	epatch "${FILESDIR}/patches/vmmon/040_all_kernel-2.6.26.patch"
        epatch "${FILESDIR}/patches/vmnet/030_all_kernel-2.6.26.patch"
	epatch "${FILESDIR}/patches/vmblock/020_all_kernel-2.6.26.patch"
	epatch "${FILESDIR}/patches/vmblock/025_all_kernel-2.6.26.patch"
}


pkg_postinst() {
         elog 
         elog " Instruction: http://bugs.gentoo.org/attachment.cgi?id=162272"
         elog " load the modules: modprobe vmblock && modprobe vmnet && modprobe vmmon"
	 elog ""
         elog " Run vmware-config.pl"
         elog " "
         elog " Edit /etc/init.d/vmware start and add"
	 elog "       #! /bin/sh
      sudo modprobe vmblock
      sudo modprobe vmnet
      sudo modprobe vmmon
      sudo /etc/init.d/vmware start
      VMWARE_USE_SHIPPED_GTK=force vmware
"
}
