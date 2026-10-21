<?php
if(!isset($fp)){echo json_encode(array("status" => 0));exit();}
// run
isset($rawdata["page"]) && $rawdata["page"] != '' ? $page = mysqli_real_escape_string($db, $rawdata["page"]) : $page = 1;
isset($rawdata["id"]) && $rawdata["id"] != '' ? $id = mysqli_real_escape_string($db, $rawdata["id"]) : $id = 0;
isset($rawdata["doc_type"]) && $rawdata["doc_type"] != '' ? $doc_type = mysqli_real_escape_string($db, $rawdata["doc_type"]) : $doc_type = '';
isset($rawdata["img"]) && $rawdata["img"] != '' ? $img = mysqli_real_escape_string($db, $rawdata["img"]) : $img = '';


if (!isset($p[2]) || $p[2] == '') {
    echo json_encode(array("status" => 0));exit();
}elseif($p[2] == 'get_all'){
    get_all($page);
}elseif($p[2] == 'add'){
    add($doc_type,$img);
}elseif($p[2] == 'remove'){
    remove($id);
}else{
    echo json_encode(array("status" => 0));exit();
}


// functions

// get all
function get_all($page){
    global $db,$auth;
    $id = $auth['data']->id;
    $data = [];
    $page = ($page-1)*10;

    $verify = mysqli_fetch_object(mysqli_query($db,"select verify from users where id='$id'"))->verify;
    $doc_type = array(
        "id" => "بطاقة هوية",
        "passport" => "جواز سفر",
        "driver" => "رخصة سياقة",
        "license" => "ﻣﻠف ﺗرﺧﯾص اﻟﻣﻛﺗب",
        "others" => "وثائق أخرى",
    );
    $qr1 = mysqli_query($db,"select * from user_docs where user_id='$id' order by id desc limit $page,10");
    while ($qr = mysqli_fetch_object($qr1)){
        $data[] = array(
            "id" => isset($qr->id) ? intval($qr->id) : 0,
            "doc_type" => $doc_type[$qr->doc_type] ?? '',
            "img" => $qr->img ?? '',
            "active" => isset($qr->active) ? intval($qr->active) : 2,
            "date" => isset($qr->create_date) ? explode(" ",$qr->create_date)[0] : ''
        );
    }

    $res = array(
        "status" => 1,
        "activated" => $verify == "yes" ? 1:0,
        "data" => $data
    );
    echo json_encode($res);exit();
}

function add($doc_type,$img){
    global $db,$auth;
    $id = $auth['data']->id;
    if($doc_type != '' && $img != ''){
        mysqli_query($db,"insert into user_docs (user_id,doc_type,img) values ('$id','$doc_type','$img')");
    }
    echo json_encode(array("status" => 1));exit();
}

function remove($doc_id){
    global $db,$auth;
    $id = $auth['data']->id;
    mysqli_query($db,"delete from user_docs where id='$doc_id' and user_id='$id' and active != '1'");
    echo json_encode(array("status" => 1));exit();
}