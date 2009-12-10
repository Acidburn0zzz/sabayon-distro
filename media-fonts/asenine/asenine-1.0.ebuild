# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Asenine Fonts by Graham Meade of Apostrophic Labs"
HOMEPAGE="http://apostrophiclab.pedroreina.net"
SRC_URI="http://distfiles.sabayon.org/${CATEGORY}/${PN}/${P}.tar.lzma"

EAPI=2

LICENSE="ApostrophicLabs"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE=""
RESTRICT="mirror"

DEPEND=""

S=${WORKDIR}

src_unpack() {
	unpack ${A}
}

src_install() {
	dodir /usr/share/fonts
	cp -a "${WORKDIR}"/* "${D}"/usr/share/fonts || die "Copy Failed"
}
