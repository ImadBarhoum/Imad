<?php
if(!isset($fp)){echo json_encode(array("status" => 0));exit();}
//CONFIG
$domain = "";
$path = "";
$ssl = "https://"; // https or http
$secret_key = "";
$login_session_time = (3600*24*30*3); // session for 3 month
$telegram_users = [];
$telegram_key = "";
//SMS API
$sms_api_user= "";
$sms_api_pwd= "";
$sms_api_sender= "";
$sms_api_key= "";
// Whatsapp API
$whatsapp_instance_id = "";
$whatsapp_access_token = "";
// SMTP (email OTP)
$smtp_host = "";
$smtp_user = "";
$smtp_pass = "";
// Twilio SMS (numbers outside Syria/Jordan)
$twilio_sid = "";
$twilio_token = "";
$twilio_from = "";
// DATABASE
$db_host = "127.0.0.1";
$db_user = "";
$db_pass = "";
$db_name = "";
// Firebase
$firebaseAuthFile = '{}';
?>