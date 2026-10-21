<?php
if(!isset($fp)){echo json_encode(array("status" => 0));exit();}
$db = @mysqli_connect("$db_host","$db_user","$db_pass","$db_name");
if(!$db){echo json_encode(array("status" => 0));exit();}
mysqli_set_charset($db,'utf8mb4');
mysqli_query($db,"SET TIME_ZONE = '".date('P')."'");
?>
