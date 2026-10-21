<?php
if(!isset($fp)){echo json_encode(array("status" => 0));exit();}
// run
$perPage = isset($rawdata["per_page"]) ? mysqli_real_escape_string($db, $rawdata["per_page"]) : 0;
$page = isset($rawdata["page"]) ? mysqli_real_escape_string($db, ($rawdata["page"]-1)*$perPage) : 0;
$id = isset($rawdata["id"]) && $rawdata["id"] != null ? mysqli_real_escape_string($db,$rawdata["id"]) : 0;
$agency_id = isset($rawdata["agency_id"]) && $rawdata["agency_id"] != null ? mysqli_real_escape_string($db,$rawdata["agency_id"]) : 0;
$title = isset($rawdata["title"]) ? mysqli_real_escape_string($db,$rawdata["title"]) : '';
$description = isset($rawdata["description"]) ? mysqli_real_escape_string($db,$rawdata["description"]) : '';
$purpose = isset($rawdata["purpose"]) && $rawdata["purpose"] != null ? mysqli_real_escape_string($db,$rawdata["purpose"]) : '';
$type = isset($rawdata["type"]) && $rawdata["type"] != null ? mysqli_real_escape_string($db,$rawdata["type"]) : '';
$price = isset($rawdata["price"]) ? mysqli_real_escape_string($db,$rawdata["price"]) : '';
$curr = isset($rawdata["curr"]) ? mysqli_real_escape_string($db,$rawdata["curr"]) : '';
$bedrooms = isset($rawdata["bedrooms"]) && $rawdata["bedrooms"] != null && $rawdata["bedrooms"] != null ? mysqli_real_escape_string($db,$rawdata["bedrooms"]) : 0;
$bathrooms = isset($rawdata["bathrooms"]) && $rawdata["bathrooms"] != null && $rawdata["bathrooms"] != null ? mysqli_real_escape_string($db,$rawdata["bathrooms"]) : 0;
$garages = isset($rawdata["garages"]) && $rawdata["garages"] != null && $rawdata["garages"] != null ? mysqli_real_escape_string($db,$rawdata["garages"]) : 0;
$area_m2 = isset($rawdata["area_m2"]) ? mysqli_real_escape_string($db,$rawdata["area_m2"]) : '';
$address = isset($rawdata["address"]) ? mysqli_real_escape_string($db,$rawdata["address"]) : '';
$city = isset($rawdata["city"]) && $rawdata["city"] != null ? mysqli_real_escape_string($db,$rawdata["city"]) : '';
$state = isset($rawdata["state"]) && $rawdata["state"] != null ? mysqli_real_escape_string($db,$rawdata["state"]) : '';
$location = isset($rawdata["location"]) && $rawdata["location"] != null ? $rawdata["location"] : [];
$img = isset($rawdata["img"]) ? mysqli_real_escape_string($db,$rawdata["img"]) : '';
$plan_img = isset($rawdata["plan_img"]) ? mysqli_real_escape_string($db,$rawdata["plan_img"]) : '';
$imgs = isset($rawdata["imgs"]) ? $rawdata["imgs"] : [];
$estate_status = isset($rawdata["estate_status"]) && $rawdata["estate_status"] != null ? mysqli_real_escape_string($db,$rawdata["estate_status"]) : '';
$status = isset($rawdata["status"]) && $rawdata["status"] != null ? mysqli_real_escape_string($db,$rawdata["status"]) : 'active';
$admin_review = isset($rawdata["admin_review"]) && $rawdata["admin_review"] != null ? mysqli_real_escape_string($db,$rawdata["admin_review"]) : '';

$size_min = isset($rawdata["size_min"]) ? mysqli_real_escape_string($db,$rawdata["size_min"]) : '';
$size_max = isset($rawdata["size_max"]) ? mysqli_real_escape_string($db,$rawdata["size_max"]) : '';
$price_min = isset($rawdata["price_min"]) ? mysqli_real_escape_string($db,$rawdata["price_min"]) : '';
$price_max = isset($rawdata["price_max"]) ? mysqli_real_escape_string($db,$rawdata["price_max"]) : '';

