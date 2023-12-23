# Maintainer: Julian Brost <julian@0x4a42.net>
# Contributor: Malte Rabenseifner <mail@malte-rabenseifner.de>
# Contributor: bebehei <bebe@bebehei.de>

pkgname=icinga2
pkgver=2.14.1
pkgrel=2

pkgdesc="An open source host, service and network monitoring program"
license=('GPL')
arch=('i686' 'x86_64')
url="http://www.icinga.org"
depends=('boost-libs' 'libedit' 'openssl' 'yajl' 'bison' 'flex')
optdepends=('monitoring-plugins: plugins needed for icinga checks'
            'libmariadbclient: for MySQL support'
            'postgresql-libs: for PostgreSQL support')

makedepends=('boost' 'cmake' 'libmariadbclient' 'postgresql-libs')

replaces=('icinga2-common')

backup=(
    etc/conf.d/icinga2
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
    etc/icinga2/features-available/influxdb2.conf
    etc/icinga2/features-available/livestatus.conf
    etc/icinga2/features-available/mainlog.conf
    etc/icinga2/features-available/notification.conf
    etc/icinga2/features-available/opentsdb.conf
    etc/icinga2/features-available/perfdata.conf
    etc/icinga2/features-available/syslog.conf
    etc/icinga2/constants.conf
    etc/icinga2/icinga2.conf
    etc/icinga2/scripts/mail-host-notification.sh
    etc/icinga2/scripts/mail-service-notification.sh
    etc/icinga2/zones.conf
    etc/logrotate.d/icinga2
)
install='icinga2.install'
changelog="icinga2.changelog"

source=(
    "${pkgname}-${pkgver}-${CARCH}.tar.gz::https://github.com/Icinga/$pkgname/archive/v$pkgver.tar.gz"
    "$pkgname.tmpfiles"
    "$pkgname.sysusers"
    "openrc_$pkgname"
    "openrc_${pkgname}_conf"
)

sha512sum=(
    "dbdf1fb06b2cf3d7566194ed9f5883f05848cbc3f740a704f76868e985f2ac943389d56943f55bdba2900966c39472c6031bf032d815881fc64890c04de911dd"
    "51811add3f83df870f4b18ad97a6a9ccaf5be7ab4c0614b0d85cfccf5dc3e3debd7df42ecfe08c00a1b4d25e5b4326214f6a9c079fbf2886fc9e5a4c3b8ebbba"
    "875843000bf40cedffadee9ec0691d88173610befd653da06ea3828e2b1c5c36ddcb308bdba053f72c9311f8f023be044abb9dc41a712381cdf62e0e8434dd2e"
    "44c870fc44aebad5c4a106c301836f0b3c46c6fca8bd50d6833527cf33c4550b9781d7251821db8789aa41fb5f6eb26d2e3d5a18a38f940a93eee0c54c02ad59"
    "f5cdec7d4fd00eeb56a14bd1ba3c8e1b3d137bc91d97633163c44c026fb9da6e8e5f1de468b64be598f3da9c85f15460e4941093905bc91864aceab60fb470f1"
)

sha256sums=(
    '205520b8e3ad50bc6f97a5a5659537df3bbf57f8d513bffaf0dde741e1fe31cd'
    '1302b333f49ead14f8808a379535971501d3a0c1ba02a7bf7b4406b7d27c754c'
    '2f946a33ea50a3c4400a81acd778e6411ffe5e2257a98004288b84a64f382810'
    '77c52109de6c05e87d8d285b7f16a09855296d67dbdcfc0bf33a42ee000eb3e3'
    '88e057f14b07bdf6d4284ba6194ea1527188af6462526720a5fa14327287b667'
)

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
    -DICINGA2_SYSCONFIGFILE=/etc/conf.d/icinga2 \
    -DICINGA2_PLUGINDIR=/usr/lib/monitoring-plugins \
    -DINSTALL_SYSTEMD_SERVICE_AND_INITSCRIPT=OFF \
    -DICINGA2_VERSION=$pkgver-$pkgrel \
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
  sudo install -Dm755 "$srcdir/../openrc_$pkgname" "/etc/init.d/$pkgname"
  # install openrc config file
  sudo install -Dm755 "$srcdir/../openrc_${pkgname}_conf" "/etc/conf.d/$pkgname"

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
