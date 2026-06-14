# frozen_string_literal: true

require 'spec_helper'
require 'facter'
require 'facter/portage'

describe 'portage fact specs', type: :fact do
  subject(:fact) { Facter.fact(:portage) }

  before do
    Facter.clear
    allow(Facter.fact(:os)).to receive(:value).and_return({ 'family' => 'Gentoo' })
  end

  it 'correctly show portage informations' do
    allow(Facter::Core::Execution).to receive(:exec)
      .with('/usr/bin/emerge --info')
      .and_return(%(
Portage 3.0.79 (python 3.14.4-final-0, default/linux/amd64/23.0/no-multilib, gcc-15, glibc-2.43-r2, 7.0.11-arch1-1 x86_64)
=================================================================
System uname: Linux-7.0.11-arch1-1-x86_64-AMD_Ryzen_5_PRO_5675U_with_Radeon_Graphics-with-glibc2.43
KiB Mem:    15120080 total,   3500700 free
KiB Swap:    2097148 total,   1750280 free
Timestamp of repository gentoo: Mon, 08 Jun 2026 00:45:00 +0000
Timestamp of repository SwordArMor: 1
Head commit of repository SwordArMor: 5d2ed42b499e422b607f5c175592fc80cafadb2f

Timestamp of repository guru: Sun, 07 Jun 2026 02:46:24 +0000
Head commit of repository guru: 96f28d33f86a12293fa573bf1cf9549c121daff4

sh bash 5.3_p9-r1
ld GNU ld (Gentoo 2.46.0 p1) 2.46.0
app-misc/pax-utils:        1.3.10::gentoo
app-shells/bash:           5.3_p9-r1::gentoo
dev-build/autoconf:        2.72-r7::gentoo
dev-build/automake:        1.18.1-r1::gentoo
dev-build/cmake:           4.3.3::gentoo
dev-build/libtool:         2.5.4::gentoo
dev-build/make:            4.4.1-r102::gentoo
dev-build/meson:           1.10.2::gentoo
dev-java/java-config:      2.3.4::gentoo
dev-lang/perl:             5.42.0-r1::gentoo
dev-lang/python:           3.14.4_p1::gentoo
sys-apps/baselayout:       2.18-r1::gentoo
sys-apps/openrc:           0.63.1::gentoo
sys-apps/sandbox:          2.46::gentoo
sys-devel/binutils:        2.46.0::gentoo
sys-devel/binutils-config: 5.6::gentoo
sys-devel/gcc:             15.2.1_p20260214::gentoo
sys-devel/gcc-config:      2.12.2::gentoo
sys-kernel/linux-headers:  6.18::gentoo (virtual/os-headers)
sys-libs/glibc:            2.43-r2::gentoo
sys-libs/libselinux:       3.10-r1::gentoo
Repositories:

gentoo
    location: /var/db/repos/gentoo
    sync-type: webrsync
    sync-uri: rsync://rsync.gentoo.org/gentoo-portage
    priority: -1000
    volatile: False
    sync-webrsync-verify-signature: yes

SwordArMor
    location: /var/db/repos/SwordArMor
    sync-type: git
    sync-uri: https://gitlab.grifon.fr/alarig/SwordArMor-gentoo-overlay.git
    masters: guru gentoo
    volatile: True

guru
    location: /var/db/repos/guru
    sync-type: git
    sync-uri: https://github.com/gentoo-mirror/guru.git
    masters: gentoo
    volatile: True

Binary Repositories:

samis
    location: /var/cache/binhost/samis
    priority: 10
    sync-uri: http://samis.grif/build-grifon
    verify-signature: False

gentoo
    location: /var/cache/binhost/gentoo
    priority: 1
    sync-uri: https://distfiles.gentoo.org/releases/amd64/binpackages/23.0/x86-64
    verify-signature: True

ACCEPT_KEYWORDS="amd64"
ACCEPT_LICENSE="* -@EULA"
CBUILD="x86_64-pc-linux-gnu"
CFLAGS="-O2 -pipe -march=native -mtune=native"
CHOST="x86_64-pc-linux-gnu"
CONFIG_PROTECT="/etc"
CONFIG_PROTECT_MASK="/etc/ca-certificates.conf /etc/env.d /etc/fonts/fonts.conf /etc/gconf /etc/gentoo-release /etc/revdep-rebuild /etc/sandbox.d"
CXXFLAGS="-O2 -pipe -march=native -mtune=native"
DISTDIR="/var/cache/distfiles"
ENV_UNSET="CARGO_HOME DBUS_SESSION_BUS_ADDRESS DISPLAY GDK_PIXBUF_MODULE_FILE GOBIN GOPATH PERL5LIB PERL5OPT PERLPREFIX PERL_CORE PERL_MB_OPT PERL_MM_OPT XAUTHORITY XDG_CACHE_HOME XDG_CONFIG_DIRS XDG_CONFIG_HOME XDG_DATA_DIRS XDG_DATA_HOME XDG_RUNTIME_DIR XDG_STATE_HOME"
FCFLAGS="-O2 -pipe -march=native -mtune=native"
FEATURES="assume-digests binpkg-docompress binpkg-dostrip binpkg-logs binpkg-multi-instance buildpkg-live compress-index config-protect-if-modified distlocks ebuild-locks fixlafiles getbinpkg ipc-sandbox merge-sync merge-wait multilib-strict network-sandbox news parallel-fetch pid-sandbox pkgdir-index-trusted preserve-libs protect-owned qa-unresolved-soname-deps sandbox strict unknown-features-warn unmerge-logs unmerge-orphans userfetch userpriv usersandbox usersync xattr"
FFLAGS="-O2 -pipe -march=native -mtune=native"
GENTOO_MIRRORS="https://herbizarre.swordarmor.fr https://ftp.uni-erlangen.de/pub/mirrors/gentoo"
LANG="C.UTF-8"
LDFLAGS="-Wl,-O1 -Wl,--as-needed -Wl,-z,pack-relative-relocs"
LEX="flex"
MAKEOPTS="-j10"
PKGDIR="/var/cache/binpkgs"
PORTAGE_COMPRESS="bzip2"
PORTAGE_CONFIGROOT="/"
PORTAGE_RSYNC_OPTS="--recursive --links --safe-links --perms --times --omit-dir-times --compress --force --whole-file --delete --stats --human-readable --timeout=180 --exclude=/distfiles --exclude=/local --exclude=/packages --exclude=/.git"
PORTAGE_TMPDIR="/var/tmp"
RUSTFLAGS=" -C target-cpu=native"
SHELL="/bin/bash"
USE="acl amd64 bash-completion bzip2 cet crypt curl dedicated gdbm git iconv ipv6 leaps_timezone libtirpc lto man ncurses nls openmp openssl pam pcre pgo readline seccomp server ssl symlink test-rust threads unicode vim-pager vim-syntax xattr zlib" ABI_X86="64" ADA_TARGET="gcc_15" APACHE2_MODULES="authn_core authz_core socache_shmcb unixd actions alias auth_basic authn_anon authn_dbm authn_file authz_dbm authz_groupfile authz_host authz_owner authz_user autoindex cache cgi cgid dav dav_fs dav_lock deflate dir env expires ext_filter file_cache filter headers include info log_config logio mime mime_magic negotiation rewrite setenvif speling status unique_id userdir usertrack vhost_alias" CALLIGRA_FEATURES="karbon sheets words" COLLECTD_PLUGINS="df interface irq load memory rrdtool swap syslog" CPU_FLAGS_X86="aes avx avx2 bmi1 bmi2 f16c fma3 mmx mmxext pclmul popcnt rdrand sha sse sse2 sse3 sse4_1 sse4_2 sse4a ssse3 vpclmulqdq" ELIBC="glibc" GPSD_PROTOCOLS="ashtech aivdm earthmate evermore fv18 garmin garmintxt gpsclock greis isync itrax navcom oncore skytraq superstar2 tsip tripmate tnt" GUILE_SINGLE_TARGET="3-0" GUILE_TARGETS="3-0" INPUT_DEVICES="libinput" KERNEL="linux" LCD_DEVICES="bayrad cfontz glk hd44780 lb216 lcdm001 mtxorb text" LLVM_TARGETS="X86" LUA_SINGLE_TARGET="lua5-1" LUA_TARGETS="lua5-1" OFFICE_IMPLEMENTATION="libreoffice" PHP_TARGETS="php8-3" POSTGRES_TARGETS="postgres17" PYTHON_SINGLE_TARGET="python3_14" PYTHON_TARGETS="python3_14" QEMU_SOFTMMU_TARGETS="x86_64" RUBY_TARGETS="ruby33" VIDEO_CARDS="amdgpu fbdev intel nouveau radeon radeonsi vesa dummy" XTABLES_ADDONS="quota2 psd pknock lscan length2 ipv4options ipp2p iface geoip fuzzy condition tarpit sysrq proto logmark ipmark dhcpmac delude chaos account"
Unset:  ADDR2LINE, AR, ARFLAGS, AS, ASFLAGS, CC, CCLD, CONFIG_SHELL, CPP, CPPFLAGS, CTARGET, CXX, CXXFILT, ELFEDIT, EMERGE_DEFAULT_OPTS, EXTRA_ECONF, F77FLAGS, FC, GCOV, GPROF, INSTALL_MASK, LC_ALL, LD, LFLAGS, LIBTOOL, LINGUAS, MAKE, MAKEFLAGS, NM, OBJCOPY, OBJDUMP, PORTAGE_BINHOST, PORTAGE_BUNZIP2_COMMAND, PORTAGE_COMPRESS_FLAGS, PORTAGE_RSYNC_EXTRA_OPTS, PYTHONPATH, RANLIB, READELF, SIZE, STRINGS, STRIP, YACC, YFLAGS
))

    expect(Facter.fact(:portage).value)
      .to eq({
               'abi_x86' => '64',
               'accept_keywords' => 'amd64',
               'accept_license' => '* -@EULA',
               'ada_target' => 'gcc_15',
               'apache2_modules' => 'authn_core authz_core socache_shmcb unixd actions alias auth_basic authn_anon authn_dbm authn_file authz_dbm authz_groupfile authz_host authz_owner authz_user autoindex cache cgi cgid dav dav_fs dav_lock deflate dir env expires ext_filter file_cache filter headers include info log_config logio mime mime_magic negotiation rewrite setenvif speling status unique_id userdir usertrack vhost_alias',
               'binary_repositories' => {
                 'gentoo' => {
                   'location' => '/var/cache/binhost/gentoo',
                   'priority' => '1',
                   'sync-uri' => 'https://distfiles.gentoo.org/releases/amd64/binpackages/23.0/x86-64',
                   'verify-signature' => 'True',
                 },
                 'samis' => {
                   'location' => '/var/cache/binhost/samis',
                   'priority' => '10',
                   'sync-uri' => 'http://samis.grif/build-grifon',
                   'verify-signature' => 'False',
                 },
               },
               'calligra_features' => 'karbon sheets words',
               'cbuild' => 'x86_64-pc-linux-gnu',
               'cflags' => '-O2 -pipe -march=native -mtune=native',
               'chost' => 'x86_64-pc-linux-gnu',
               'collectd_plugins' => 'df interface irq load memory rrdtool swap syslog',
               'config_protect' => '/etc',
               'config_protect_mask' => '/etc/ca-certificates.conf /etc/env.d /etc/fonts/fonts.conf /etc/gconf /etc/gentoo-release /etc/revdep-rebuild /etc/sandbox.d',
               'cpu_flags_x86' => 'aes avx avx2 bmi1 bmi2 f16c fma3 mmx mmxext pclmul popcnt rdrand sha sse sse2 sse3 sse4_1 sse4_2 sse4a ssse3 vpclmulqdq',
               'cxxflags' => '-O2 -pipe -march=native -mtune=native',
               'distdir' => '/var/cache/distfiles',
               'elibc' => 'glibc',
               'env_unset' => 'CARGO_HOME DBUS_SESSION_BUS_ADDRESS DISPLAY GDK_PIXBUF_MODULE_FILE GOBIN GOPATH PERL5LIB PERL5OPT PERLPREFIX PERL_CORE PERL_MB_OPT PERL_MM_OPT XAUTHORITY XDG_CACHE_HOME XDG_CONFIG_DIRS XDG_CONFIG_HOME XDG_DATA_DIRS XDG_DATA_HOME XDG_RUNTIME_DIR XDG_STATE_HOME',
               'fcflags' => '-O2 -pipe -march=native -mtune=native',
               'features' => 'assume-digests binpkg-docompress binpkg-dostrip binpkg-logs binpkg-multi-instance buildpkg-live compress-index config-protect-if-modified distlocks ebuild-locks fixlafiles getbinpkg ipc-sandbox merge-sync merge-wait multilib-strict network-sandbox news parallel-fetch pid-sandbox pkgdir-index-trusted preserve-libs protect-owned qa-unresolved-soname-deps sandbox strict unknown-features-warn unmerge-logs unmerge-orphans userfetch userpriv usersandbox usersync xattr',
               'fflags' => '-O2 -pipe -march=native -mtune=native',
               'gentoo_mirrors' => 'https://herbizarre.swordarmor.fr https://ftp.uni-erlangen.de/pub/mirrors/gentoo',
               'gpsd_protocols' => 'ashtech aivdm earthmate evermore fv18 garmin garmintxt gpsclock greis isync itrax navcom oncore skytraq superstar2 tsip tripmate tnt',
               'guile_single_target' => '3-0',
               'guile_targets' => '3-0',
               'input_devices' => 'libinput',
               'kernel' => 'linux',
               'lang' => 'C.UTF-8',
               'lcd_devices' => 'bayrad cfontz glk hd44780 lb216 lcdm001 mtxorb text',
               'ldflags' => '-Wl,-O1 -Wl,--as-needed -Wl,-z,pack-relative-relocs',
               'lex' => 'flex',
               'llvm_targets' => 'X86',
               'lua_single_target' => 'lua5-1',
               'lua_targets' => 'lua5-1',
               'makeopts' => '-j10',
               'office_implementation' => 'libreoffice',
               'php_targets' => 'php8-3',
               'pkgdir' => '/var/cache/binpkgs',
               'portage_compress' => 'bzip2',
               'portage_configroot' => '/',
               'portage_rsync_opts' => '--recursive --links --safe-links --perms --times --omit-dir-times --compress --force --whole-file --delete --stats --human-readable --timeout=180 --exclude=/distfiles --exclude=/local --exclude=/packages --exclude=/.git',
               'portage_tmpdir' => '/var/tmp',
               'postgres_targets' => 'postgres17',
               'python_single_target' => 'python3_14',
               'python_targets' => 'python3_14',
               'qemu_softmmu_targets' => 'x86_64',
               'repositories' => {
                 'SwordArMor' => {
                   'location' => '/var/db/repos/SwordArMor',
                   'masters' => 'guru gentoo',
                   'sync-type' => 'git',
                   'sync-uri' => 'https://gitlab.grifon.fr/alarig/SwordArMor-gentoo-overlay.git',
                   'volatile' => 'True',
                 },
                 'gentoo' => {
                   'location' => '/var/db/repos/gentoo',
                   'priority' => '-1000',
                   'sync-type' => 'webrsync',
                   'sync-uri' => 'rsync://rsync.gentoo.org/gentoo-portage',
                   'sync-webrsync-verify-signature' => 'yes',
                   'volatile' => 'False',
                 },
                 'guru' => {
                   'location' => '/var/db/repos/guru',
                   'masters' => 'gentoo',
                   'sync-type' => 'git',
                   'sync-uri' => 'https://github.com/gentoo-mirror/guru.git',
                   'volatile' => 'True',
                 },
               },
               'ruby_targets' => 'ruby33',
               'rustflags' => ' -C target-cpu=native',
               'shell' => '/bin/bash',
               'use' => 'acl amd64 bash-completion bzip2 cet crypt curl dedicated gdbm git iconv ipv6 leaps_timezone libtirpc lto man ncurses nls openmp openssl pam pcre pgo readline seccomp server ssl symlink test-rust threads unicode vim-pager vim-syntax xattr zlib',
               'video_cards' => 'amdgpu fbdev intel nouveau radeon radeonsi vesa dummy',
               'xtables_addons' => 'quota2 psd pknock lscan length2 ipv4options ipp2p iface geoip fuzzy condition tarpit sysrq proto logmark ipmark dhcpmac delude chaos account',
             })
  end
end
