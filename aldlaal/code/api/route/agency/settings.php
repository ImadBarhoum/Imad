<?php
if(!isset($fp)){echo json_encode(array("status" => 0));exit();}
// run
$pwd = isset($rawdata["pwd"]) && is_string($rawdata["pwd"]) ? $rawdata["pwd"] : '';
$pwd_new = isset($rawdata["pwd_new"]) && is_string($rawdata["pwd_new"]) ? $rawdata["pwd_new"] : '';
$name = isset($rawdata["name"]) ? mysqli_real_escape_string($db,$rawdata["name"]) : '';
$email = isset($rawdata["email"]) ? mysqli_real_escape_string($db,$rawdata["email"]) : '';
$phone = isset($rawdata["phone"]) ? mysqli_real_escape_string($db,$rawdata["phone"]) : '';
$city = isset($rawdata["city"]) ? mysqli_real_escape_string($db,$rawdata["city"]) : '';
$state = isset($rawdata["state"]) ? mysqli_real_escape_string($db,$rawdata["state"]) : '';
$status = isset($rawdata["status"]) ? mysqli_real_escape_string($db,$rawdata["status"]) : 'active';

if (!isset($p[2]) || $p[2] == '') {
    echo json_encode(array("status" => 0));exit();
}elseif($p[2] == 'get_info'){
    get_info();
}elseif($p[2] == 'edit'){
    edit($name,$email,$phone,$city,$state,$status);
}elseif($p[2] == 'edit_pwd'){
    edit_pwd($pwd,$pwd_new);
}elseif($p[2] == 'statistics'){
    statistics();
}else{
    echo json_encode(array("status" => 0));exit();
}



// functions

// get one
function get_info(){
    global $db,$auth;
    $uid = isset($auth['data']->id) ? $auth['data']->id : 0;
    $qr1 = mysqli_query($db,"select * from users where id='$uid' and role='agency'");
    if(mysqli_num_rows($qr1) != 0){
        $qr = mysqli_fetch_object($qr1);
        $data = array(
            "id" => intval($qr->id),
            "name" => $qr->name,
            "email" => $qr->email,
            "phone" => $qr->phone,
            "city" => $qr->city,
            "state" => $qr->state,
            "create_at" => explode(' ',$qr->create_at)[0],
            "status" => $qr->status
        );
        $res = array(
            "status" => 1,
            "data" => $data
        );
    }else{
        $res = array("status" => 0);
    }
    echo json_encode($res);exit();
}

// edit
function edit($name,$email,$phone,$city,$state,$status){
    global $db,$auth;
    $uid = isset($auth['data']->id) ? $auth['data']->id : 0;
    if(filter_var($email, FILTER_VALIDATE_EMAIL)){
        $row = mysqli_num_rows(mysqli_query($db,"select id from users where id != '$uid' and email='$email' and role='agency'"));
        if($row == 0){
            mysqli_query($db,"update users set name='$name',email='$email',phone='$phone',city='$city',state='$state',status='$status' where id='$uid' and role='agency'");
            $res = array("status" => 1); // success
        }else{
            $res = array("status" => 2); // email exist
        }
    }else{
        $res = array("status" => 3); // email incorrect
    }
    echo json_encode($res);exit();
}

function edit_pwd($pwd,$pwd_new){
    global $db,$auth;
    $uid = isset($auth['data']->id) ? $auth['data']->id : 0;
    $stored = mysqli_fetch_object(mysqli_query($db,"select pwd from users where id='$uid' and role='agency'"))?->pwd;
    if($pwd_new == '' || !check_pwd($pwd,strval($stored))){echo json_encode(array("status" => 0));exit();}
    $pwd_new = hash_pwd($pwd_new);
    mysqli_query($db,"update users set pwd='$pwd_new' where id='$uid' and role='agency'");
    $res = array("status" => 1);
    echo json_encode($res);exit();
}

function statistics(){
    global $db,$auth;
    $uid = isset($auth['data']->id) ? $auth['data']->id : 0;
    $aid = mysqli_fetch_object(mysqli_query($db,"select id from agencies where owner_id='$uid'"))?->id;

    $ads_sale = mysqli_num_rows(mysqli_query($db,"select id from properties where admin_review='approved' and purpose='sale' and agency_id='$aid'"));
    $ads_rent = mysqli_num_rows(mysqli_query($db,"select id from properties where admin_review='approved' and purpose='rent' and agency_id='$aid'"));
    $ads_pending = mysqli_num_rows(mysqli_query($db,"select id from properties where admin_review='pending' and agency_id='$aid'"));
    $ads_rejected = mysqli_num_rows(mysqli_query($db,"select id from properties where admin_review='rejected' and agency_id='$aid'"));

    $data = array(
        "ads_sale" => intval($ads_sale),
        "ads_rent" => intval($ads_rent),
        "ads_pending" => intval($ads_pending),
        "ads_rejected" => intval($ads_rejected),
    );
    $res = array(
        "status" => 1,
        "data" => $data
    );
    echo json_encode($res);exit();
}