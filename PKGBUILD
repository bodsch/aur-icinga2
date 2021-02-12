# Maintainer: Julian Brost <julian@0x4a42.net>
# Contributor: Malte Rabenseifner <mail@malte-rabenseifner.de>
# Contributor: bebehei <bebe@bebehei.de>

pkgname=icinga2
pkgver=2.12.3
pkgrel=2
pkgdesc="An open source host, service and network monitoring program"
license=('GPL')
arch=('i686' 'x86_64')
url="http://www.icinga.org"
depends=('boost-libs' 'libedit' 'libsystemd' 'openssl' 'yajl' 'bison' 'flex')
optdepends=('monitoring-plugins: plugins needed for icinga checks'
            'libmariadbclient: for MySQL support'
            'postgresql-libs: for PostgreSQL support')
makedepends=('boost' 'cmake' 'libmariadbclient' 'postgresql-libs')
replaces=('icinga2-common')
backup=(etc/default/icinga2
        etc/init.d/icinga2
        etc/icinga2/features-available/api.conf
        etc/icinga2/features-available/checker.conf
        etc/icinga2/features-available/command.conf
        etc/icinga2/features-available/compatlog.conf
        etc/icinga2/features-available/debuglog.conf
        etc/icinga2/features-available/elasticsearch.conf
        etc/icinga2/features-available/gelf.conf
        etc/icinga2/features-available/graphite.conf
        etc/icinga2/features-available/icingadb.conf
        etc/icinga2/features-available/ido-mysql.conf
        etc/icinga2/features-available/ido-pgsql.conf
        etc/icinga2/features-available/influxdb.conf
        etc/icinga2/features-available/livestatus.conf
        etc/icinga2/features-available/mainlog.conf
        etc/icinga2/features-available/notification.conf
        etc/icinga2/features-available/opentsdb.conf
        etc/icinga2/features-available/perfdata.conf
        etc/icinga2/features-available/statusdata.conf
        etc/icinga2/features-available/syslog.conf
        etc/icinga2/constants.conf
        etc/icinga2/icinga2.conf
        etc/icinga2/scripts/mail-host-notification.sh
        etc/icinga2/scripts/mail-service-notification.sh
        etc/icinga2/zones.conf
        etc/logrotate.d/icinga2)
install='icinga2.install'
changelog="icinga2.changelog"
source=("https://github.com/Icinga/$pkgname/archive/v$pkgver.tar.gz"
        'https://patch-diff.githubusercontent.com/raw/Icinga/icinga2/pull/8184.patch'
        'https://github.com/Icinga/icinga2/commit/7e62a68eadada58e762d3f4261750796adffd440.diff'
        'https://github.com/Icinga/icinga2/commit/45dd71e0f9a93369e08d6cb26f97940f9c9594aa.diff'
        "$pkgname.tmpfiles"
        "$pkgname.sysusers"
        "openrc_$pkgname")
sha256sums=('56387d5e047df04fd91fdb8db3124eb09325c7377fbcaa11ef063147db816dfb'
            'dc1a2530d1c2c311826443cebaaa3c307f400e6a995414c654f4e6b94ec8b885'
            '52e50af7b10d75fcd6257fbf9b3c9043efb3cc497fac0970656fbffb1d328ee5'
            '1fa4c67f2f1bbed9814441d370ed50484bf64e57d16fddbbf5a0be8da9c7f1a2'
            '1302b333f49ead14f8808a379535971501d3a0c1ba02a7bf7b4406b7d27c754c'
            '2f946a33ea50a3c4400a81acd778e6411ffe5e2257a98004288b84a64f382810'
            '33250075ae529b6c84daa2b4d772b3bb311c5aa85ad984d280a1ac2426f7a924')

prepare() {
  cd "$srcdir/$pkgname-$pkgver"

  patch -p1 < "$srcdir/8184.patch"
  patch -p1 < "$srcdir/7e62a68eadada58e762d3f4261750796adffd440.diff"
  patch -p1 < "$srcdir/45dd71e0f9a93369e08d6cb26f97940f9c9594aa.diff"
}