if (!isset($p[2]) || $p[2] == '') {
    echo json_encode(array("status" => 0));exit();
}elseif($p[2] == 'get_one'){
    get_one($id);
}elseif($p[2] == 'get_page'){
    get_page($page,$perPage,$id,$agency_id,$title,$purpose,$type,$bedrooms,$bathrooms,$garages,$city,$state,$estate_status,$status,$admin_review,$size_min,$size_max,$price_min,$price_max);
}elseif($p[2] == 'add'){
    add($agency_id,$title,$description,$purpose,$type,$price,$curr,$bedrooms,$bathrooms,$garages,$area_m2,$address,$city,$state,$location,$img,$plan_img,$imgs,$estate_status,$status,$admin_review);
}elseif($p[2] == 'edit'){
    edit($id,$agency_id,$title,$description,$purpose,$type,$price,$curr,$bedrooms,$bathrooms,$garages,$area_m2,$address,$city,$state,$location,$img,$plan_img,$imgs,$estate_status,$status,$admin_review);
}elseif($p[2] == 'remove'){
    remove($id);
}elseif($p[2] == 'get_map'){
    get_map($state,$city);
}elseif($p[2] == 'get_reports'){
    get_reports($page,$perPage);
}elseif($p[2] == 'remove_report'){
    remove_reports($id);
}else{
    echo json_encode(array("status" => 0));exit();
}



// functions

