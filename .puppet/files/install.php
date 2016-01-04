<?php

$_data = parse_ini_file('/vagrant/setupconfig/mage-settings.ini');

$_command = '/var/www/mage2/bin/magento setup:install ';
foreach($_data as $_key => $_value) {
    $_command .= "--{$_key}=".escapeshellarg($_value).' ';
}

var_dump($_command);
die();
exec($_command);
