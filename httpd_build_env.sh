#!/bin/bash

APACHEVERSION=2.4.18
APRVERSION=1.5.2
APRUTILVERSION=1.5.4

# Not found packages: libidn.so.11.rpm 
# Start siteminder deps
yum install binutils gcc libstdc++.i686 libidn.i686 ncurses.i686 ncurses-libs.i686 libXext.i686 libXrender.i686 ncureses-base.i686 libXtst.i686 libXau.i686 libXext.i686 libxcb.i686 compat-libstdc++-33.i686 compat-db42.i686 compat-db.i686 compat-db43.i686 libXi.i686 libX11.i686 libXtst.i686 libXrender.i686 libXft.i686 expat.i686 libXt.i686 freetype.i686 libXp.i686 fontconfig.i686 libstdc++.i686 libICE.i686 compat-libtermcap libuuid.i686 libSM.i686 

yum groupinstall "Development Tools"
# stop siteminder deps

yum install vim-enhanced wget

cd /tmp/
wget http://www.apache.org/dist/apr/KEYS
gpg --import KEYS
# import release manager public key
gpg --keyserver pgpkeys.mit.edu --recv-key 791485A8
gpg --keyserver pgpkeys.mit.edu --recv-key 39FF092C
gpg --fingerprint 791485A8
gpg --fingerprint 39FF092C

wget http://apache.uib.no//apr/apr-${APRVERSION}.tar.bz2
wget http://www.apache.org/dist/apr/apr-${APRVERSION}.tar.bz2.asc
gpg --verify apr-${APRVERSION}.tar.bz2.asc apr-${APRVERSION}.tar.bz2 
rpmbuild -ts apr-1.5.2.tar.bz2
rpmbuild -tb apr-1.5.2.tar.bz2
#bunzip2 apr-${APRVERSION}.tar.bz2
#tar -xvf apr-${APRVERSION}.tar

# dependency hell for apr-util
yum localinstall /root/rpmbuild/RPMS/x86_64/apr-*
sudo rpm -Uvh http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
gpg --quiet --with-fingerprint /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6
yum install expat-devel libuuid-devel db4-devel postgresql-devel mysql-devel sqlite-devel freetds-devel unixODBC-devel openldap-devel openssl-devel nss-devel 

wget http://apache.uib.no//apr/apr-util-${APRUTILVERSION}.tar.bz2
wget http://www.apache.org/dist/apr/apr-util-${APRUTILVERSION}.tar.bz2.asc
gpg --verify apr-util-${APRUTILVERSION}.tar.bz2.asc apr-util-${APRUTILVERSION}.tar.bz2
rpmbuild -ts apr-util-1.5.4.tar.bz2
rpmbuild -tb apr-util-1.5.4.tar.bz2
yum localinstall /root/rpmbuild/RPMS/x86_64/apr-*
#bunzip2 apr-util-${APRUTILVERSION}.tar.bz2
#tar -xvf apr-util-${APRUTILVERSION}.tar

yum install pcre-devel lua-devel libxml2-devel 
wget http://apache.uib.no//httpd/httpd-${APACHEVERSION}.tar.bz2
wget https://www.apache.org/dist/httpd/httpd-${APACHEVERSION}.tar.bz2.asc
gpg --verify httpd-${APACHEVERSION}.tar.bz2.asc httpd-2.4.18.tar.bz2
rpmbuild -ts httpd-${APACHEVERSION}.tar.bz2
rpm -ivh /root/rpmbuild/SRPMS/httpd-2.4.18-1.src.rpm
echo Now, manually, edit the SPEC file under /root/rpmbuild/SPECS/ and disable the distcache
vim /root/rpmbuild/SPECS/httpd.spec
#bunzip2 httpd-${APACHEVERSION}.tar.bz2
#tar -xvf httpd-${APACHEVERSION}.tar




LIBS=-lpthread
export LIBS
cd httpd-${APACHEVERSION}
configure --enable-module=so --prefix=your_install_target_directory

make

make install