build() {
  mkdir -p "$srcdir/$pkgname-$pkgver/build"
  cd "$srcdir/$pkgname-$pkgver/build"

  cmake "$srcdir/$pkgname-$pkgver" \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DCMAKE_INSTALL_SYSCONFDIR=/etc \
    -DICINGA2_RUNDIR=/run \
    -DCMAKE_INSTALL_SBINDIR=/usr/bin \
    -DCMAKE_INSTALL_LIBDIR=/usr/lib \
    -DCMAKE_INSTALL_LOCALSTATEDIR=/var \
    -DICINGA2_SYSCONFIGFILE=/etc/default/icinga2 \
    -DICINGA2_PLUGINDIR=/usr/lib/monitoring-plugins \
    -DINSTALL_SYSTEMD_SERVICE_AND_INITSCRIPT=ON \
    -DUSE_SYSTEMD=OFF \
    -DLOGROTATE_HAS_SU=OFF

  make
}

package() {
  cd "$srcdir/$pkgname-$pkgver/build"

  make DESTDIR="$pkgdir" install

  # move default config to conf.d.example
  mv "$pkgdir/etc/icinga2/conf.d" "$pkgdir/etc/icinga2/conf.d.example"
  mkdir "$pkgdir/etc/icinga2/conf.d"

  # restrict some filesystem locations by default
  chmod 750 "$pkgdir/etc/icinga2" \
            "$pkgdir/var/lib/icinga2" \
            "$pkgdir/var/spool/icinga2" \
            "$pkgdir/var/cache/icinga2" \
            "$pkgdir/var/log/icinga2"

  # config files for creating users, groups and tmp files/dirs
  install -Dm644 "$srcdir/$pkgname.tmpfiles" "$pkgdir/usr/lib/tmpfiles.d/$pkgname.conf"
  install -Dm644 "$srcdir/$pkgname.sysusers" "$pkgdir/usr/lib/sysusers.d/$pkgname.conf"

  # install openrc start-stop script

  install -Dm755 "$srcdir/../openrc_$pkgname" "/etc/init.d/$pkgname"

  # install syntax highlighting for vim and nano
  cd "$srcdir/$pkgname-$pkgver"
  install -Dm644 tools/syntax/vim/ftdetect/icinga2.vim "$pkgdir/usr/share/vim/vimfiles/ftdetect/icinga2.vim"
  install -Dm644 tools/syntax/vim/syntax/icinga2.vim "$pkgdir/usr/share/vim/vimfiles/syntax/icinga2.vim"
  install -Dm644 tools/syntax/nano/icinga2.nanorc "$pkgdir/usr/share/nano/icinga2.nanorc"

  # remove features-enabled symlink from the package so that they are not
  # recreated on package upgrades. they are initially set-up in the
  # post_install script.
  rm "$pkgdir/etc/icinga2/features-enabled/checker.conf"
  rm "$pkgdir/etc/icinga2/features-enabled/mainlog.conf"
  rm "$pkgdir/etc/icinga2/features-enabled/notification.conf"

  # ensure that nothing it left in features enables. make sure to keep the list
  # above in sync with post_install. rmdir && mkdir seems to be the easiest way
  # to check if the directory was actually empty.
  rmdir "$pkgdir/etc/icinga2/features-enabled" && mkdir "$pkgdir/etc/icinga2/features-enabled" || {
    error 'Features enabled by make install are inconsistent with those in package().'
    ls -l "$pkgdir/etc/icinga2/features-enabled"
    return 1
  }

  # check that the backup array contains all files in /etc except those explicitly excluded in the command below.
  diff -u \
    <(printf '%s\n' "${backup[@]}" | sort) \
    <(find "$pkgdir/etc" '(' \
        -path "$pkgdir/etc/bash_completion.d" -o \
        -path "$pkgdir/etc/icinga2/conf.d.example" -o \
        -path "$pkgdir/etc/icinga2/zones.d/README" \
      ')' -prune -o -type f -printf 'etc/%P\n' | sort) || {
    error 'Backup array and file installed to /etc are inconsistent.'
    return 1
  }

  # some cleanup
  rm -r "$pkgdir/run"
}
