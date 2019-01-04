<?php
function generate_setup_password_salt() {
    $salt = time() . '*' . $_SERVER['REMOTE_ADDR'] . '*' . mt_rand(0, 60000);
    $salt = md5($salt);
    return $salt;
}

function encrypt_setup_password($password, $salt) {
    return $salt . ':' . sha1($salt . ':' . $password);
}

$password="$argv[1]";

$pass = encrypt_setup_password($password, generate_setup_password_salt());
echo $pass."\n";
?>