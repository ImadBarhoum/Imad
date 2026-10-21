<?php
//ini_set('display_errors', 1);
//date_default_timezone_set('Asia/Amman');
$fp = 1;
include 'vendor/autoload.php';
include_once('config.php');
include_once('db.php');
isset($_GET['p']) ? $p = $_GET['p'] : $p = '';
if(isset($p[0]) && $p[0] == '/'){$p = substr($p, 1);}
header('Access-Control-Allow-Origin:*');
header('Access-Control-Allow-Method:*');
header('Access-Control-Allow-Headers:*');
header('Content-Type:application/json');
$p = explode('/', ltrim($p, '/'));
$rawdata = json_decode(file_get_contents('php://input'), true);
if(!in_array($_SERVER['REQUEST_METHOD'],array('POST','GET'))){echo json_encode(array("status" => 0));exit();}
include_once('router.php');