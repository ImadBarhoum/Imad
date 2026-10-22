<?php
if(!isset($fp)){echo json_encode(array("status" => 0));exit();}
// run

if (!isset($p[2]) || $p[2] == '') {
    echo json_encode(array("status" => 0));exit();
}elseif($p[2] == 'get_home'){
    get_home();
}else{
    echo json_encode(array("status" => 0));exit();
}


// functions

// get all
function get_home(){
    global $db;

    // Sliders
    $sliders = [];
    $qr1 = mysqli_query($db,"select * from sliders where slug='main' and valid='1' order by RAND() limit 10");
    while ($qr = mysqli_fetch_object($qr1)){
        $sliders[] = array("id" => intval($qr->id), "slug" => $qr->slug, "img" => $qr->img, "route" => $qr->route, "route_id" => $qr->route_id);
    }

    $res = array(
        "status" => 1,
        "data" => [
            "sliders" => $sliders,
        ]
    );
    echo json_encode($res);exit();
}