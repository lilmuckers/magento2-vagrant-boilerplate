#!/bin/bash

usage()
{
cat << EOF
usage $0 options

This script reinstalls magento 2

OPTONS:
    -s Include Sample Data
    -h Show this message
EOF
}

SAMPLE_DATA=
while getopts "hs" o; do
    case "${o}" in
        s)
            SAMPLE_DATA=1
            ;;
        h)
            usage
            exit 1
            ;;
    esac
done

cd /var/www/mage2
rm -rf var/*
rm var/.maintenance.flag

if [[ -n $SAMPLE_DATA ]]; then
    echo "[+] Install sample data"
    php -f /vagrant/data/magento2-sample-data/dev/tools/build-sample-data.php -- --ce-source="/vagrant/data/magento2/"
fi

echo "[+] Composer..."
composer install

export MAGE_MODE='developer'
chmod +x bin/magento

echo "[+] Uninstalling..."
php -f magento setup:uninstall -n

echo "[+] Installing..."

install_cmd="php /vagrant/.puppet/files/install.php"

eval ${install_cmd}

#change directory back to where user ran script
cd -
