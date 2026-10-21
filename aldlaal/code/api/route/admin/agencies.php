<?php
if(!isset($fp)){echo json_encode(array("status" => 0));exit();}
// run
$perPage = isset($rawdata["per_page"]) ? mysqli_real_escape_string($db, $rawdata["per_page"]) : 0;
$page = isset($rawdata["page"]) ? mysqli_real_escape_string($db, ($rawdata["page"]-1)*$perPage) : 0;
$id = isset($rawdata["id"]) ? mysqli_real_escape_string($db,$rawdata["id"]) : 0;
$owner_id = isset($rawdata["owner_id"]) ? mysqli_real_escape_string($db,$rawdata["owner_id"]) : 0;
$name = isset($rawdata["name"]) ? mysqli_real_escape_string($db,$rawdata["name"]) : '';
$email = isset($rawdata["email"]) ? mysqli_real_escape_string($db,$rawdata["email"]) : '';
$phone = isset($rawdata["phone"]) ? mysqli_real_escape_string($db,$rawdata["phone"]) : '';
$description = isset($rawdata["description"]) ? mysqli_real_escape_string($db,$rawdata["description"]) : '';
$address = isset($rawdata["address"]) ? mysqli_real_escape_string($db,$rawdata["address"]) : '';
$city = isset($rawdata["city"]) ? mysqli_real_escape_string($db,$rawdata["city"]) : '';
$state = isset($rawdata["state"]) ? mysqli_real_escape_string($db,$rawdata["state"]) : '';
$img = isset($rawdata["img"]) ? mysqli_real_escape_string($db,$rawdata["img"]) : '';
$status = isset($rawdata["status"]) ? mysqli_real_escape_string($db,$rawdata["status"]) : 'pending';


if (!isset($p[2]) || $p[2] == '') {
    echo json_encode(array("status" => 0));exit();
}elseif($p[2] == 'get_one'){
    get_one($id);
}elseif($p[2] == 'get_page'){
    get_page($page,$perPage,$name,$status);
}elseif($p[2] == 'edit'){
    edit($id,$name,$email,$phone,$description,$address,$city,$state,$img,$status);
}elseif($p[2] == 'remove'){
    remove($id);
}elseif($p[2] == 'agency_log'){
    agency_log($page,$perPage,$id);
}elseif($p[2] == 'remove_agency_log'){
    remove_agency_log($id);
}elseif($p[2] == 'get_agencys'){
    get_agencys();
}else{
    echo json_encode(array("status" => 0));exit();
}



// functions

// get one
function get_one($id){
    global $db;
    $qr1 = mysqli_query($db,"select * from agencies where id='$id'");
    if(mysqli_num_rows($qr1) != 0){
        $qr = mysqli_fetch_object($qr1);
        $owner = mysqli_fetch_object(mysqli_query($db,"select name from users where id='$qr->owner_id'"))?->name;
        $properties = mysqli_num_rows(mysqli_query($db,"select id from properties where agency_id='$qr->id' and admin_review='approved'"));
        $data = array(
            "id" => intval($qr->id),
            "owner_id" => intval($qr->owner_id),
            "owner" => $owner != '' ? $owner : '',
            "name" => $qr->name,
            "description" => $qr->description,
            "email" => $qr->email,
            "phone" => $qr->phone,
            "address" => $qr->address,
            "city" => $qr->city,
            "state" => $qr->state,
            "img" => $qr->img,
            "ads" => $properties,
            "reviews" => $qr->reviews,
            "rate" => $qr->rate,
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
// get by page
function get_page($page,$perPage,$name,$status){
    global $db;
    $data = array();

    $q_name = $name != '' ? "name like '%$name%' and " : "";
    if($q_name == ""){$str = "where status='$status'";}
    else{
        $str = "where status='$status' and ".$q_name;
        $str = substr($str, 0, -5);
    }

    $qr1 = mysqli_query($db,"select * from agencies $str");
    $qr2 = mysqli_query($db,"select * from agencies $str order by id desc limit $page,$perPage");
    $rows = mysqli_num_rows($qr1);
    while ($qr = mysqli_fetch_object($qr2)){

        $owner = mysqli_fetch_object(mysqli_query($db,"select name from users where id='$qr->owner_id'"))?->name;
        $properties = mysqli_num_rows(mysqli_query($db,"select id from properties where agency_id='$qr->id' and admin_review='approved'"));

        $data[] = array(
            "id" => intval($qr->id),
            "owner_id" => intval($qr->owner_id),
            "owner" => $owner != '' ? $owner : '',
            "name" => $qr->name,
            "description" => $qr->description,
            "email" => $qr->email,
            "phone" => $qr->phone,
            "address" => $qr->address,
            "city" => $qr->city,
            "state" => $qr->state,
            "img" => $qr->img,
            "ads" => $properties,
            "reviews" => $qr->reviews,
            "rate" => $qr->rate,
            "status" => $qr->status,
            "create_at" => explode(' ',$qr->create_at)[0]
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
function edit($id,$name,$email,$phone,$description,$address,$city,$state,$img,$status){
    global $db;
    mysqli_query($db,"update agencies set name='$name',email='$email',phone='$phone',description='$description',address='$address',city='$city',state='$state',img='$img',status='$status' where id='$id'");
    echo json_encode(array("status" => 1));exit();
}
// remove
function remove($id){
    global $db;
    mysqli_query($db,"delete from agencies where id='$id'");
    mysqli_query($db,"delete from properties where agency_id='$id'");
    $res = array("status" => 1);
    echo json_encode($res);exit();
}

function agency_log($page,$perPage,$id){
    global $db;
    $data = array();

    $str = $id != 0 ? "where agency_id='$id'" : "";
    $qr1 = mysqli_query($db,"select * from logs_agencies $str");
    $qr2 = mysqli_query($db,"select * from logs_agencies $str order by id desc limit $page,$perPage");
    $rows = mysqli_num_rows($qr1);
    while ($qr = mysqli_fetch_object($qr2)){
        $agency = mysqli_fetch_object(mysqli_query($db,"select name from agencies where id='$qr->agency_id'"))?->name;
        $data[] = array(
            "id" => intval($qr->id),
            "agency_id" => intval($qr->agency_id),
            "agency" => $agency,
            "content" => $qr->content,
            "create_at" => substr($qr->create_at,0,-3)
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

function remove_agency_log($id){
    global $db;
    mysqli_query($db,"delete from logs_agencies where id='$id'");
    $res = array("status" => 1);
    echo json_encode($res);exit();
}

function get_agencys(){
    global $db;
    $data = [];
    $qr1 = mysqli_query($db,"select id,owner_id,name from agencies order by name asc");
    while($qr = mysqli_fetch_object($qr1)){
        $data[] = array(
            "id" => intval($qr->id),
            "owner_id" => intval($qr->owner_id),
            "name" => $qr->name,
        );
    }
    $res = array(
        "status" => 1,
        "data" => $data
    );
    echo json_encode($res);exit();
}