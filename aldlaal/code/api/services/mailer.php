<?php
if(!isset($fp)){echo json_encode(array("status" => 0));exit();}
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\SMTP;
use PHPMailer\PHPMailer\Exception;

function mailer($emailTo,$subject,$body){
    global $smtp_host,$smtp_user,$smtp_pass;
    $from = $smtp_user;
    $mail = new PHPMailer;
    $mail->isSMTP();
    $mail->SMTPDebug = 0;
    $mail->CharSet = 'UTF-8';
    $mail->Host = $smtp_host;
    $mail->Port = 587;
    $mail->SMTPSecure = 'tls';
    $mail->SMTPAuth = true;
    $mail->Username = $from;
    $mail->Password = $smtp_pass;
    $mail->setFrom($from, "noreply");
    $mail->addAddress($emailTo);
    $mail->Subject = $subject;
    $mail->msgHTML($body);
    if(!$mail->send()){
        return 0;
    }else{
        return 1;
    }
}

function telegram_sender($msg){
    global $telegram_users,$telegram_key;
    foreach($telegram_users as $user){
        file_get_contents("https://api.telegram.org/bot".$telegram_key."/sendMessage?chat_id=".$user."&text=".urlencode($msg));
    }
}

function sms_api($num,$msg){
    global $sms_api_user,$sms_api_pwd,$sms_api_sender;
    $num = urlencode(strval($num));
    $sender = urlencode($sms_api_sender);
    $msg = urlencode($msg);
    $curl = curl_init();
    curl_setopt_array($curl, array(
        CURLOPT_URL => 'https://www.smsapril.com/api.php?comm=sendsms&user='.$sms_api_user.'&pass='.$sms_api_pwd.'&to='.$num.'&message='.$msg.'&sender='.$sender,
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_ENCODING => '',
        CURLOPT_MAXREDIRS => 10,
        CURLOPT_TIMEOUT => 10,
        CURLOPT_FOLLOWLOCATION => false,
        CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
        CURLOPT_CUSTOMREQUEST => 'GET',
    ));
    $response = curl_exec($curl);
    curl_close($curl);

    if($response == 1 || $response == 'u'){
        return 1;
    }else{
        return preg_replace('/[^0-9]/', '', $response);
    }
}

function sms_api_key($num,$msg){
    global $sms_api_key,$sms_api_sender;
    $num = urlencode(strval($num));
    $sender = urlencode($sms_api_sender);
    $msg = urlencode($msg);

    $curl = curl_init();
    curl_setopt_array($curl, array(
        CURLOPT_URL => 'https://www.smsapril.com/api/send-sms',
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_ENCODING => '',
        CURLOPT_MAXREDIRS => 10,
        CURLOPT_TIMEOUT => 5,
        CURLOPT_FOLLOWLOCATION => true,
        CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
        CURLOPT_CUSTOMREQUEST => 'POST',
        CURLOPT_POSTFIELDS =>'{"to": "'.$num.'","message": "'.$msg.'","sender": "'.$sender.'"}',
        CURLOPT_HTTPHEADER => array('X-API-Key: '.$sms_api_key, 'Content-Type: application/json'),
    ));
    $response = curl_exec($curl);
    curl_close($curl);

    return 1;
    if($response == 1 || $response == 'u'){
        return 1;
    }else{
        return preg_replace('/[^0-9]/', '', $response);
    }
}

function sms_api_twilio($to, $msg){
    global $twilio_sid,$twilio_token,$twilio_from;
    $sid    = $twilio_sid;
    $token  = $twilio_token;
    $from   = $twilio_from;
    $url    = "https://api.twilio.com/2010-04-01/Accounts/$sid/Messages.json";
    $data = [
        'From' => $from,
        'To'   => $to,
        'Body' => $msg,
    ];
    $postData = http_build_query($data);
    $ch = curl_init($url);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, true);
    curl_setopt($ch, CURLOPT_USERPWD, "$sid:$token");
    curl_setopt($ch, CURLOPT_POSTFIELDS, $postData);
    $response = curl_exec($ch);
    $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    curl_close($ch);
    return ($httpCode === 201) ? 1 : 0;
}

function whatsapp_api($num,$msg){
    global $whatsapp_instance_id,$whatsapp_access_token;
    $num = intval($num);
    $curl = curl_init();
    curl_setopt_array($curl, array(
        CURLOPT_URL => 'https://app.botb.ee/api/send',
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_ENCODING => '',
        CURLOPT_MAXREDIRS => 10,
        CURLOPT_TIMEOUT => 10,
        CURLOPT_FOLLOWLOCATION => true,
        CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
        CURLOPT_CUSTOMREQUEST => 'POST',
        CURLOPT_POSTFIELDS =>'{
            "number": '.$num.',
            "type": "text",
            "message": "'.$msg.'",
            "instance_id": "'.$whatsapp_instance_id.'",
            "access_token": "'.$whatsapp_access_token.'"
        }',
        CURLOPT_HTTPHEADER => array('Content-Type: application/json'),
    ));
    $response = curl_exec($curl);
    curl_close($curl);

    return 1;

    /*if((isset($response['status']) && $response['status'] == 'success') || $response == '' || $response == '[]' || count($response) == 0){
        return 1;
    }else{
        return 0;
    }*/
}