// get one
function get_one($id){
    global $db;
    $qr1 = mysqli_query($db,"select * from properties where id='$id'");
    if(mysqli_num_rows($qr1) != 0){
        $qr = mysqli_fetch_object($qr1);
        $agency = mysqli_fetch_object(mysqli_query($db,"select name from agencies where id='$qr->agency_id'"))?->name;
        $data = array(
            "id" => intval($qr->id),
            "agency_id" => intval($qr->agency_id),
            "agency" => $agency != '' ? $agency : '',
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
            "location" => $qr->location != "[]" && $qr->location != '' ? json_decode($qr->location,true) : null,
            "img" => $qr->img,
            "video" => $qr->video,
            "plan_img" => $qr->plan_img,
            "reviews" => $qr->reviews,
            "rate" => $qr->rate,
            "imgs" => json_decode($qr->imgs),
            "estate_status" => $qr->estate_status,
            "status" => $qr->status,
            "admin_review" => $qr->admin_review,
            "update_at" => explode(' ',$qr->update_at)[0],
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
function get_page($page,$perPage,$id,$agency_id,$title,$purpose,$type,$bedrooms,$bathrooms,$garages,$city,$state,$estate_status,$status,$admin_review,$size_min,$size_max,$price_min,$price_max){
    global $db;
    $data = array();

    $q_id = $id != 0 ? "id='$id' and " : "";
    $q_agency_id = $agency_id != 0 ? "agency_id='$agency_id' and " : "";
    $q_title = $title != '' ? "title like '%$title%' and " : "";
    $q_purpose = $purpose != '' ? "purpose='$purpose' and " : "";
    $q_type = $type != '' ? "type='$type' and " : "";
    $q_bedrooms = $bedrooms != 0 ? "bedrooms='$bedrooms' and " : "";
    $q_bathrooms = $bathrooms != 0 ? "bathrooms='$bathrooms' and " : "";
    $q_garages = $garages != 0 ? "garages='$garages' and " : "";
    $q_city = $city != '' ? "city='$city' and " : "";
    $q_state = $state != '' ? "state='$state' and " : "";
    $q_estate_status = $estate_status != '' ? "estate_status='$estate_status' and " : "";
    $q_admin_review = $admin_review != '' ? "admin_review='$admin_review' and " : "";
    $q_size_min = $size_min == "" ? "":"area_m2 >= '$size_min' and ";
    $q_size_max = $size_max == "" ? "":"area_m2 <= '$size_max' and ";
    $q_price_min = $price_min == "" ? "":"price >= '$price_min' and ";
    $q_price_max = $price_max == "" ? "":"price <= '$price_max' and ";

    if($q_id == "" && $q_agency_id == "" && $q_title == "" && $q_purpose == "" && $q_type == "" && $q_bedrooms == "" && $q_bathrooms == "" && $q_garages == "" && $q_city == "" && $q_state == "" && $q_estate_status == "" && $q_admin_review == "" && $q_size_min == "" && $q_size_max == "" && $q_price_min == "" && $q_price_max == ""){
        $str = "";
    }else{
        $str = "where ".$q_id.$q_agency_id.$q_title.$q_purpose.$q_type.$q_bedrooms.$q_bathrooms.$q_garages.$q_city.$q_state.$q_estate_status.$q_admin_review.$q_size_min.$q_size_max.$q_price_min.$q_price_max;
        $str = substr($str, 0, -5);
    }

    $qr1 = mysqli_query($db,"select * from properties $str");
    $qr2 = mysqli_query($db,"select * from properties $str order by id desc limit $page,$perPage");
    $rows = mysqli_num_rows($qr1);
    while ($qr = mysqli_fetch_object($qr2)){
        $agency = mysqli_fetch_object(mysqli_query($db,"select name from agencies where id='$qr->agency_id'"))?->name;
        $data[] = array(
            "id" => intval($qr->id),
            "agency_id" => $qr->agency_id != 0 ? intval($qr->agency_id) : null,
            "agency" => $agency != '' ? $agency : '',
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
            "location" => $qr->location != "[]" && $qr->location != '' ? json_decode($qr->location,true) : null,
            "img" => $qr->img,
            "video" => $qr->video,
            "plan_img" => $qr->plan_img,
            "reviews" => $qr->reviews,
            "rate" => $qr->rate,
            "imgs" => json_decode($qr->imgs),
            "estate_status" => $qr->estate_status,
            "status" => $qr->status,
            "admin_review" => $qr->admin_review,
            "update_at" => explode(' ',$qr->update_at)[0],
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

//add
function add($agency_id,$title,$description,$purpose,$type,$price,$curr,$bedrooms,$bathrooms,$garages,$area_m2,$address,$city,$state,$location,$img,$plan_img,$imgs,$estate_status,$status,$admin_review){
    global $db;
    $admin_review = $admin_review != '' ? $admin_review : 'pending';
    $imgs = json_encode($imgs,JSON_UNESCAPED_UNICODE);
    $location = json_encode($location,JSON_UNESCAPED_UNICODE);
    mysqli_query($db,"insert into properties (agency_id,title,description,purpose,type,price,curr,bedrooms,bathrooms,garages,area_m2,address,city,state,location,img,plan_img,imgs,estate_status,status,admin_review) 
                            values ('$agency_id','$title','$description','$purpose','$type','$price','$curr','$bedrooms','$bathrooms','$garages','$area_m2','$address','$city','$state','$location','$img','$plan_img','$imgs','$estate_status','$status','$admin_review')");
    $res = array(
        "status" => 1,
        "data" => ""
    );
    echo json_encode($res);exit();
}
// edit
function edit($id,$agency_id,$title,$description,$purpose,$type,$price,$curr,$bedrooms,$bathrooms,$garages,$area_m2,$address,$city,$state,$location,$img,$plan_img,$imgs,$estate_status,$status,$admin_review){
    global $db;
    $imgs = json_encode($imgs,JSON_UNESCAPED_UNICODE);
    $location = json_encode($location,true);
    mysqli_query($db,"update properties set agency_id='$agency_id',title='$title',description='$description',purpose='$purpose',type='$type',
                            price='$price',curr='$curr',bedrooms='$bedrooms',bathrooms='$bathrooms',garages='$garages',area_m2='$area_m2',address='$address',city='$city',state='$state',
                            location='$location',img='$img',plan_img='$plan_img',imgs='$imgs',estate_status='$estate_status',status='$status',admin_review='$admin_review'
                            where id='$id'");
    echo json_encode(array("status" => 1));exit();
}
// remove
function remove($id){
    global $db;
    mysqli_query($db,"delete from properties where id='$id'");
    $res = array("status" => 1);
    echo json_encode($res);exit();
}

function get_map($state,$city){
    global $db;
    $data = [];
    $perPage=250;

    $q_city = $city != '' ? "city='$city' and " : "";
    $q_state = $state != '' ? "state='$state' and " : "";

    if($q_city == "" && $q_state == ""){
        $str = "";
    }else{
        $str = "and ".$q_city.$q_state;
        $str = substr($str, 0, -5);
    }

    $qr1 = mysqli_query($db,"select * from properties where status='active' and admin_review='approved' and location != '[]' and location != '' $str limit $perPage");

    while ($qr = mysqli_fetch_object($qr1)){
        $agency = mysqli_fetch_object(mysqli_query($db,"select name from agencies where id='$qr->agency_id'"))?->name;
        $data[] = array(
            "id" => intval($qr->id),
            "agency_id" => $qr->agency_id != 0 ? intval($qr->agency_id) : null,
            "agency" => $agency != '' ? $agency : '',
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
            "location" => $qr->location != "[]" && $qr->location != '' ? json_decode($qr->location,true) : null,
            "img" => $qr->img,
            "plan_img" => $qr->plan_img,
            "reviews" => $qr->reviews,
            "rate" => $qr->rate,
            "imgs" => json_decode($qr->imgs),
            "estate_status" => $qr->estate_status,
            "status" => $qr->status,
            "admin_review" => $qr->admin_review,
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

function get_reports($page,$perPage){
    global $db;
    $data = array();

    $qr1 = mysqli_query($db,"select * from reports");
    $qr2 = mysqli_query($db,"select * from reports order by id desc limit $page,$perPage");
    $rows = mysqli_num_rows($qr1);
    while ($qr0 = mysqli_fetch_object($qr2)){
        $qr = mysqli_fetch_object(mysqli_query($db,"select * from properties where id='".$qr0->property_id."'"));
        $agency = mysqli_fetch_object(mysqli_query($db,"select name from agencies where id='$qr->agency_id'"))?->name;
        $report_name = mysqli_fetch_object(mysqli_query($db,"select name from users where id='$qr0->user_id'"))?->name;
        $data[] = array(
            "id" => intval($qr0->id),
            "report_name" => $report_name,
            "report_type" => $qr0->type,
            "report_note" => $qr0->note,
            "report_status" => $qr0->status,
            "report_at" => explode(' ',$qr0->create_at)[0],

            "property_id" => intval($qr->id),
            "agency_id" => $qr->agency_id != 0 ? intval($qr->agency_id) : null,
            "owner_id" => $agency->owner_id ?? 0,
            "phone" => $agency->phone ?? 0,
            "agency" => $agency != '' ? $agency : '',
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
            "is_furnished" => $qr->is_furnished,
            "address" => $qr->address,
            "city" => $qr->city,
            "state" => $qr->state,
            "location" => $qr->location != "[]" && $qr->location != '' ? json_decode($qr->location,true) : null,
            "img" => $qr->img,
            "plan_img" => $qr->plan_img,
            "reviews" => $qr->reviews,
            "rate" => $qr->rate,
            "imgs" => json_decode($qr->imgs),
            "estate_status" => $qr->estate_status,
            "status" => $qr->status,
            "admin_review" => $qr->admin_review,
            "update_at" => explode(' ',$qr->update_at)[0],
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

function remove_reports($id){
    global $db;
    mysqli_query($db,"delete from reports where id='$id'");
    $res = array("status" => 1);
    echo json_encode($res);exit();
}