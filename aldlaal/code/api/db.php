<?php
if(!isset($fp)){echo json_encode(array("status" => 0));exit();}
$db = @mysqli_connect("$db_host","$db_user","$db_pass","$db_name");
mysqli_query($db,"SET NAMES 'utf8'");
mysqli_query($db,'SET CHARACTER SET utf8');
mysqli_query($db,"SET TIME_ZONE = '".date('P')."'");
?>
