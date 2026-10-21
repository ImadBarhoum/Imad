<?php
if(!isset($fp)){echo json_encode(array("status" => 0));exit();}


if (!isset($p[1]) || $p[1] == '') {
    echo json_encode(array("status" => 0));exit();
}elseif($p[1] == 'admins'){
    include_once('admin/admins.php');
}elseif($p[1] == 'settings'){
    include_once('admin/settings.php');
}elseif($p[1] == 'users'){
    include_once('admin/users.php');
}elseif($p[1] == 'agencys'){
    include_once('admin/agencies.php');
}elseif($p[1] == 'properties'){
    include_once('admin/properties.php');
}elseif($p[1] == 'settings'){
    include_once('admin/settings.php');
}elseif($p[1] == 'ads'){
    include_once('admin/ads.php');
}elseif($p[1] == 'chats'){
    include_once('admin/chats.php');
}else{
    echo json_encode(array("status" => 0));exit();
}
