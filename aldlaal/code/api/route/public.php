<?php
if(!isset($fp)){echo json_encode(array("status" => 0));exit();}


if (!isset($p[1]) || $p[1] == '') {
    echo json_encode(array("status" => 0));exit();
}elseif($p[1] == 'properties'){
    include_once('public/properties.php');
}elseif($p[1] == 'home'){
    include_once('public/home.php');
}elseif($p[1] == 'agency'){
    include_once('public/agency.php');
}else{
    echo json_encode(array("status" => 0));exit();
}