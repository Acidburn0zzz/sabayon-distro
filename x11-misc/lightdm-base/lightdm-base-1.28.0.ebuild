# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools pam qmake-utils readme.gentoo-r1 systemd vala xdg-utils

REAL_PN="${PN/-base}"
REAL_P="${P/-base}"
DESCRIPTION="A lightweight display manager, base libraries and programs"
HOMEPAGE="https://github.com/CanonicalLtd/lightdm"
SRC_URI="https://github.com/CanonicalLtd/lightdm/releases/download/${PV}/${REAL_P}.tar.xz
	mirror://gentoo/introspection-20110205.m4.tar.bz2"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="audit +gnome +introspection vala"
S="${WORKDIR}/${REAL_P}"

COMMON_DEPEND="
	>=dev-libs/glib-2.44.0:2
	dev-libs/libxml2
	sys-libs/pam
	x11-libs/libX11
	>=x11-libs/libxklavier-5
	audit? ( sys-process/audit )
	gnome? ( sys-apps/accountsservice )
	introspection? ( >=dev-libs/gobject-introspection-1 )
"

RDEPEND="${COMMON_DEPEND}
	>=sys-auth/pambase-20101024-r2"
DEPEND="${COMMON_DEPEND}
	dev-util/gtk-doc-am
	dev-util/intltool
	sys-devel/gettext
	gnome? ( gnome-base/gnome-common )
	vala? ( $(vala_depend) )
"
PDEPEND="app-eselect/eselect-lightdm"

DOCS=( NEWS )
REQUIRED_USE="vala? ( introspection )"

src_prepare() {
	xdg_environment_reset

	sed -i -e 's:getgroups:lightdm_&:' tests/src/libsystem.c || die #412369
	sed -i -e '/minimum-uid/s:500:1000:' data/users.conf || die

	einfo "Fixing the session-wrapper variable in lightdm.conf"
	sed -i -e \
		"/^#session-wrapper/s@^.*@session-wrapper=/etc/${REAL_PN}/Xsession@" \
		data/lightdm.conf || die "Failed to fix lightdm.conf"

	# use correct version of qmake. bug #566950
	sed \
		-e "/AC_CHECK_TOOLS(MOC5/a AC_SUBST(MOC5,$(qt5_get_bindir)/moc)" \
		-i configure.ac || die

	default

	# Remove bogus Makefile statement. This needs to go upstream
	sed -i /"@YELP_HELP_RULES@"/d help/Makefile.am || die
	if has_version dev-libs/gobject-introspection; then
		eautoreconf
	else
		AT_M4DIR=${WORKDIR} eautoreconf
	fi

	use vala && vala_src_prepare
}

src_configure() {
	# Set default values if global vars unset
	local _user
	_user=${LIGHTDM_USER:=root}
	# Let user know how lightdm is configured
	einfo "Sabayon configuration"
	einfo "Greeter user: ${_user}"

	# also disable tests because libsystem.c does not build. Tests are
	# restricted so it does not matter anyway.
	local myeconfargs=(
		--localstatedir=/var
		--disable-static
		--disable-tests
		$(use_enable audit libaudit)
		$(use_enable introspection)
		--disable-liblightdm-qt
		--disable-liblightdm-qt5
		$(use_enable vala)
		--with-greeter-user=${_user}
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default

	# Delete apparmor profiles because they only work with Ubuntu's
	# apparmor package. Bug #494426
	if [[ -d ${ED%}/etc/apparmor.d ]]; then
		rm -r "${ED%}/etc/apparmor.d" || die \
			"Failed to remove apparmor profiles"
	fi

	insinto /etc/${REAL_PN}
	doins data/{${REAL_PN},keys}.conf
	doins "${FILESDIR}"/Xsession
	fperms +x /etc/${REAL_PN}/Xsession
	# /var/lib/lightdm-data could be useful. Bug #522228
	dodir /var/lib/lightdm-data

	find "${ED}" \( -name '*.a' -o -name "*.la" \) -delete || die
	rm -rf "${ED%/}"/etc/init

	# Remove existing pam file. We will build a new one. Bug #524792
	rm -rf "${ED%/}"/etc/pam.d/${REAL_PN}{,-greeter}
	pamd_mimic system-local-login ${REAL_PN} auth account password session #372229
	pamd_mimic system-local-login ${REAL_PN}-greeter auth account password session #372229
	dopamd "${FILESDIR}"/${REAL_PN}-autologin #390863, #423163

	readme.gentoo_create_doc

	systemd_dounit "${FILESDIR}/${REAL_PN}.service"
	keepdir /var/lib/${REAL_PN}-data
}

pkg_postinst() {
	systemd_reenable "${REAL_PN}.service"
}
