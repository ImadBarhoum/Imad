<?php
if(!isset($fp)){echo json_encode(array("status" => 0));exit();}
use Firebase\JWT\JWT;
use Firebase\JWT\Key;
// run
if(in_array($p[0],array('admin_login','login','user_login_phone','register','reset_password','send_email_otp','send_phone_otp'))){
    $user = isset($rawdata["user"]) ? mysqli_real_escape_string($db,$rawdata["user"]) : '';
    $email = isset($rawdata["email"]) ? mysqli_real_escape_string($db,$rawdata["email"]) : '';
    $pwd = isset($rawdata["pwd"]) && is_string($rawdata["pwd"]) ? $rawdata["pwd"] : '';
    $name = isset($rawdata["name"]) ? mysqli_real_escape_string($db,$rawdata["name"]) : '';
    $phone = isset($rawdata["phone"]) ? mysqli_real_escape_string($db,$rawdata["phone"]) : '';
    $city = isset($rawdata["city"]) ? mysqli_real_escape_string($db,$rawdata["city"]) : '';
    $state = isset($rawdata["state"]) ? mysqli_real_escape_string($db,$rawdata["state"]) : '';
    $otp = isset($rawdata["otp"]) ? mysqli_real_escape_string($db,$rawdata["otp"]) : '';
    $type = isset($rawdata["type"]) ? mysqli_real_escape_string($db,$rawdata["type"]) : '';
}

if($p[0] == 'admin_login'){
    admin_login($user,$pwd);
}elseif($p[0] == 'login'){
    user_login($email,$pwd);
}elseif($p[0] == 'user_login_phone'){
    user_login_phone($phone,$otp);
}elseif($p[0] == 'check'){
    checkLogin();
}elseif($p[0] == 'force_logout'){
    force_logout();
}elseif($p[0] == 'register'){
    user_register($name,$email,$pwd,$phone,$city,$state,$otp,$type);
}elseif($p[0] == 'send_email_otp'){
    send_email_otp($email,$type);
}elseif($p[0] == 'send_phone_otp'){
    send_phone_otp($phone,$type);
}elseif($p[0] == 'reset_password'){
    reset_password($email,$pwd,$otp);
}elseif($p[0] == 'app_check'){
    app_check();
}elseif($p[0] == 'get_settings'){
    get_settings();
}else{
    $auth = jwt_checker();
}





function admin_login($user,$pwd){
    global $secret_key,$db;
    $user = strtolower($user);
    $qr0 = mysqli_query($db,"select id,user,pwd,token from admin where user='$user' and valid='1'");
    $row = mysqli_num_rows($qr0);
    $qr = mysqli_fetch_object($qr0);
    $needs_rehash = false;
    if($row == 1 && $user == $qr->user && check_pwd($pwd,$qr->pwd,$needs_rehash)){
        if($needs_rehash){upgrade_pwd('admin',$qr->id,$pwd,$qr->pwd);}
        $payload = [
            'exp' => time() + (3600*24*30), // session for 1 month
            'data' => [
                'user_type' => 'admin',
                'id' => intval($qr->id),
                'user' => $qr->user,
                'token' => $qr->token,
            ],
        ];
        $jwt = JWT::encode($payload, $secret_key, 'HS256');
        $res = array(
            "status" => 1,
            "token" => $jwt,
            'data' => $payload['data'],
        );
    }else{
        $res = array("status" => 0);
    }
    echo json_encode($res);exit();
}

function user_login($email,$pwd){
    global $secret_key,$db;
    $email = strtolower(trim($email));
    $qr0 = mysqli_query($db,"select id,email,pwd,login_token from users where email='$email' and status='active'");
    $row = mysqli_num_rows($qr0);
    $qr = mysqli_fetch_object($qr0);
    $needs_rehash = false;
    if($row == 1 && $email == $qr->email && check_pwd($pwd,$qr->pwd,$needs_rehash)){
        if($needs_rehash){upgrade_pwd('users',$qr->id,$pwd,$qr->pwd);}
        $payload = [
            'exp' => time() + (3600*24*30), // session for 1 month
            'data' => [
                'user_type' => 'user',
                'id' => intval($qr->id),
                'user' => $qr->email,
                'token' => $qr->login_token,
            ],
        ];
        $jwt = JWT::encode($payload, $secret_key, 'HS256');
        $res = array(
            "status" => 1,
            "token" => $jwt,
            'data' => $payload['data'],
        );
    }else{
        $res = array("status" => 0);
    }
    echo json_encode($res);exit();
}

