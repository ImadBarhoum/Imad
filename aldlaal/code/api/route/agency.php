<?php
if(!isset($fp)){echo json_encode(array("status" => 0));exit();}


if (!isset($p[1]) || $p[1] == '') {
    echo json_encode(array("status" => 0));exit();
}elseif($p[1] == 'properties'){
    include_once('agency/properties.php');
}elseif($p[1] == 'agency'){
    include_once('agency/agency.php');
}elseif($p[1] == 'chats'){
    include_once('agency/chats.php');
}elseif($p[1] == 'settings'){
    include_once('agency/settings.php');
}else{
    echo json_encode(array("status" => 0));exit();
}