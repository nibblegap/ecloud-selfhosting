<?php
$CONFIG = array (
  'lost_password_link' => 'https://mail.@@@DOMAIN@@@/users/password-recover.php',
  'htaccess.RewriteBase' => '/',
  'memcache.local' => '\OC\Memcache\APCu',
  'memcache.locking' => '\OC\Memcache\Redis',
  'redis' => [
    'host' => 'redis',
    'port' => 6379,
  ],
  'apps_paths' =>
  array (
    0 =>
    array (
      'path' => '/var/www/html/apps',
      'url' => '/apps',
      'writable' => false,
    ),
    1 =>
    array (
      'path' => '/var/www/html/custom_apps',
      'url' => '/custom_apps',
      'writable' => true,
    ),
  ),
  'trusted_domains' =>
  array (
    0 => '@@@DOMAIN@@@',
  ),
  'datadirectory' => '/var/www/html/data',
  'overwrite.cli.url' => 'https://@@@DOMAIN@@@',
  'overwriteprotocol' => 'https',
  'mysql.utf8mb4' => true,
  'maintenance' => true,
  'mail_from_address' => 'drive',
  'mail_smtpmode' => 'smtp',
  'mail_smtpauthtype' => 'PLAIN',
  'mail_domain' => '@@@DOMAIN@@@',
  'mail_smtpauth' => 1,
  'mail_smtphost' => 'mail.@@@DOMAIN@@@',
  'mail_smtpname' => 'drive@@@@DOMAIN@@@',
  'mail_smtppassword' => '@@@DRIVE_SMTP_PASSWORD@@@',
  'mail_smtpport' => '587',
  'mail_smtpsecure' => 'tls',
  'installed' => false,
  'user_backends' => array(
    array(
        'class' => 'OC_User_IMAP',
        'arguments' => array(
            'mail.@@@DOMAIN@@@', 993, 'ssl'
        ),
    ),
  ),
  'theme' => 'eelo',
  'loglevel' => 2,
  'preview_max_x' => 1024,
  'preview_max_y' => 1024,
);
?>
