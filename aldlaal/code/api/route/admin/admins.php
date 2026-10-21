<?php
if(!isset($fp)){echo json_encode(array("status" => 0));exit();}
// run
$perPage = int_param($rawdata["per_page"] ?? 0, 0, 500);
$page = (max(1, int_param($rawdata["page"] ?? 1, 1)) - 1) * $perPage;
$id = isset($rawdata["id"]) ? mysqli_real_escape_string($db,$rawdata["id"]) : 0;
$user = isset($rawdata["user"]) ? mysqli_real_escape_string($db,$rawdata["user"]) : '';
$email = isset($rawdata["email"]) ? mysqli_real_escape_string($db,$rawdata["email"]) : '';
$pwd = isset($rawdata["pwd"]) && is_string($rawdata["pwd"]) ? $rawdata["pwd"] : '';
$name = isset($rawdata["name"]) ? mysqli_real_escape_string($db,$rawdata["name"]) : '';
$valid = isset($rawdata["valid"]) ? mysqli_real_escape_string($db,$rawdata["valid"]) : 0;

if (!isset($p[2]) || $p[2] == '') {
    echo json_encode(array("status" => 0));exit();
}elseif($p[2] == 'get_all'){
    get_all();
}elseif($p[2] == 'get_page'){
    get_page($page,$perPage);
}elseif($p[2] == 'add'){
    add($user,$pwd,$valid);
}elseif($p[2] == 'edit'){
    edit($id,$pwd,$valid);
}elseif($p[2] == 'remove'){
    remove($id);
}elseif($p[2] == 'force_logout_admins'){
    force_logout_admins();
}else{
    echo json_encode(array("status" => 0));exit();
}

// functions

// get all
function get_all(){
    global $db;
    $data = array();
    $qr1 = mysqli_query($db,"select * from admin order by id desc");
    while ($qr = mysqli_fetch_object($qr1)){
        $data[] = array(
            "id" => intval($qr->id),
            "user" => $qr->user,
            "valid" => intval($qr->valid),
            "create_at" => explode(' ',$qr->create_at)[0]
        );
    }
    $res = array(
        "status" => 1,
        "data" => $data
    );
    echo json_encode($res);exit();
}
// get by page
function get_page($page,$perPage){
    global $db;
    $data = array();
    $qr1 = mysqli_query($db,"select * from admin");
    $qr2 = mysqli_query($db,"select * from admin order by id desc limit $page,$perPage");
    $rows = mysqli_num_rows($qr1);
    while ($qr = mysqli_fetch_object($qr2)){
        $data[] = array(
            "id" => intval($qr->id),
            "user" => $qr->user,
            "valid" => intval($qr->valid),
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
// add
function add($user,$pwd,$valid){
    global $db;
    if($user != '' && $pwd != ''){
        $row = mysqli_num_rows(mysqli_query($db,"select user from admin where user='$user'"));
        if($row == 0){
            $token = generateRandomString();
            $pwd = hash_pwd($pwd);
            mysqli_query($db,"insert into admin (user,pwd,valid,token) values ('$user','$pwd','$valid','$token')");
            $res = array("status" => 1);
            echo json_encode($res);exit();
        }else{
            echo json_encode(array("status" => 2));exit();
        }
    }else{
        echo json_encode(array("status" => 0));exit();
    }
}
// edit
function edit($id,$pwd,$valid){
    global $db;
    if($pwd != ''){$pwd = hash_pwd($pwd); mysqli_query($db,"update admin set pwd='$pwd' where id='$id'");}
    mysqli_query($db,"update admin set valid='$valid' where id='$id'");
    $res = array("status" => 1);
    echo json_encode($res);exit();
}
// remove
function remove($id){
    global $db;
    if($id != 1){mysqli_query($db,"delete from admin where id='$id'");}
    $res = array("status" => 1);
    echo json_encode($res);exit();
}
// force logout all admins
function force_logout_admins(){
    global $db;
    $qr1 = mysqli_query($db,"select id from admin");
    while($qr = mysqli_fetch_object($qr1)){
        $id = $qr->id;
        $token = generateRandomString();
        mysqli_query($db,"update admin set token='$token' where id='$id'");
    }
    echo json_encode(array("status" => 1));exit();
}