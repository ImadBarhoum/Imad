<?php
if(!isset($fp)){echo json_encode(array("status" => 0));exit();}
// run
$page = isset($rawdata["page"]) ? mysqli_real_escape_string($db, $rawdata["page"]) : 1;
$id = isset($rawdata["id"]) && $rawdata["id"] != null ? mysqli_real_escape_string($db,$rawdata["id"]) : 0;
$agency_id = isset($rawdata["agency_id"]) && $rawdata["agency_id"] != null ? mysqli_real_escape_string($db,$rawdata["agency_id"]) : 0;
$type = isset($rawdata["type"]) && $rawdata["type"] != null ? mysqli_real_escape_string($db,$rawdata["type"]) : "";
$note = isset($rawdata["note"]) && $rawdata["note"] != null ? mysqli_real_escape_string($db,$rawdata["note"]) : "";


if (!isset($p[2]) || $p[2] == '') {
    echo json_encode(array("status" => 0));exit();
}elseif($p[2] == 'set_fav'){
    setFav($id);
}elseif($p[2] == 'get_fav'){
    getFav($page);
}elseif($p[2] == 'report_now'){
    report_now($id,$agency_id,$type,$note);
}else{
    echo json_encode(array("status" => 0));exit();
}


// functions

function setFav($prop_id){
    global $db,$auth;
    $id = $auth['data']->id;
    $is_fav = mysqli_num_rows(mysqli_query($db,"select * from favorites where property_id='$prop_id' and user_id='$id'"));
    if($is_fav == 0){
        mysqli_query($db,"insert into favorites (property_id,user_id) values ('$prop_id','$id')");
    }else{
        mysqli_query($db,"delete from favorites where property_id='$prop_id' and user_id='$id'");
    }
    echo json_encode(array("status" => 1));exit();
}

function getFav($page){
    global $db,$auth;
    $id = $auth['data']->id;
    $data = [];
    $page = ($page-1)*10;
    $fav_qr1 = mysqli_query($db,"select * from favorites where user_id='$id'");
    if(mysqli_num_rows($fav_qr1) == 0){echo json_encode(array("status" => 1,"data" => $data));exit();}

    while ($fav_qr = mysqli_fetch_object($fav_qr1)){
        $property_id = $fav_qr->property_id;
        $qr = mysqli_fetch_object(mysqli_query($db,"select * from properties where id='$property_id' and status='active' limit $page,10"));
        $agency = mysqli_fetch_object(mysqli_query($db,"select owner_id,name,phone from agencies where id='$qr->agency_id'"));

        if($auth['valid'] == 1){
            $uid = $auth['data']->id;
            $is_fav = mysqli_num_rows(mysqli_query($db,"select * from favorites where property_id='$qr->id' and user_id='$uid'"));
        }else{
            $is_fav = 0;
        }

        $data[] = array(
            "id" => intval($qr->id),
            "agency_id" => $qr->agency_id != 0 ? intval($qr->agency_id) : null,
            "owner_id" => $agency->owner_id ?? 0,
            "phone" => $agency->phone ?? 0,
            "agency" => $agency->name != '' ? $agency->name : '',
            "title" => $qr->title,
            "description" => $qr->description,
            "purpose" => $qr->purpose,
            "type" => $qr->type,
            "price" => $qr->price,
            "curr" => $qr->curr,
            "bedrooms" => $qr->bedrooms,
            "bathrooms" => $qr->bathrooms,
            "garages" => $qr->garages,
            "area_m2" => $qr->area_m2,
            "address" => $qr->address,
            "city" => $qr->city,
            "state" => $qr->state,
            "latitude" => isset($qr->latitude) ?? $qr->latitude,
            "longitude" => isset($qr->longitude) ?? $qr->longitude,
            "img" => $qr->img,
            "video" => $qr->video,
            "reviews" => $qr->reviews,
            "rate" => $qr->rate,
            "imgs" => json_decode($qr->imgs),
            "estate_status" => $qr->estate_status,
            "status" => $qr->status,
            "admin_review" => $qr->admin_review,
            "is_fav" => intval($is_fav),
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

function report_now($id,$agency_id,$type,$note){
    global $db,$auth;
    $user_id = $auth['data']->id;
    $row = mysqli_num_rows(mysqli_query($db,"select * from reports where property_id='$id' and user_id='$user_id'"));
    if($row == 0){
        mysqli_query($db,"insert into reports (user_id,agency_id,property_id,type,note) values ('$user_id','$agency_id','$id','$type','$note')");
    }else{
        mysqli_query($db,"update reports set type='$type',note='$note' where property_id='$id' and user_id='$user_id'");
    }
    echo json_encode(array("status" => 1));exit();
}