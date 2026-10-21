<?php
if(!isset($fp)){echo json_encode(array("status" => 0));exit();}
// run
isset($rawdata["site_name"]) && $rawdata["site_name"] != '' ? $site_name = mysqli_real_escape_string($db, $rawdata["site_name"]) : $site_name = '';
isset($rawdata["site_description"]) && $rawdata["site_description"] != '' ? $site_description = mysqli_real_escape_string($db, $rawdata["site_description"]) : $site_description = '';
isset($rawdata["site_email"]) && $rawdata["site_email"] != '' ? $site_email = mysqli_real_escape_string($db, $rawdata["site_email"]) : $site_email = '';
isset($rawdata["site_phone"]) && $rawdata["site_phone"] != '' ? $site_phone = mysqli_real_escape_string($db, $rawdata["site_phone"]) : $site_phone = '';
isset($rawdata["mini_version_apk"]) && $rawdata["mini_version_apk"] != '' ? $mini_version_apk = mysqli_real_escape_string($db, $rawdata["mini_version_apk"]) : $mini_version_apk = '';
isset($rawdata["mini_version_ios"]) && $rawdata["mini_version_ios"] != '' ? $mini_version_ios = mysqli_real_escape_string($db, $rawdata["mini_version_ios"]) : $mini_version_ios = '';
isset($rawdata["maintenance"]) && $rawdata["maintenance"] != '' ? $maintenance = mysqli_real_escape_string($db,$rawdata["maintenance"]) : $maintenance = 0;

isset($rawdata["sociel_fb"]) && $rawdata["sociel_fb"] != '' ? $sociel_fb = mysqli_real_escape_string($db, $rawdata["sociel_fb"]) : $sociel_fb = '';
isset($rawdata["sociel_insta"]) && $rawdata["sociel_insta"] != '' ? $sociel_insta = mysqli_real_escape_string($db, $rawdata["sociel_insta"]) : $sociel_insta = '';
isset($rawdata["sociel_whats"]) && $rawdata["sociel_whats"] != '' ? $sociel_whats = mysqli_real_escape_string($db, $rawdata["sociel_whats"]) : $sociel_whats = '';
isset($rawdata["sociel_youtube"]) && $rawdata["sociel_youtube"] != '' ? $sociel_youtube = mysqli_real_escape_string($db, $rawdata["sociel_youtube"]) : $sociel_youtube = '';
isset($rawdata["sociel_tiktok"]) && $rawdata["sociel_tiktok"] != '' ? $sociel_tiktok = mysqli_real_escape_string($db, $rawdata["sociel_tiktok"]) : $sociel_tiktok = '';
isset($rawdata["sociel_x"]) && $rawdata["sociel_x"] != '' ? $sociel_x = mysqli_real_escape_string($db, $rawdata["sociel_x"]) : $sociel_x = '';
isset($rawdata["usd_value"]) && $rawdata["usd_value"] != '' ? $usd_value = mysqli_real_escape_string($db, $rawdata["usd_value"]) : $usd_value = '0.00';
isset($rawdata["auto_publish"]) && $rawdata["auto_publish"] != '' ? $auto_publish = mysqli_real_escape_string($db, $rawdata["auto_publish"]) : $auto_publish = 'manual';



if (!isset($p[2]) || $p[2] == '') {
    echo json_encode(array("status" => 0));exit();
}elseif($p[2] == 'get_info'){
    get_info();
}elseif($p[2] == 'save_info'){
    save_info($site_name,$site_description,$site_email,$site_phone,$mini_version_apk,$mini_version_ios,$maintenance,$sociel_fb,$sociel_insta,$sociel_whats,$sociel_youtube,$sociel_tiktok,$sociel_x,$usd_value,$auto_publish);
}elseif($p[2] == 'statistics'){
    statistics();
}else{
    echo json_encode(array("status" => 0));exit();
}



// functions
function get_info(){
    global $db;
    $qr1 = mysqli_query($db,"select * from settings where id=1");
    $qr = mysqli_fetch_object($qr1);
    $data = array(
        "site_name" => $qr->site_name,
        "site_description" => $qr->site_description,
        "site_email" => $qr->site_email,
        "site_phone" => $qr->site_phone,
        "mini_version_apk" => $qr->mini_version_apk,
        "mini_version_ios" => $qr->mini_version_ios,
        "maintenance" => intval($qr->maintenance_mode),
        "sociel_fb" => $qr->sociel_fb,
        "sociel_insta" => $qr->sociel_insta,
        "sociel_whats" => $qr->sociel_whats,
        "sociel_youtube" => $qr->sociel_youtube,
        "sociel_tiktok" => $qr->sociel_tiktok,
        "sociel_x" => $qr->sociel_x,
        "usd_value" => $qr->usd_value,
        "auto_publish" => $qr->auto_publish,
    );
    $res = array(
        "status" => 1,
        "data" => $data
    );
    echo json_encode($res);exit();
}

function save_info($site_name,$site_description,$site_email,$site_phone,$mini_version_apk,$mini_version_ios,$maintenance,$sociel_fb,$sociel_insta,$sociel_whats,$sociel_youtube,$sociel_tiktok,$sociel_x,$usd_value,$auto_publish){
    global $db;
    mysqli_query($db,"update settings set site_name='$site_name',site_description='$site_description',site_email='$site_email',site_phone ='$site_phone',mini_version_apk='$mini_version_apk',mini_version_ios='$mini_version_ios',maintenance_mode ='$maintenance',sociel_fb='$sociel_fb',sociel_insta='$sociel_insta',sociel_whats='$sociel_whats',sociel_youtube='$sociel_youtube',sociel_tiktok='$sociel_tiktok',sociel_x='$sociel_x',usd_value='$usd_value',auto_publish='$auto_publish' where id=1");
    $res = array("status" => 1);
    echo json_encode($res);exit();
}

function statistics(){
    global $db;

    $ads_sale = mysqli_num_rows(mysqli_query($db,"select id from properties where admin_review='approved' and purpose='sale'"));
    $ads_rent = mysqli_num_rows(mysqli_query($db,"select id from properties where admin_review='approved' and purpose='rent'"));
    $ads_pending = mysqli_num_rows(mysqli_query($db,"select id from properties where admin_review='pending'"));
    $ads_approved = mysqli_num_rows(mysqli_query($db,"select id from properties where admin_review='approved'"));
    $ads_rejected = mysqli_num_rows(mysqli_query($db,"select id from properties where admin_review='rejected'"));
    $agencys_pending = mysqli_num_rows(mysqli_query($db,"select id from agencies where status='pending'"));
    $agencys_approved = mysqli_num_rows(mysqli_query($db,"select id from agencies where status='approved'"));
    $agencys_rejected = mysqli_num_rows(mysqli_query($db,"select id from agencies where status='rejected'"));
    $users = mysqli_num_rows(mysqli_query($db,"select id from users where role='user'"));

    $data = array(
        "ads_sale" => intval($ads_sale),
        "ads_rent" => intval($ads_rent),
        "ads_pending" => intval($ads_pending),
        "ads_approved" => intval($ads_approved),
        "ads_rejected" => intval($ads_rejected),
        "agencys_pending" => intval($agencys_pending),
        "agencys_approved" => intval($agencys_approved),
        "agencys_rejected" => intval($agencys_rejected),
        "users" => intval($users),
    );
    $res = array(
        "status" => 1,
        "data" => $data
    );
    echo json_encode($res);exit();
}