<?php
if(!isset($fp)){echo json_encode(array("status" => 0));exit();}
use \Firebase\JWT\JWT;
##################### HELP FUNCTIONS #########################
function generateRandomString($length = 10) {
    $characters = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    $randomString = '';
    $max = strlen($characters) - 1;
    for ($i = 0; $i < $length; $i++) {
        $randomString .= $characters[rand(0, $max)];
    }
    return $randomString;
}
#### FETCH STATES AND CITYS
function get_states($country='SY'){
    global $db;
    $data = [];
    $qr1 = mysqli_query($db,"select * from citys where country='$country' group by state_ar order by state_ar asc");
    while($qr = mysqli_fetch_object($qr1)){
        $data[] = array(
            "id" => intval($qr->id),
            "name_ar" => $qr->state_ar,
            "name_en" => $qr->state_en,
        );
    }
    $res = array(
        "status" => 1,
        "data" => $data
    );
    echo json_encode($res);exit();
}
function get_citys($state,$country='SY'){
    global $db;
    $data = [];
    $qr1 = mysqli_query($db,"select * from citys where country='$country' and state_ar='$state' or state_en='$state' order by city_ar asc");
    while($qr = mysqli_fetch_object($qr1)){
        $data[] = array(
            "id" => intval($qr->id),
            "name_ar" => $qr->city_ar,
            "name_en" => $qr->city_en,
        );
    }
    $res = array(
        "status" => 1,
        "data" => $data
    );
    echo json_encode($res);exit();
}
############### NOTIFICATION FUNCTIONS #######################
function sendNotification($user_id,$title,$body,$title_en,$body_en,$route,$route_id){
    global $db;
    $lang = mysqli_fetch_object(mysqli_query($db,"SELECT lang FROM users WHERE id = '$user_id'"))?->lang;
    if($lang == 'en'){$is_fcm_send = sendNotificationApi(strval($user_id),$title_en,$body_en,$route,strval($route_id));}
    else{$is_fcm_send = sendNotificationApi(strval($user_id),$title,$body,$route,strval($route_id));}
    return $is_fcm_send;
}
function sendNotificationApi($user_id,$title,$body,$route,$route_id){
    global $db,$auth;
    $device = $auth['device'];
    $fcm_token = mysqli_fetch_object(mysqli_query($db,"select fcm from users where id='$user_id'"))?->fcm;
    if($fcm_token == ''){return 0;}

    $firebase_server_key = generateFirebaseToken();
    $message = [
        "message" => [
            "token" => $fcm_token,
            "data" => [
                "title" => $title,
                "body" => $body,
                "route" => $route,
                "route_id" => strval($route_id),
                "notifications" => strval(0),
            ],
            "android" => [
                "priority" => "high",
                "direct_boot_ok" => true,
            ],
            "apns" => [
                "headers" => [
                    "apns-priority" => "10",
                ],
                "payload" => [
                    "aps" => [
                        "content-available" => 1,
                    ],
                ],
            ],
        ],
    ];
    if($device == 'ios'){$message['message']['notification'] = ["title" => $title, "body" => $body];}
    $url = 'https://fcm.googleapis.com/v1/projects/aldlaal/messages:send';
    $jsonMessage = json_encode($message);
    $headers = ['Authorization: Bearer '.$firebase_server_key, 'Content-Type: application/json',];
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_POSTFIELDS, $jsonMessage);
    $response = curl_exec($ch);
    if (str_contains($response,'"error":')) {return 0;}
    curl_close($ch);
    return 1;
}
function generateFirebaseToken() {
    global $firebaseAuthFile;
    $serviceAccount = json_decode($firebaseAuthFile, true);
    $headers = ['alg' => 'RS256', 'typ' => 'JWT'];
    $issuedAt = time();
    $expiration = $issuedAt+(3600);
    $payload = [
        'iss' => $serviceAccount['client_email'],
        'scope' => 'https://www.googleapis.com/auth/firebase.messaging',
        'aud' => 'https://oauth2.googleapis.com/token',
        'iat' => $issuedAt, 'exp' => $expiration
    ];
    $jwt = JWT::encode($payload, $serviceAccount['private_key'], 'RS256');

    $url = 'https://oauth2.googleapis.com/token';
    $postFields = ['grant_type' => 'urn:ietf:params:oauth:grant-type:jwt-bearer', 'assertion' => $jwt];
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query($postFields));
    curl_setopt($ch, CURLOPT_HTTPHEADER, ['Content-Type: application/x-www-form-urlencoded']);
    $response = curl_exec($ch);
    curl_close($ch);
    $jsonResponse = json_decode($response, true);
    if (isset($jsonResponse['access_token'])) {
        return $jsonResponse['access_token'];
    } else {return "";}
}
##############################################################