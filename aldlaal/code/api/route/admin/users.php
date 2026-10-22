<?php
if(!isset($fp)){echo json_encode(array("status" => 0));exit();}
// run
$perPage = int_param($rawdata["per_page"] ?? 0, 0, 500);
$page = (max(1, int_param($rawdata["page"] ?? 1, 1)) - 1) * $perPage;
$id = isset($rawdata["id"]) ? mysqli_real_escape_string($db,$rawdata["id"]) : 0;
$name = isset($rawdata["name"]) ? mysqli_real_escape_string($db,$rawdata["name"]) : '';
$email = isset($rawdata["email"]) ? mysqli_real_escape_string($db,$rawdata["email"]) : '';
$phone = isset($rawdata["phone"]) ? mysqli_real_escape_string($db,$rawdata["phone"]) : '';
$city = isset($rawdata["city"]) ? mysqli_real_escape_string($db,$rawdata["city"]) : '';
$state = isset($rawdata["state"]) ? mysqli_real_escape_string($db,$rawdata["state"]) : '';
$status = isset($rawdata["status"]) ? mysqli_real_escape_string($db,$rawdata["status"]) : 'active';
$type = isset($rawdata["type"]) ? mysqli_real_escape_string($db,$rawdata["type"]) : '';


if (!isset($p[2]) || $p[2] == '') {
    echo json_encode(array("status" => 0));exit();
}elseif($p[2] == 'get_one'){
    get_one($id);
}elseif($p[2] == 'get_page'){
    get_page($page,$perPage,$email);
}elseif($p[2] == 'edit'){
    edit($id,$name,$email,$phone,$city,$state,$status);
}elseif($p[2] == 'remove'){
    remove($id);
}elseif($p[2] == 'set_doc_status'){
    set_doc_status($type,$id);
}elseif($p[2] == 'verify_list'){
    verify_list($page,$perPage);
}else{
    echo json_encode(array("status" => 0));exit();
}



// functions

