<?php
if(!isset($fp)){echo json_encode(array("status" => 0));exit();}
// run
isset($rawdata["name"]) && $rawdata["name"] != '' ? $name = mysqli_real_escape_string($db, $rawdata["name"]) : $name = '';
isset($rawdata["email"]) && $rawdata["email"] != '' ? $email = mysqli_real_escape_string($db, $rawdata["email"]) : $email = '';
isset($rawdata["phone"]) && $rawdata["phone"] != '' ? $phone = mysqli_real_escape_string($db, $rawdata["phone"]) : $phone = '';
isset($rawdata["state"]) && $rawdata["state"] != '' ? $state = mysqli_real_escape_string($db, $rawdata["state"]) : $state = '';
isset($rawdata["city"]) && $rawdata["city"] != '' ? $city = mysqli_real_escape_string($db, $rawdata["city"]) : $city = '';
isset($rawdata["img"]) && $rawdata["img"] != '' ? $img = mysqli_real_escape_string($db, $rawdata["img"]) : $img = '';
isset($rawdata["fcm"]) && $rawdata["fcm"] != '' ? $fcm = mysqli_real_escape_string($db, $rawdata["fcm"]) : $fcm = '';

if (!isset($p[2]) || $p[2] == '') {
    echo json_encode(array("status" => 0));exit();
}elseif($p[2] == 'get_user'){
    get_user();
}elseif($p[2] == 'edit'){
    edit_general($name,$state,$city,$phone);
}elseif($p[2] == 'edit_img'){
    edit_img($img);
}elseif($p[2] == 'remove'){
    remove();
}elseif($p[2] == 'update_fcm'){
    update_fcm($fcm);
}elseif($p[2] == 'update_lang'){
    update_lang();
}else{
    echo json_encode(array("status" => 0));exit();
}


// functions

// get user
function get_user(){
    global $db,$auth;
    $id = $auth['data']->id;
    $qr = mysqli_fetch_object(mysqli_query($db,"select * from users where id='$id'"));
    $user = array(
        "id" => intval($qr->id),
        "name" => $qr->name,
        "phone" => $qr->phone,
        "email" => $qr->email,
        "img" => $qr->img,
        "state" => $qr->state,
        "city" => $qr->city,
    );
    $res = array(
        "status" => 1,
        "user" => $user,
    );
    echo json_encode($res);exit();
}
// edit
function edit_general($name,$state,$city,$phone){
    global $db,$auth;
    $id = $auth['data']->id;
    mysqli_query($db,"update users set name='$name',state='$state',city='$city',phone='$phone' where id='$id'");
    $res = array("status" => 1);
    echo json_encode($res);exit();
}

// edit img
function edit_img($img){
    global $db,$auth;
    $id = $auth['data']->id;
    mysqli_query($db,"update users set img='$img' where id='$id'");
    $res = array("status" => 1);
    echo json_encode($res);exit();
}

// remove
function remove(){
    global $db,$auth;
    $id = $auth['data']->id;
    mysqli_query($db,"delete from users where id='$id'");
    mysqli_query($db,"delete from favorites where user_id='$id'");
    mysqli_query($db,"delete from search_favorites where user_id='$id'");
    mysqli_query($db,"delete from search_recent where user_id='$id'");
    $res = array("status" => 1);
    echo json_encode($res);exit();
}

function update_fcm($fcm){
    global $db,$auth;
    $id = $auth['data']->id;
    mysqli_query($db,"update users set fcm='$fcm' where id='$id'");
    echo json_encode(array('status' => 1));exit();
}
function update_lang(){
    global $db,$auth;
    $id = $auth['data']->id;
    $lang = $auth['lang'];
    mysqli_query($db,"update users set lang='$lang' where id='$id'");
    $res = array("status" => 1);
    echo json_encode($res);exit();
}