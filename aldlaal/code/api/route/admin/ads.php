<?php
if(!isset($fp)){echo json_encode(array("status" => 0));exit();}
// run
$perPage = int_param($rawdata["per_page"] ?? 0, 0, 500);
$page = (max(1, int_param($rawdata["page"] ?? 1, 1)) - 1) * $perPage;
isset($rawdata["id"]) && $rawdata["id"] != '' ? $id = mysqli_real_escape_string($db, $rawdata["id"]) : $id = 0;
isset($rawdata["slug"]) && $rawdata["slug"] != '' ? $slug = mysqli_real_escape_string($db, $rawdata["slug"]) : $slug = '';
isset($rawdata["route"]) && $rawdata["route"] != '' && $rawdata["route"] != null ? $route = mysqli_real_escape_string($db, $rawdata["route"]) : $route = '';
isset($rawdata["route_id"]) && $rawdata["route_id"] != '' && $rawdata["route_id"] != null ? $route_id = mysqli_real_escape_string($db, $rawdata["route_id"]) : $route_id = 0;
isset($rawdata["img"]) && $rawdata["img"] != '' ? $img = mysqli_real_escape_string($db, $rawdata["img"]) : $img = '';
isset($rawdata["valid"]) && $rawdata["valid"] != '' ? $valid = mysqli_real_escape_string($db, $rawdata["valid"]) : $valid = 0;

if (!isset($p[2]) || $p[2] == '') {
    echo json_encode(array("status" => 0));exit();
}elseif($p[2] == 'get_page'){
    get_page($page,$perPage);
}elseif($p[2] == 'add'){
    add($slug,$route,$route_id,$img,$valid);
}elseif($p[2] == 'edit'){
    edit($id,$slug,$route,$route_id,$img,$valid);
}elseif($p[2] == 'remove'){
    remove($id);
}elseif($p[2] == 'get_sel_type'){
    get_sel_type($route);
}else{
    echo json_encode(array("status" => 0));exit();
}



// functions
// get by page
function get_page($page,$perPage){
    global $db;
    $data = array();
    $qr1 = mysqli_query($db,"select * from sliders");
    $qr2 = mysqli_query($db,"select * from sliders order by id desc limit $page,$perPage");
    $rows = mysqli_num_rows($qr1);
    while ($qr = mysqli_fetch_object($qr2)){
        $data[] = array(
            "id" => intval($qr->id),
            "slug" => $qr->slug,
            "route" => $qr->route,
            "route_id" => $qr->route_id,
            "img" => $qr->img,
            "valid" => intval($qr->valid)
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
function add($slug,$route,$route_id,$img,$valid){
    global $db;
    mysqli_query($db,"insert into sliders (slug,route,route_id,img,valid) values ('$slug','$route','$route_id','$img','$valid')");
    $res = array("status" => 1);
    echo json_encode($res);exit();
}
// edit
function edit($id,$slug,$route,$route_id,$img,$valid){
    global $db;
    mysqli_query($db,"update sliders set slug='$slug',route='$route',route_id='$route_id',img='$img',valid='$valid' where id='$id'");
    $res = array("status" => 1);
    echo json_encode($res);exit();
}
// remove
function remove($id){
    global $db;
    mysqli_query($db,"delete from sliders where id='$id'");
    echo json_encode(array("status" => 1));exit();
}

function get_sel_type($route){
    global $db;

    if($route == "ads"){
        $qr1 = mysqli_query($db,"select * from properties where status='active'");
    }else{echo json_encode(array("status" => 0));exit();}

    $data = [];
    while ($qr = mysqli_fetch_object($qr1)){
        $data[] = array(
            "id" => intval($qr->id),
            "name" => isset($qr->title) ? $qr->title : '',
        );
    }

    $res = array(
        "status" => 1,
        "data" => $data
    );
    echo json_encode($res);exit();
}