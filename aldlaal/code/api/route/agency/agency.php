<?php
if(!isset($fp)){echo json_encode(array("status" => 0));exit();}
// run
$id = isset($rawdata["id"]) ? mysqli_real_escape_string($db,$rawdata["id"]) : 0;
$name = isset($rawdata["name"]) ? mysqli_real_escape_string($db,$rawdata["name"]) : '';
$email = isset($rawdata["email"]) ? mysqli_real_escape_string($db,$rawdata["email"]) : '';
$phone = isset($rawdata["phone"]) ? mysqli_real_escape_string($db,$rawdata["phone"]) : '';
$description = isset($rawdata["description"]) ? mysqli_real_escape_string($db,$rawdata["description"]) : '';
$address = isset($rawdata["address"]) ? mysqli_real_escape_string($db,$rawdata["address"]) : '';
$city = isset($rawdata["city"]) ? mysqli_real_escape_string($db,$rawdata["city"]) : '';
$state = isset($rawdata["state"]) ? mysqli_real_escape_string($db,$rawdata["state"]) : '';
$img = isset($rawdata["img"]) ? mysqli_real_escape_string($db,$rawdata["img"]) : '';
$cover = isset($rawdata["cover"]) ? mysqli_real_escape_string($db,$rawdata["cover"]) : '';


if (!isset($p[2]) || $p[2] == '') {
    echo json_encode(array("status" => 0));exit();
}elseif($p[2] == 'get_info'){
    get_info();
}elseif($p[2] == 'check'){
    check();
}elseif($p[2] == 'add'){
    add($name,$email,$phone,$description,$address,$city,$state,$img,$cover);
}elseif($p[2] == 'edit'){
    edit($name,$email,$phone,$description,$address,$city,$state,$img,$cover);
}elseif($p[2] == 'remove'){
    //remove($id);
}elseif($p[2] == 'get_ads_page'){
    get_ads_page();
}else{
    echo json_encode(array("status" => 0));exit();
}



// functions

function get_info(){
    global $db,$auth;
    $uid = isset($auth['data']->id) ? $auth['data']->id : 0;
    $qr1 = mysqli_query($db,"select * from agencies where owner_id='$uid'");
    if(mysqli_num_rows($qr1) != 0){
        $qr = mysqli_fetch_object($qr1);
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
function check(){
    global $db,$auth;
    $uid = isset($auth['data']->id) ? $auth['data']->id : 0;
    $row = mysqli_num_rows(mysqli_query($db,"select id from agencies where owner_id='$uid'"));
    if($row > 0){
        echo json_encode(array("status" => 1));exit();
    }else{
        echo json_encode(array("status" => 0));exit();
    }
}
function add($name,$email,$phone,$description,$address,$city,$state,$img,$cover){
    global $db,$auth;
    $uid = isset($auth['data']->id) ? $auth['data']->id : 0;
    mysqli_query($db,"insert into agencies (owner_id,name,email,phone,description,address,city,state,img,cover) values ('$uid','$name','$email','$phone','$description','$address','$city','$state','$img','$cover')");
    echo json_encode(array("status" => 1));exit();
}
function edit($name,$email,$phone,$description,$address,$city,$state,$img,$cover){
    global $db,$auth;
    $uid = isset($auth['data']->id) ? $auth['data']->id : 0;
    mysqli_query($db,"update agencies set name='$name',email='$email',phone='$phone',description='$description',address='$address',city='$city',state='$state',img='$img',cover='$cover' where owner_id='$uid'");
    echo json_encode(array("status" => 1));exit();
}

function remove($id){
    global $db,$auth;
    $uid = isset($auth['data']->id) ? $auth['data']->id : 0;
    mysqli_query($db,"delete from agencies where id='$id' and owner_id='$uid'");
    $res = array("status" => 1);
    echo json_encode($res);exit();
}

function get_ads_page(){
    global $db,$auth;
    $id = $auth['data']->id;

    $fav = mysqli_num_rows(mysqli_query($db,"select id from favorites where user_id='$id'"));
    $agency_id = mysqli_fetch_object(mysqli_query($db,"select id from agencies where owner_id='$id'"))?->id;
    $ads = mysqli_num_rows(mysqli_query($db,"select id from properties where agency_id='$agency_id'"));

    $total = 0;
    $total_rate = 0;
    $qr_rate = mysqli_query($db,"select rate from reviews where agency_id='$agency_id'");
    while ($rates = mysqli_fetch_object($qr_rate)){
        $total_rate = $total_rate+$rates->rate;
        $total = $total+1;
    }
    $views = 0;
    $reports = 0;

    $res = array(
        "status" => 1,
        "data" => [
            "views" => number_format($views),
            "reports" => number_format($reports),
            "fav" => number_format($fav),
            "ads" => number_format($ads),
            "reviews" => number_format($total),
            "rate" => $total_rate != 0 ? number_format($total_rate/$total,1) : '0.0'
        ]
    );
    echo json_encode($res);exit();
}