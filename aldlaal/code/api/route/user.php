<?php
if(!isset($fp)){echo json_encode(array("status" => 0));exit();}


if (!isset($p[1]) || $p[1] == '') {
    echo json_encode(array("status" => 0));exit();
}elseif($p[1] == 'properties'){
    include_once('user/properties.php');
}elseif($p[1] == 'chats'){
    include_once('user/chats.php');
}elseif($p[1] == 'alerts'){
    include_once('user/alerts.php');
}elseif($p[1] == 'id_verify'){
    include_once('user/id_verify.php');
}elseif($p[1] == 'settings'){
    include_once('user/settings.php');
}else{
    echo json_encode(array("status" => 0));exit();
}