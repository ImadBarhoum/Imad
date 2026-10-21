<?php
if(!isset($fp)){echo json_encode(array("status" => 0));exit();}
// run
isset($rawdata["page"]) && $rawdata["page"] != '' ? $page = mysqli_real_escape_string($db, $rawdata["page"]) : $page = 1;
isset($rawdata["id"]) && $rawdata["id"] != '' ? $id = mysqli_real_escape_string($db, $rawdata["id"]) : $id = 0;
$title = isset($rawdata["title"]) ? mysqli_real_escape_string($db,$rawdata["title"]) : '';
isset($rawdata["notification_email"]) && $rawdata["notification_email"] != '' ? $notification_email = mysqli_real_escape_string($db, $rawdata["notification_email"]) : $notification_email = 0;
isset($rawdata["notification_app"]) && $rawdata["notification_app"] != '' ? $notification_app = mysqli_real_escape_string($db, $rawdata["notification_app"]) : $notification_app = 0;
$search_json = isset($rawdata["search_json"]) && $rawdata["search_json"] != null ? $rawdata["search_json"] : [];

if (!isset($p[2]) || $p[2] == '') {
    echo json_encode(array("status" => 0));exit();
}elseif($p[2] == 'get_page'){
    get_page($page);
}elseif($p[2] == 'get_one'){
    get_one($id);
}elseif($p[2] == 'add'){
    add($title,$search_json,$notification_email,$notification_app);
}elseif($p[2] == 'edit'){
    edit($id,$title,$notification_email,$notification_app);
}elseif($p[2] == 'remove'){
    remove($id);
}elseif($p[2] == 'remove'){
    reset_count($id);
}else{
    echo json_encode(array("status" => 0));exit();
}


// functions

function get_page($page){
    global $db,$auth;
    $uid = $auth['data']->id;
    $data = [];
    $perPage=10;
    $page = ($page-1)*$perPage;

    $qr1 = mysqli_query($db,"select * from search_favorites where user_id='$uid' order by id desc limit $page,$perPage");

    while ($qr = mysqli_fetch_object($qr1)){
        $data[] = array(
            "id" => intval($qr->id),
            "title" => $qr->title,
            "search_json" => $qr->search_json != "[]" && $qr->search_json != '' ? json_decode($qr->search_json,true) : null,
            "notification_email" => intval($qr->notification_email),
            "notification_app" => intval($qr->notification_app),
            "update_at" => explode(' ',$qr->update_at)[0],
            "create_at" => explode(' ',$qr->create_at)[0]
        );
    }
    $res = array(
        "status" => 1,
        "data" => $data
    );
    echo json_encode($res);exit();
}

function get_one($id){
    global $db,$auth;
    $uid = $auth['data']->id;
    $qr = mysqli_fetch_object(mysqli_query($db,"select * from search_favorites where id='$id' and user_id='$uid'"));
    $data = array(
        "id" => intval($qr->id),
        "title" => $qr->title,
        "search_json" => $qr->search_json != "[]" && $qr->search_json != '' ? json_decode($qr->search_json,true) : null,
        "notification_email" => intval($qr->notification_email),
        "notification_app" => intval($qr->notification_app),
        "update_at" => explode(' ',$qr->update_at)[0],
        "create_at" => explode(' ',$qr->create_at)[0]
    );
    $res = array(
        "status" => 1,
        "data" => $data
    );
    echo json_encode($res);exit();
}

// add
function add($title,$search_json,$notification_email,$notification_app){
    global $db,$auth;
    $uid = $auth['data']->id;
    $search_json = json_encode($search_json,JSON_UNESCAPED_UNICODE);

    // add search_query
    $search_query = "";

    mysqli_query($db,"insert into search_favorites (user_id,title,search_json,search_query,notification_email,notification_app) values ('$uid','$title','$search_json','$search_query','$notification_email','$notification_app')");
    $res = array("status" => 1);
    echo json_encode($res);exit();
}
// edit
function edit($id,$title,$notification_email,$notification_app){
    global $db,$auth;
    $uid = $auth['data']->id;
    mysqli_query($db,"update search_favorites set title='$title',notification_email='$notification_email',notification_app='$notification_app' where id='$id' and user_id='$uid'");
    $res = array("status" => 1);
    echo json_encode($res);exit();
}
// remove
function remove($id){
    global $db,$auth;
    $uid = $auth['data']->id;
    mysqli_query($db,"delete from search_favorites where id='$id' and user_id='$uid'");
    echo json_encode(array("status" => 1));exit();
}

function reset_count($id){
    global $db,$auth;
    $uid = $auth['data']->id;
    mysqli_query($db,"update search_favorites set count='0' where id='$id' and user_id='$uid'");
    echo json_encode(array("status" => 1));exit();
}