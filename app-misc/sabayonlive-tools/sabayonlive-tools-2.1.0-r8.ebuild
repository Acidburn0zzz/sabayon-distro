# Copyright 2006 SabayonLinux
# Distributed under the terms of the GNU General Public License v2

inherit eutils

DESCRIPTION="SabayonLinux Live tools for autoconfiguration of the system"
HOMEPAGE="http://www.sabayonlinux.org"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-util/dialog
	sys-apps/pciutils
	sys-apps/gawk
	app-admin/eselect-opengl
	!app-misc/livecd-tools
	"
DEPEND="${RDEPEND}"

src_unpack() {
	cd ${WORKDIR}
	cp ${FILESDIR}/${PV}/*-functions.sh . -p
	cp ${FILESDIR}/${PV}/net-setup . -p
	cp ${FILESDIR}/${PV}/x-setup-init.d . -p
	cp ${FILESDIR}/${PV}/installer-gui . -p
	cp ${FILESDIR}/${PV}/installer-text . -p
	cp ${FILESDIR}/${PV}/x-setup-configuration . -p
	cp ${FILESDIR}/${PV}/bashlogin . -p
	cp ${FILESDIR}/${PV}/opengl-activator . -p
	cp ${FILESDIR}/${PV}/sabayonlive . -p
	cp ${FILESDIR}/${PV}/vga-cmd-parser . -p
	cp ${FILESDIR}/${PV}/logscript.sh . -p
	cp ${FILESDIR}/${PV}/sabutil . -p
	cp ${FILESDIR}/${PV}/livespawn . -p
	cp ${FILESDIR}/${PV}/sabayon-live-check . -p
}

src_install() {

	cd ${WORKDIR}

	dosbin x-setup-configuration
	newinitd x-setup-init.d x-setup

	dosbin net-setup
	into /
	dosbin *-functions.sh
	dosbin logscript.sh
	dobin bashlogin
	dobin vga-cmd-parser
	exeinto /usr/bin
	doexe opengl-activator
	doexe livespawn
	doexe sabutil
	doexe sabayon-live-check

	#insinto /etc/X11
	#doins xorg.conf.sabayon

	newinitd sabayonlive sabayonlive
	newinitd installer-gui installer-gui
	newinitd installer-text installer-text

}