function user_login_phone($phone,$otp){
    global $secret_key,$db;
    $phone = str_replace('+','',$phone);
    $qr0 = mysqli_query($db,"select id,email,otp,attempts from otp_temp where email='$phone' and create_at >= DATE_SUB(NOW(), INTERVAL 10 MINUTE)");
    $row = mysqli_num_rows($qr0);
    if($row != 0){
        $qr = mysqli_fetch_object($qr0);
        $id = $qr->id;
        $otp_code = $qr->otp;
        $attempts = $qr->attempts;
        if($otp != '' && $attempts < 10 && hash_equals(strval($otp_code), strval($otp))){
            mysqli_query($db,"delete from otp_temp where email='$phone'");
            $qr0 = mysqli_query($db,"select id,email,pwd,login_token from users where phone='$phone' and status='active'");
            $row = mysqli_num_rows($qr0);
            $qr = mysqli_fetch_object($qr0);
            if($row == 1){
                $payload = [
                    'exp' => time() + (3600*24*30), // session for 1 month
                    'data' => [
                        'user_type' => 'user',
                        'id' => intval($qr->id),
                        'user' => $qr->email,
                        'token' => $qr->login_token,
                    ],
                ];
                $jwt = JWT::encode($payload, $secret_key, 'HS256');
                $res = array(
                    "status" => 1,
                    "token" => $jwt,
                    'data' => $payload['data'],
                );
            }else{
                $res = array("status" => 0);
            }
            echo json_encode($res);exit();
        }else{
            $attempts = $attempts+1;
            mysqli_query($db,"update otp_temp set attempts='$attempts' where id='$id'");
            echo json_encode(array("status" => 2));exit();
        }
    }else{
        echo json_encode(array("status" => 0));exit();
    }
}

function checkLogin(){
    global $db;
    $auth = jwt_checker();
    $valid = $auth['valid'];
    if($valid == 0){echo json_encode(array("status" => 0));exit();}
    echo json_encode(array("status" => 1,"data" => $auth['data']));exit();
}

function force_logout(){
    global $db;
    $auth = jwt_checker();
    $valid = $auth['valid'];
    if($valid == 1){
        $user_type = $auth['data']->user_type;
        $id = $auth['data']->id;
        $token = generateRandomString();
        if($user_type == "admin"){
            mysqli_query($db,"update admin set token='$token' where id='$id'");
        }elseif($user_type == "user"){
            mysqli_query($db,"update users set login_token='$token' where id='$id'");
        }
        echo json_encode(array("status" => 1));exit();
    }else{
        echo json_encode(array("status" => 0));exit();
    }
}

function jwt_checker(){
    global $secret_key,$db;
    $headers = getallheaders();
    isset($headers["authorization"]) ? $jwt = $headers["authorization"] : $jwt = '';
    isset($headers["lang"]) ? $lang = mysqli_real_escape_string($db,$headers["lang"]) : $lang = 'ar';
    isset($headers["device"]) ? $device = mysqli_real_escape_string($db,$headers["device"]) : $device = 'android';
    if($jwt == ''){
        isset($headers["Authorization"]) ? $jwt = $headers["Authorization"] : $jwt = '';
    }
    try{
        $status = JWT::decode($jwt, new Key($secret_key, 'HS256'));
        if(isset($status->data->token) && isset($status->data->user_type) && isset($status->data->user) && isset($status->data->id)){
            $user_type = $status->data->user_type;
            $id = intval($status->data->id);
            $user = $status->data->user;
            $token = mysqli_real_escape_string($db,strval($status->data->token));
            $qr = false;
            if($user_type == "admin"){
                $qr = mysqli_query($db,"select id from admin where id='$id' and token='$token' and valid='1'");
            }elseif($user_type == "user"){
                $qr = mysqli_query($db,"select id from users where id='$id' and login_token='$token' and status='active'");
            }
            if ($qr && mysqli_num_rows($qr) != 0){
                $res = array("valid" => 1,"data" => $status->data,"lang" => $lang,"device" => $device);
            }else{
                $res = array("valid" => 0,"lang" => $lang,"device" => $device);
            }
        }else{
            $res = array("valid" => 0,"lang" => $lang,"device" => $device);
        }
    }catch (Exception $e){
        $res = array("valid" => 0,"lang" => $lang,"device" => $device);
    }
    return $res;
}

