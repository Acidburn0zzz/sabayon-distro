# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit base eutils autotools multilib

DESCRIPTION="Glib bindings for poppler"
SRC_URI="http://poppler.freedesktop.org/poppler-${PV}.tar.gz
	http://distfiles.sabayon.org/${CATEGORY}/poppler-patches-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="+cairo doc"
S="${WORKDIR}/poppler-${PV}"

COMMON_DEPEND=">=dev-libs/glib-2.16
	cairo? (
		>=x11-libs/cairo-1.8.4
		>=x11-libs/gtk+-2.14.0:2
	)"
RDEPEND="${COMMON_DEPEND}
	~app-text/poppler-base-${PV}"
DEPEND="${COMMON_DEPEND}
	dev-util/pkgconfig"

PATCHES=(
        "${WORKDIR}"/poppler-0.12.3-cmake-disable-tests.patch
        "${WORKDIR}"/poppler-0.12.3-fix-headers-installation.patch
        "${WORKDIR}"/poppler-0.12.3-gdk.patch
        "${WORKDIR}"/poppler-0.12.3-darwin-gtk-link.patch
        "${WORKDIR}"/poppler-${PV}-config.patch
        "${WORKDIR}"/poppler-0.12.3-cairo-downscale.patch
        "${WORKDIR}"/poppler-0.12.3-preserve-cflags.patch
        "${WORKDIR}"/poppler-0.12.4-nanosleep-rt.patch
        "${WORKDIR}"/poppler-0.12.4-strings_h.patch
        "${WORKDIR}"/poppler-0.12.4-xopen_source.patch
)

src_prepare() {
	base_src_prepare
	eautoreconf
}

src_configure() {
        econf \
		--enable-poppler-glib \
		--enable-zlib \
		--disable-gtk-test \
		--disable-poppler-qt4 \
		--disable-xpdf-headers \
		--disable-libjpeg \
		--disable-libopenjpeg \
		--disable-libpng \
		--disable-abiword-output \
		--disable-utils || die "econf failed"
}

src_compile() {
	( cd "${S}" && base_src_compile ) || die "cannot run src_compile"
}

src_install() {
	( cd "${S}"/glib && base_src_install ) || die "cannot run base_src_install"

	# install pkg-config data
	insinto /usr/$(get_libdir)/pkgconfig
	doins "${S}"/poppler-glib.pc
	use cairo && doins "${S}"/poppler-cairo.pc

	if use cairo && use doc; then
		# For now install gtk-doc there
		insinto /usr/share/gtk-doc/html/poppler
		doins -r "${S}"/glib/reference/html/* || die 'failed to install API documentation'
	fi

}
