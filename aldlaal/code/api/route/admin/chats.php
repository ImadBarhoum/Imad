<?php
if(!isset($fp)){echo json_encode(array("status" => 0));exit();}
// run
$page = max(1, int_param($rawdata["page"] ?? 1, 1));
isset($rawdata["id"]) && $rawdata["id"] != '' ? $id = mysqli_real_escape_string($db, $rawdata["id"]) : $id = 0;
isset($rawdata["owner_id"]) && $rawdata["owner_id"] != '' ? $owner_id = mysqli_real_escape_string($db, $rawdata["owner_id"]) : $owner_id = 0;
isset($rawdata["ads_id"]) && $rawdata["ads_id"] != '' ? $ads_id = mysqli_real_escape_string($db, $rawdata["ads_id"]) : $ads_id = 0;
isset($rawdata["msg"]) && $rawdata["msg"] != '' ? $msg = mysqli_real_escape_string($db, $rawdata["msg"]) : $msg = '';
isset($rawdata["img"]) && $rawdata["img"] != '' ? $img = mysqli_real_escape_string($db, $rawdata["img"]) : $img = '';


if (!isset($p[2]) || $p[2] == '') {
    echo json_encode(array("status" => 0));exit();
}elseif($p[2] == 'get_chats'){
    get_chats($owner_id,$page);
}elseif($p[2] == 'get_chat'){
    get_chat($owner_id,$page,$id,$ads_id);
}elseif($p[2] == 'sync_chat'){
    sync_chat($owner_id,$id,$ads_id);
}else{
    echo json_encode(array("status" => 0));exit();
}


// functions
function get_chats($owner_id,$page){
    global $db;
    $id = $owner_id;
    $data = [];
    $page = ($page-1)*20;

    $qr1 = mysqli_query($db, "SELECT * FROM messages WHERE id IN (SELECT MAX(id) FROM messages WHERE sender_id = '$id' OR receiver_id = '$id' GROUP BY LEAST(sender_id, receiver_id), GREATEST(sender_id, receiver_id), ads_id) ORDER BY id DESC limit $page,10");

    while ($qr = mysqli_fetch_object($qr1)){
        $user_id = $qr->sender_id == $id ? $qr->receiver_id : $qr->sender_id;
        $qr0 = mysqli_query($db,"SELECT title,img FROM properties WHERE id='$qr->ads_id'");
        $check = mysqli_num_rows($qr0);
        if($check > 0){
            $ads = mysqli_fetch_object($qr0);
            $data[] = array(
                "id" => $user_id.'-'.$qr->ads_id,
                "ads_id" => intval($qr->ads_id),
                "user_id" => intval($user_id),
                "ads_title" => isset($ads->title) ? $ads->title : '',
                "ads_img" => isset($ads->img) ? $ads->img : '',
                "msg" => $qr->msg == '' && $qr->img != '' ? 'أرسل إليك صورة...' : ($qr->msg != '' ? $qr->msg : ''),
                "read" => $qr->sender_id != $id ? intval($qr->is_read) : 1,
                "time" => isset($qr->create_at) ? substr(explode(" ",$qr->create_at)[1], 0, -3) : "",
            );
        }

    }

    $res = array(
        "status" => 1,
        "data" => $data
    );
    echo json_encode($res);exit();
}

function get_chat($owner_id,$page,$chat_id,$ads_id){
    global $db;
    $id = $owner_id;
    $data = [];
    $page = ($page-1)*20;

    mysqli_query($db,"update messages set is_read='1' where sender_id='$chat_id' and receiver_id='$id' and is_read='0' and ads_id='$ads_id'");
    $title = mysqli_fetch_object(mysqli_query($db,"SELECT title FROM properties WHERE id='$ads_id'"))?->title;
    $qr1 = mysqli_query($db,"select * from messages where ((sender_id='$id' and receiver_id='$chat_id') or (sender_id='$chat_id' and receiver_id='$id')) and ads_id='$ads_id' order by id desc limit $page,12");
    while ($qr = mysqli_fetch_object($qr1)){
        $data[] = array(
            "id" => isset($qr->id) ? intval($qr->id) : 0,
            "sender" => $qr->sender_id == $id ? 'me' : 'other',
            "msg" => isset($qr->msg) ? $qr->msg : '',
            "img" => isset($qr->img) ? $qr->img : '',
            "read" => isset($qr->is_read) ? intval($qr->is_read) : 0,
            "time" => isset($qr->create_at) ? substr(explode(" ",$qr->create_at)[1], 0, -3) : "",
        );
    }

    $res = array(
        "status" => 1,
        "title" => $title ?? '',
        "data" => array_reverse($data)
    );
    echo json_encode($res);exit();
}

function sync_chat($owner_id,$chat_id,$ads_id){
    global $db;
    $id = $owner_id;
    $data = [];

    mysqli_query($db,"update messages set is_read='1' where sender_id='$chat_id' and receiver_id='$id' and is_read='0' and ads_id='$ads_id'");
    $qr1 = mysqli_query($db,"select * from messages where ((sender_id='$id' and receiver_id='$chat_id') or (sender_id='$chat_id' and receiver_id='$id')) and ads_id='$ads_id' order by id desc limit 10");
    while ($qr = mysqli_fetch_object($qr1)){
        $data[] = array(
            "id" => isset($qr->id) ? intval($qr->id) : 0,
            "sender" => $qr->sender_id == $id ? 'me' : 'other',
            "msg" => isset($qr->msg) ? $qr->msg : '',
            "img" => isset($qr->img) ? $qr->img : '',
            "read" => isset($qr->is_read) ? intval($qr->is_read) : 0,
            "time" => isset($qr->create_at) ? substr(explode(" ",$qr->create_at)[1], 0, -3) : "",
        );
    }

    $res = array(
        "status" => 1,
        "read" => isset($data[0]['read']) ? intval($data[0]['read']) : 0,
        "data" => array_reverse($data)
    );
    echo json_encode($res);exit();


}