function user_register($name,$email,$pwd,$phone,$city,$state,$otp,$type='email'){
    global $db;
    $email = strtolower(trim($email));
    $phone = str_replace('+','',$phone);
    $otp = trim($otp);
    if($type == 'phone'){$activation = $phone;}else{$activation = $email;}
    $email_row = mysqli_num_rows(mysqli_query($db,"select email from users where email='$email'"));
    $phone_row = mysqli_num_rows(mysqli_query($db,"select phone from users where phone='$phone'"));
    $valid_otp = mysqli_num_rows(mysqli_query($db,"select id from otp_temp where email='$activation' and otp='$otp' and attempts < '10' and create_at > NOW() - INTERVAL 60 MINUTE"));
    //if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {echo json_encode(array("status" => 2));exit();} // Email Not Valid
    if($email_row != 0 && $email != ''){echo json_encode(array("status" => 3));exit();} // Email Exist
    if($phone_row != 0 && $phone != ''){echo json_encode(array("status" => 7));exit();} // Phone Exist
    //if(strlen($pwd) < 8){echo json_encode(array("status" => 4));exit();} // Password less then 8 characters
    if($valid_otp == 0){
        mysqli_query($db,"update otp_temp set attempts=attempts+1 where email='$activation'");
        echo json_encode(array("status" => 6));exit(); // otp not match
    }else{mysqli_query($db,"delete from otp_temp where email='$activation'");}
    $login_token = generateRandomString();
    $pwd = $pwd != '' ? hash_pwd($pwd) : '';
    mysqli_query($db,"insert into users (name,email,pwd,phone,city,state,login_token) values ('$name','$email','$pwd','$phone','$city','$state','$login_token')");


    $uid = mysqli_insert_id($db);
    mysqli_query($db,"insert into agencies (id,owner_id,name,email,phone,description,address,city,state,img) values ('$uid','$uid','$name','$email','$phone','','','$city','$state','')");
    //telegram_sender("تم تسجيل مكتب جديد بإسم : ".$name);


    echo json_encode(array("status" => 1));exit();
}

function reset_password($email,$pwd,$otp){
    global $db;
    $email = strtolower(trim($email));
    $otp = trim($otp);
    $valid_otp = mysqli_num_rows(mysqli_query($db,"select id from otp_temp where email='$email' and otp='$otp' and attempts < '10' and create_at > NOW() - INTERVAL 60 MINUTE"));
    if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {echo json_encode(array("status" => 2));exit();} // Email Not Valid
    if(strlen($pwd) < 8){echo json_encode(array("status" => 4));exit();} // Password less then 8 characters
    if($valid_otp == 0){
        mysqli_query($db,"update otp_temp set attempts=attempts+1 where email='$email'");
        echo json_encode(array("status" => 6));exit(); // otp not match
    }else{mysqli_query($db,"delete from otp_temp where email='$email'");}
    $login_token = generateRandomString();
    $pwd = hash_pwd($pwd);
    mysqli_query($db,"update users set pwd='$pwd',login_token='$login_token' where email='$email'");
    echo json_encode(array("status" => 1));exit();
}

