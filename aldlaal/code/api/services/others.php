<?php
if(!isset($fp)){echo json_encode(array("status" => 0));exit();}
// run
$perPage = int_param($rawdata["per_page"] ?? 0, 0, 500);
$page = (max(1, int_param($rawdata["page"] ?? 1, 1)) - 1) * $perPage;
$id = isset($rawdata["id"]) ? mysqli_real_escape_string($db,$rawdata["id"]) : 0;
$state = isset($rawdata["state"]) ? mysqli_real_escape_string($db,$rawdata["state"]) : '';
$slug = isset($rawdata["slug"]) ? mysqli_real_escape_string($db,$rawdata["slug"]) : '';

if (!isset($p[1]) || $p[1] == '') {
    echo json_encode(array("status" => 0));exit();
}elseif($p[1] == 'get_states'){
    get_states();
}elseif($p[1] == 'get_citys'){
    get_citys($state);
}elseif($p[1] == 'get_page'){
    get_page($slug);
}else{
    echo json_encode(array("status" => 0));exit();
}


function get_page($slug){
    global $db;
    $qr = mysqli_query($db,"select * from pages where slug='$slug'");
    $row = mysqli_num_rows($qr);
    if($row == 0){echo json_encode(array("status" => 0));exit();}
    $page = mysqli_fetch_object($qr);
    $data = array(
        "id" => intval($page->id),
        "slug" => $page->slug,
        "title" => $page->title,
        "content" => $page->content,
        "create_date" => explode(" ", $page->create_date)[0],
    );
    echo json_encode(array("status" => 1,"data" => $data));exit();
}