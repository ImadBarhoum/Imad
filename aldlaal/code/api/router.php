<?php
if(!isset($fp)){echo json_encode(array("status" => 0));exit();}
include_once('services/mailer.php');
include_once('services/functions.php');
include_once('services/auth.php');

if($p[0] == ''){
    echo json_encode(array("status" => 0));exit();
}elseif($p[0] == 'admin' && $auth['valid'] == 1 && $auth['data']->user_type == "admin"){
    include_once('route/admin.php');
}elseif($p[0] == 'agency' && $auth['valid'] == 1 && $auth['data']->user_type == "user"){
    include_once('route/agency.php');
}elseif($p[0] == 'user' && $auth['valid'] == 1 && $auth['data']->user_type == "user"){
    include_once('route/user.php');
}elseif($p[0] == 'public'){
    include_once('route/public.php');
}elseif($p[0] == 'img'){
    include_once('services/imgs.php');
}elseif($p[0] == 'videos'){
    include_once('services/videos.php');
}elseif($p[0] == 'others'){
    include_once('services/others.php');
}elseif($p[0] == 'link'){
    include_once('services/link.php');
}elseif($p[0] == 'cron'){
    include_once('services/cron.php');
}elseif($p[0] == 'test'){
    include_once('services/test.php');
}else{echo json_encode(array("status" => 0));exit();}