function send_email_otp($email,$type){
    global $db;
    if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {echo json_encode(array("status" => 2));exit();} // Email Not Valid
    $email_found = mysqli_num_rows(mysqli_query($db,"select id from users where email='$email'"));

    if($type == 'reset'){
        if($email_found == 0){echo json_encode(array("status" => 5));exit();} // email not found
    }else{
        if($email_found != 0){echo json_encode(array("status" => 5));exit();} // email found
    }

    $valid_otp = mysqli_num_rows(mysqli_query($db,"select id from otp_temp where email='$email' and create_at > NOW() - INTERVAL 59 SECOND"));
    if($valid_otp != 0){echo json_encode(array("status" => 3));exit();} // OTP Still Valid
    $otp = random_int(100000,999999);

    $subject = 'Your One-Time Password (OTP)';
    $body = '<!DOCTYPE html>
<html lang="en" dir="ltr">
<head>
  <meta charset="UTF-8">
  <style>
    body { font-family: Tahoma, sans-serif; background-color: #f9f9f9; color: #333; }
    .container { max-width: 600px; margin: auto; background-color: #fff; padding: 30px; border: 1px solid #ddd; border-radius: 5px; }
    .header { font-size: 24px; font-weight: bold; color: #000; }
    .otp-code { font-size: 36px; font-weight: bold; color: #0056b3; margin: 20px 0; letter-spacing: 2px; }
    .footer { font-size: 12px; color: #777; margin-top: 20px; }
  </style>
</head>
<body style="font-family: Tahoma, sans-serif; background: #f9f9f9; padding: 20px; color: #333; direction: ltr;">
  <div class="container">
    <p class="header">Your Verification Code</p>
    <p>Please use the following one-time password (OTP) to complete your action.</p>
    <p class="otp-code">' . $otp . '</p>
    <p class="footer">If you did not request this, you can safely ignore this email.<br>Thank you</p>
  </div>
</body>
</html>';
    $res = mailer($email,$subject,$body);
    if($res != 1){echo json_encode(array("status" => 4));exit();} // Mailer problem

    mysqli_query($db,"delete from otp_temp where email='$email'");
    mysqli_query($db,"insert into otp_temp (email,otp) values ('$email','$otp')");
    echo json_encode(array("status" => 1));exit();
}

function send_phone_otp($phone,$type){
    global $db;
    $phone = str_replace('+','',$phone);
    $phone_found = mysqli_num_rows(mysqli_query($db,"select id from users where phone='$phone'"));

    if($type == 'reset'){
        if($phone_found == 0){echo json_encode(array("status" => 5));exit();} // phone not found
    }else{
        if($phone_found != 0){echo json_encode(array("status" => 5));exit();} // phone found
    }

    $valid_otp = mysqli_num_rows(mysqli_query($db,"select id from otp_temp where email='$phone' and create_at > NOW() - INTERVAL 59 SECOND"));
    if($valid_otp != 0){echo json_encode(array("status" => 3));exit();} // OTP Still Valid
    $otp = random_int(100000,999999);

    $tests = array('962777777777','962777777888','962777777999');
    if(in_array($phone,$tests)){
        $code = "223344";
        //sendSmsToEmulator($sms_api_sender,"رمز الدخول الخاص بك هو : $otp");
    }else{
        $phone_first = substr($phone, 0, 3);
        //whatsapp_api($phone,"الدلال، رمز الدخول الخاص بك هو : $otp");
        if(in_array($phone_first,['963','962'])){
            sms_api_key($phone,$otp);
        }else{
            sms_api_twilio($phone,"الدلال، رمز الدخول الخاص بك هو : $otp");
        }
    }

    mysqli_query($db,"delete from otp_temp where email='$phone'");
    mysqli_query($db,"insert into otp_temp (email,otp) values ('$phone','$otp')");
    echo json_encode(array("status" => 1));exit();
}


function app_check(){
    global $db;
    $auth = jwt_checker();
    $settings = mysqli_fetch_object(mysqli_query($db,"select mini_version_apk,mini_version_ios,maintenance_mode from settings where id='1'"));
    echo json_encode(array(
        "status" => 1,
        "data" => array(
            "is_login" => intval($auth['valid']),
            "mini_version_apk" => $settings->mini_version_apk,
            "mini_version_ios" => $settings->mini_version_ios,
            "maintenance" => intval($settings->maintenance_mode),
        ),
    ));exit();
}
function get_settings(){
    global $db;
    $qr2 = mysqli_fetch_object(mysqli_query($db,"select * from settings where id='1'"));
    $app = array(
        "site_name" => $qr2->site_name,
        "site_description" => $qr2->site_description,
        "site_email" => $qr2->site_email,
        "site_phone" => $qr2->site_phone,
        "sociel_fb" => $qr2->sociel_fb,
        "sociel_insta" => $qr2->sociel_insta,
        "sociel_whats" => $qr2->sociel_whats,
        "sociel_youtube" => $qr2->sociel_youtube,
        "sociel_tiktok" => $qr2->sociel_tiktok,
        "sociel_x" => $qr2->sociel_x,
        "exchange" => $qr2->usd_value,
        //"map_url" => "https://a.tile.openstreetmap.org/{z}/{x}/{y}.png",
        //"map_url" => "https://a.tile.thunderforest.com/cycle/{z}/{x}/{y}.png",
        //"map_url" => "https://{s}.basemaps.cartocdn.com/ar/rastertiles/voyager/{z}/{x}/{y}{r}.png",
        "map_url" => "https://tiles.stadiamaps.com/tiles/outdoors/{z}/{x}/{y}{r}.png?api_key=6b44afac-cbec-445f-9f6c-88e4b8a26713",
    );

    $res = array(
        "status" => 1,
        "app" => $app,
    );
    echo json_encode($res);exit();
}