// get one
function get_one($id){
    global $db;
    $qr1 = mysqli_query($db,"select * from users where id='$id'");
    if(mysqli_num_rows($qr1) != 0){
        $qr = mysqli_fetch_object($qr1);
        $docs = get_docs($qr->id);
        $data = array(
            "id" => intval($qr->id),
            "name" => $qr->name,
            "email" => $qr->email,
            "phone" => $qr->phone,
            "city" => $qr->city,
            "state" => $qr->state,
            "verify" => $qr->verify,
            "docs" => $docs,
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
// get by page
function get_page($page,$perPage,$email){
    global $db;
    $data = array();

    $q_email = $email != '' ? "email like '$email%' and " : "";
    if($q_email == ""){$str = "";}
    else{
        $str = "where ".$q_email;
        $str = substr($str, 0, -5);
    }
    $qr1 = mysqli_query($db,"select * from users $str");
    $qr2 = mysqli_query($db,"select * from users $str order by id desc limit $page,$perPage");
    $rows = mysqli_num_rows($qr1);
    while ($qr = mysqli_fetch_object($qr2)){
        $docs = get_docs($qr->id);
        $data[] = array(
            "id" => intval($qr->id),
            "name" => $qr->name,
            "email" => $qr->email,
            "phone" => $qr->phone,
            "city" => $qr->city,
            "state" => $qr->state,
            "verify" => $qr->verify,
            "docs" => $docs,
            "create_at" => explode(' ',$qr->create_at)[0],
            "status" => $qr->status
        );
    }
    $res = array(
        "status" => 1,
        "data" => array(
            "total" => $rows,
            "items" => $data
        )
    );
    echo json_encode($res);exit();
}
// edit
function edit($id,$name,$email,$phone,$city,$state,$status){
    global $db;
    if(filter_var($email, FILTER_VALIDATE_EMAIL)){
        $row = mysqli_num_rows(mysqli_query($db,"select id from users where id != '$id' and email='$email'"));
        if($row == 0){
            mysqli_query($db,"update users set name='$name',email='$email',phone='$phone',city='$city',state='$state',status='$status' where id='$id'");
            $res = array("status" => 1); // success
        }else{
            $res = array("status" => 2); // email exist
        }
    }else{
        $res = array("status" => 3); // email incorrect
    }
    echo json_encode($res);exit();
}
// remove
function remove($id){
    global $db;
    $aid = mysqli_fetch_object(mysqli_query($db,"select id from agencies where owner_id='$id'"))->id;
    mysqli_query($db,"delete from agencies where id='$aid'");
    mysqli_query($db,"delete from properties where agency_id='$aid'");
    mysqli_query($db,"delete from users where id='$id'");
    $res = array("status" => 1);
    echo json_encode($res);exit();
}


function set_doc_status($type,$id){
    global $db;
    if($type == 0){
        mysqli_query($db,"update users set verify='no' where id='$id'");
        $user_id = $id;
        $activated = 'no';
    }elseif($type == 1){
        mysqli_query($db,"update users set verify='yes' where id='$id'");
        sendNotification($id,'تم توثيق حسابك','مبروك تم توثيق حسابك بنجاح','Your account has been verified.','Congratulations, your account has been successfully verified.','/settings/verify','');
        $user_id = $id;
        $activated = 'yes';
    }elseif($type == 2){
        $user_id = mysqli_fetch_object(mysqli_query($db,"select user_id from user_docs where id='$id'"))->user_id;
        mysqli_query($db,"update user_docs set active='1' where id='$id'");
        $activated = '';
    }elseif($type == 3){
        $user_id = mysqli_fetch_object(mysqli_query($db,"select user_id from user_docs where id='$id'"))->user_id;
        mysqli_query($db,"update user_docs set active='0' where id='$id'");
        $activated = '';
    }elseif($type == 4){
        $user_id = mysqli_fetch_object(mysqli_query($db,"select user_id from user_docs where id='$id'"))->user_id;
        mysqli_query($db,"delete from user_docs where id='$id'");
        $activated = '';
    }
    $docs = get_docs($user_id);
    echo json_encode(array(
        "status" => 1,
        "data" => array(
            "activated" => $activated,
            "docs" => $docs,
        )
    ));exit();
}

function verify_list($page,$perPage){
    global $db;
    $data = array();

    $qr1 = mysqli_query($db,"select distinct user_id from user_docs where active='2'");
    $qr2 = mysqli_query($db,"select distinct user_id from user_docs where active='2' order by id desc limit $page,$perPage");
    $rows = mysqli_num_rows($qr1);
    while ($qr0 = mysqli_fetch_object($qr2)){
        $qr = mysqli_fetch_object(mysqli_query($db,"select * from users where id='".$qr0->user_id."'"));
        $docs = get_docs($qr->id);
        $data[] = array(
            "id" => intval($qr->id),
            "name" => $qr->name,
            "email" => $qr->email,
            "phone" => $qr->phone,
            "city" => $qr->city,
            "state" => $qr->state,
            "verify" => $qr->verify,
            "docs" => $docs,
            "create_at" => explode(' ',$qr->create_at)[0],
            "status" => $qr->status
        );
    }
    $res = array(
        "status" => 1,
        "data" => array(
            "total" => $rows,
            "items" => $data
        )
    );
    echo json_encode($res);exit();
}

// HELPS
function get_docs($user_id){
    global $db;
    $data = [];
    $doc_type = array(
        "id" => "بطاقة هوية",
        "passport" => "جواز سفر",
        "driver" => "رخصة سياقة",
        "license" => "ﻣﻠف ﺗرﺧﯾص اﻟﻣﻛﺗب",
        "others" => "وثائق أخرى",
    );
    $qr1 = mysqli_query($db,"select * from user_docs where user_id='$user_id'");
    while ($qr = mysqli_fetch_object($qr1)){
        $data[] = array(
            "id" => intval($qr->id),
            "doc_type" => $doc_type[$qr->doc_type],
            "img" => $qr->img,
            "active" => intval($qr->active),
            "date" => explode(' ',$qr->create_date)[0],
        );
    }
    return $data;
}