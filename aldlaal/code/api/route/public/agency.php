<?php
if(!isset($fp)){echo json_encode(array("status" => 0));exit();}
// run
$id = isset($rawdata["id"]) ? mysqli_real_escape_string($db,$rawdata["id"]) : 0;
$page = max(1, int_param($rawdata["page"] ?? 1, 1));
isset($rawdata["search"]) && $rawdata["search"] != '' ? $search = mysqli_real_escape_string($db, $rawdata["search"]) : $search = '';
$city = isset($rawdata["city"]) && $rawdata["city"] != null ? mysqli_real_escape_string($db,$rawdata["city"]) : '';
$state = isset($rawdata["state"]) && $rawdata["state"] != null ? mysqli_real_escape_string($db,$rawdata["state"]) : '';


if (!isset($p[2]) || $p[2] == '') {
    echo json_encode(array("status" => 0));exit();
}elseif($p[2] == 'get_page'){
    get_page($page,$search,$city,$state);
}elseif($p[2] == 'get_agency'){
    get_agency($id);
}else{
    echo json_encode(array("status" => 0));exit();
}



// functions

function get_agency($id){
    global $db;
    $qr1 = mysqli_query($db,"select * from agencies where id='$id'");
    if(mysqli_num_rows($qr1) != 0){
        $qr = mysqli_fetch_object($qr1);

        $user_verify = mysqli_fetch_object(mysqli_query($db,"select verify from users where id='$qr->owner_id'"))?->verify;

        $data = array(
            "id" => intval($qr->id),
            "owner_id" => intval($qr->owner_id),
            "name" => $qr->name,
            "description" => $qr->description,
            "email" => $qr->email,
            "phone" => $qr->phone,
            "address" => $qr->address,
            "city" => $qr->city,
            "state" => $qr->state,
            "reviews" => $qr->reviews,
            "rate" => $qr->rate,
            "img" => $qr->img,
            "cover" => $qr->cover,
            "status" => $qr->status,
            "user_verify" => $user_verify != '' ? $user_verify : 'no',
            "create_at" => explode(' ',$qr->create_at)[0]
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
function get_page($page,$name,$city,$state){
    global $db;
    $perPage=12;
    $page = ($page-1)*$perPage;
    $data = array();

    $q_name = $name != '' ? "name like '%$name%' and " : "";
    $q_city = $city != '' ? "city='$city' and " : "";
    $q_state = $state != '' ? "state='$state' and " : "";

    if($q_name == "" && $q_city == "" && $q_state == ""){$str = "where status='approved'";}
    else{
        $str = "where status='approved' and ".$q_name.$q_city.$q_state;
        $str = substr($str, 0, -5);
    }

    $qr2 = mysqli_query($db,"select * from agencies $str order by id desc limit $page,$perPage");
    while ($qr = mysqli_fetch_object($qr2)){
        $data[] = array(
            "id" => intval($qr->id),
            "name" => $qr->name,
            "city" => $qr->city,
            "state" => $qr->state,
            "reviews" => $qr->reviews,
            "rate" => $qr->rate,
            "img" => $qr->img,
            "cover" => $qr->cover,
            "create_at" => explode(' ',$qr->create_at)[0]
        );
    }
    $res = array(
        "status" => 1,
        "data" => $data
    );
    echo json_encode($res);exit();
}