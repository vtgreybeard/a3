#!/bin/bash

silent=false
if [ "$1" = "-s" ]; then
    silent=true
fi
set -e

check_os() {
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        OS_NAME=$ID
        OS_VERSION_ID=$VERSION_ID
	echo "We're a supported os ${VERSION_ID}"
    else
        echo "Unsupported OS (Debian or variant required)"
	echo "Found ${OS_NAME} (${OS_VERSION})"
        exit 1
    fi
}
echo "Checking os now..."
check_os

if [ "$silent" = false ]; then
while true; do
	echo This will install the A3/Alike software locally.
	read -p "Do you want to continue? (y/n): " choice
	case "$choice" in
	    y|Y ) echo "Continuing..."; break;;
	    n|N ) echo "Exiting"; exit 0;;
	    * ) echo "Invalid input. Please enter 'y' or 'n'.";;
	esac
done


USER="alike"
PASS="alike"
ID=1000
if ! getent group $ID > /dev/null; then
	sudo groupadd -g $ID $USER
fi

if ! id $USER > /dev/null 2>&1; then
	useradd -u $ID -g $ID -m $USER
	echo "$USER:$PASS" | sudo chpasswd
	echo "Password for user $USER set to '$PASS'."
else
	echo "User $USER already exists."
fi
done
fi

chsh -s /bin/bash alike

echo "Updating package list..."
apt update
apt-get install -qq -y \
libc6 cron dos2unix rsyslog python3 samba samba-common samba-common-bin samba-dsdb-modules samba-libs samba-vfs-modules \
openresolv screen shared-mime-info snmpd sqlite3 msmtp inetutils-ping stunnel sudo traceroute util-linux-locales wget \
xz-utils pv p7zip p7zip-full \
parted openssh-client openssh-server openssh-sftp-server openssl net-tools wireguard gdisk bindfs \
nfs-kernel-server nginx lsb-release lsof lz4 kpartx logrotate mono-complete \
fuse dos2unix curl apt apt-listchanges apt-utils util-linux-locales util-linux vim gawk php php-fpm php-cli php-cgi php-sqlite3 php-curl php-mbstring --no-install-recommends;
systemctl enable nginx
systemctl start nginx


# Now move onto the Alike software 
cp ../configs/nginx.conf.etc /etc/nginx/nginx.conf

PHP_VERSION=$(php -r "echo PHP_VERSION;")
PHP_DIR="/etc/php/${PHP_VERSION%.*}/"
WWWCONF="${PHP_DIR}fpm/pool.d/www.conf"
if [[ -f "$WWWCONF" ]]; then
    sudo sed -i 's/^user = .*/user = alike/' "$WWWCONF"
else
    echo "Configuration file $WWWCONF does not exist."
    exit 1
fi

mkdir -p /home/alike/configs/
mkdir -p /home/alike/certs/
mkdir -p /usr/local/sbin/
mkdir -p /home/alike/Alike/docroot/
mkdir -p /home/alike/Alike/bin/
mkdir -p /home/alike/Alike/java/
mkdir -p /home/alike/Alike/ext/
mkdir -p /home/alike/Alike/DBs/
mkdir -p /home/alike/Alike/remoteDBs/
mkdir -p /home/alike/Alike/temp/
mkdir -p /home/alike/Alike/agentShare/
mkdir -p /mnt/instaboot/
mkdir -p /mnt/instaboot/base/xen
mkdir -p /mnt/instaboot/sr/xen
mkdir -p /mnt/ads
mkdir -p /mnt/ods1
ln -sf /mnt/ods1 /mnt/ods

dpkg -i ../binaries/xapi-xe_1.249.3-2_amd64.deb

cp ../configs/nginx.conf /home/alike/configs/
cp ../configs/*.pem /home/alike/certs/
cp -r ../webui/* /home/alike/Alike/docroot/
mv -n /home/alike/Alike/hooks /home/alike/Alike/
cp ../appliance/* /usr/local/sbin/
cp -r ../binaries/java/* /home/alike/Alike/java/
cp ../binaries/abd.dat.7z /home/alike/Alike/ext/
cp -r ../binaries/blkfs /usr/local/sbin/

echo "3.85" > /home/alike/a3.rev

chown -R alike:alike /home/alike/Alike

#echo "Upgrading installed packages..."
#apt upgrade -y

echo "Setup completed successfully!"

