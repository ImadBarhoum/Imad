<?php
if(!isset($fp)){echo json_encode(array("status" => 0));exit();}
// run
$perPage = int_param($rawdata["per_page"] ?? 12, 12, 500);
$page = (max(1, int_param($rawdata["page"] ?? 1, 1)) - 1) * $perPage;
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
$video = isset($rawdata["video"]) ? mysqli_real_escape_string($db,$rawdata["video"]) : '';
$plan_img = isset($rawdata["plan_img"]) ? mysqli_real_escape_string($db,$rawdata["plan_img"]) : '';
$imgs = isset($rawdata["imgs"]) ? $rawdata["imgs"] : [];
$estate_status = isset($rawdata["estate_status"]) && $rawdata["estate_status"] != null ? mysqli_real_escape_string($db,$rawdata["estate_status"]) : '';
$status = isset($rawdata["status"]) && $rawdata["status"] != null ? mysqli_real_escape_string($db,$rawdata["status"]) : 'active';
$admin_review = isset($rawdata["admin_review"]) && $rawdata["admin_review"] != null ? mysqli_real_escape_string($db,$rawdata["admin_review"]) : '';


$is_furnished = isset($rawdata["is_furnished"]) ? mysqli_real_escape_string($db,$rawdata["is_furnished"]) : '';
$is_owner = isset($rawdata["is_owner"]) ? mysqli_real_escape_string($db,$rawdata["is_owner"]) : '';
$property_nature = isset($rawdata["property_nature"]) ? mysqli_real_escape_string($db,$rawdata["property_nature"]) : '';
$floor = isset($rawdata["floor"]) ? mysqli_real_escape_string($db,$rawdata["floor"]) : '';
$area_unit = isset($rawdata["area_unit"]) ? mysqli_real_escape_string($db,$rawdata["area_unit"]) : '';
$building_age = isset($rawdata["building_age"]) ? mysqli_real_escape_string($db,$rawdata["building_age"]) : '';
$is_mortgaged = isset($rawdata["is_mortgaged"]) ? mysqli_real_escape_string($db,$rawdata["is_mortgaged"]) : '';
$property_status = isset($rawdata["property_status"]) ? mysqli_real_escape_string($db,$rawdata["property_status"]) : '';
$designated_for = isset($rawdata["designated_for"]) ? mysqli_real_escape_string($db,$rawdata["designated_for"]) : '';
$facade = isset($rawdata["facade"]) ? mysqli_real_escape_string($db,$rawdata["facade"]) : '';
$rent_duration = isset($rawdata["rent_duration"]) ? mysqli_real_escape_string($db,$rawdata["rent_duration"]) : '';
$payment_method = isset($rawdata["payment_method"]) ? mysqli_real_escape_string($db,$rawdata["payment_method"]) : '';
$main_features = isset($rawdata["main_features"]) ? mysqli_real_escape_string($db,$rawdata["main_features"]) : '[]';
$internal_features = isset($rawdata["internal_features"]) ? mysqli_real_escape_string($db,$rawdata["internal_features"]) : '[]';
$appliances = isset($rawdata["appliances"]) ? mysqli_real_escape_string($db,$rawdata["appliances"]) : '[]';
$extra_features = isset($rawdata["extra_features"]) ? mysqli_real_escape_string($db,$rawdata["extra_features"]) : '[]';
$nearby_places = isset($rawdata["nearby_places"]) ? mysqli_real_escape_string($db,$rawdata["nearby_places"]) : '[]';




$size_min = isset($rawdata["size_min"]) ? mysqli_real_escape_string($db,$rawdata["size_min"]) : '';
$size_max = isset($rawdata["size_max"]) ? mysqli_real_escape_string($db,$rawdata["size_max"]) : '';
$price_min = isset($rawdata["price_min"]) ? mysqli_real_escape_string($db,$rawdata["price_min"]) : '';
$price_max = isset($rawdata["price_max"]) ? mysqli_real_escape_string($db,$rawdata["price_max"]) : '';

if (!isset($p[2]) || $p[2] == '') {
    echo json_encode(array("status" => 0));exit();
}elseif($p[2] == 'get_one'){
    get_one($id);
}elseif($p[2] == 'get_page'){
    get_page($page,$perPage,$id,$title,$purpose,$type,$bedrooms,$bathrooms,$garages,$city,$state,$estate_status,$status,$admin_review,$size_min,$size_max,$price_min,$price_max);
}elseif($p[2] == 'add'){
    add($title,$description,$purpose,$type,$price,$curr,$bedrooms,$bathrooms,$garages,$area_m2,$address,$city,$state,$location,$img,$video,$plan_img,$imgs,$estate_status,$status,$is_owner,$property_nature,$floor,$area_unit,$building_age,$is_mortgaged,$property_status,$designated_for,$facade,$rent_duration,$payment_method,$main_features,$internal_features,$appliances,$extra_features,$nearby_places,$is_furnished);
}elseif($p[2] == 'edit'){
    edit($id,$title,$description,$purpose,$type,$price,$curr,$bedrooms,$bathrooms,$garages,$area_m2,$address,$city,$state,$location,$img,$video,$plan_img,$imgs,$estate_status,$status,$is_owner,$property_nature,$floor,$area_unit,$building_age,$is_mortgaged,$property_status,$designated_for,$facade,$rent_duration,$payment_method,$main_features,$internal_features,$appliances,$extra_features,$nearby_places,$is_furnished);
}elseif($p[2] == 'remove'){
    remove($id);
}else{
    echo json_encode(array("status" => 0));exit();
}



// functions

// get one
function get_one($id){
    global $db,$auth;
    $uid = isset($auth['data']->id) ? $auth['data']->id : 0;
    $aid = mysqli_fetch_object(mysqli_query($db,"select id from agencies where owner_id='$uid'"))?->id;
    $qr1 = mysqli_query($db,"select * from properties where id='$id' and agency_id='$aid'");
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
            "is_furnished" => $qr->is_furnished,
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

            "is_owner" => $qr->is_owner,
            "property_nature" => $qr->property_nature,
            "floor" => $qr->floor,
            "area_unit" => $qr->area_unit != '' ? $qr->area_unit : 'sqm',
            "building_age" => $qr->building_age,
            "is_mortgaged" => $qr->is_mortgaged,
            "property_status" => $qr->property_status,
            "designated_for" => $qr->designated_for,
            "facade" => $qr->facade,
            "rent_duration" => $qr->rent_duration,
            "payment_method" => $qr->payment_method,
            "main_features" => $qr->main_features != '' ? json_decode($qr->main_features) : [],
            "internal_features" => $qr->internal_features != '' ? json_decode($qr->internal_features) : [],
            "appliances" => $qr->appliances != '' ? json_decode($qr->appliances) : [],
            "extra_features" => $qr->extra_features != '' ? json_decode($qr->extra_features) : [],
            "nearby_places" => $qr->nearby_places != '' ? json_decode($qr->nearby_places) : [],

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
function get_page($page,$perPage,$id,$title,$purpose,$type,$bedrooms,$bathrooms,$garages,$city,$state,$estate_status,$status,$admin_review,$size_min,$size_max,$price_min,$price_max){
    global $db,$auth;
    $uid = isset($auth['data']->id) ? $auth['data']->id : 0;
    $aid = mysqli_fetch_object(mysqli_query($db,"select id from agencies where owner_id='$uid'"))?->id;
    $data = array();

    $q_id = $id != 0 ? "id='$id' and " : "";
    $q_agency_id = $aid != 0 ? "agency_id='$aid' and " : "";
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
        $agency = mysqli_fetch_object(mysqli_query($db,"select owner_id,name,phone from agencies where id='$qr->agency_id'"));
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
            "is_furnished" => $qr->is_furnished,
            "is_new" => $qr->is_new,
            "address" => $qr->address,
            "city" => $qr->city,
            "state" => $qr->state,
            "location" => $qr->location != "[]" && $qr->location != '' ? json_decode($qr->location,true) : null,
            "img" => $qr->img,
            "video" => $qr->video,
            "imgs" => json_decode($qr->imgs),
            "plan_img" => $qr->plan_img,
            "reviews" => $qr->reviews,
            "rate" => $qr->rate,
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
function add($title,$description,$purpose,$type,$price,$curr,$bedrooms,$bathrooms,$garages,$area_m2,$address,$city,$state,$location,$img,$video,$plan_img,$imgs,$estate_status,$status,$is_owner,$property_nature,$floor,$area_unit,$building_age,$is_mortgaged,$property_status,$designated_for,$facade,$rent_duration,$payment_method,$main_features,$internal_features,$appliances,$extra_features,$nearby_places,$is_furnished){
    global $db,$auth;
    $uid = isset($auth['data']->id) ? $auth['data']->id : 0;
    $aid = mysqli_fetch_object(mysqli_query($db,"select id from agencies where owner_id='$uid'"))?->id;

    $imgs = mysqli_real_escape_string($db,json_encode($imgs,JSON_UNESCAPED_UNICODE));

    /*$main_features = json_encode($main_features,JSON_UNESCAPED_UNICODE);
    $internal_features = json_encode($internal_features,JSON_UNESCAPED_UNICODE);
    $appliances = json_encode($appliances,JSON_UNESCAPED_UNICODE);
    $extra_features = json_encode($extra_features,JSON_UNESCAPED_UNICODE);
    $nearby_places = json_encode($nearby_places,JSON_UNESCAPED_UNICODE);*/

    $auto_publish = mysqli_fetch_object(mysqli_query($db,"select auto_publish from settings where id='1'"))->auto_publish;
    $user_verify = mysqli_fetch_object(mysqli_query($db,"select verify from users where id='$uid'"))->verify;
    if($auto_publish == 'auto'){
        $admin_review = "approved";
    }elseif($auto_publish == 'only_verify'){
        if($user_verify == "yes"){$admin_review = "approved";}else{$admin_review = "pending";}
    }else{$admin_review = "pending";}


    $location = mysqli_real_escape_string($db,json_encode($location,true));
    mysqli_query($db,"insert into properties (agency_id,title,description,purpose,type,price,curr,bedrooms,bathrooms,garages,area_m2,address,city,state,location,img,video,plan_img,imgs,estate_status,status,is_owner,property_nature,floor,area_unit,building_age,is_mortgaged,property_status,designated_for,facade,rent_duration,payment_method,main_features,internal_features,appliances,extra_features,nearby_places,is_furnished,admin_review) 
                            values ('$aid','$title','$description','$purpose','$type','$price','$curr','$bedrooms','$bathrooms','$garages','$area_m2','$address','$city','$state','$location','$img','$video','$plan_img','$imgs','$estate_status','$status','$is_owner','$property_nature','$floor','$area_unit','$building_age','$is_mortgaged','$property_status','$designated_for','$facade','$rent_duration','$payment_method','$main_features','$internal_features','$appliances','$extra_features','$nearby_places','$is_furnished','$admin_review')");
    log_ads('add',mysqli_insert_id($db));
    $res = array(
        "status" => 1,
        "data" => ""
    );
    echo json_encode($res);exit();
}
// edit
function edit($id,$title,$description,$purpose,$type,$price,$curr,$bedrooms,$bathrooms,$garages,$area_m2,$address,$city,$state,$location,$img,$video,$plan_img,$imgs,$estate_status,$status,$is_owner,$property_nature,$floor,$area_unit,$building_age,$is_mortgaged,$property_status,$designated_for,$facade,$rent_duration,$payment_method,$main_features,$internal_features,$appliances,$extra_features,$nearby_places,$is_furnished){
    global $db,$auth;
    $uid = isset($auth['data']->id) ? $auth['data']->id : 0;
    $aid = mysqli_fetch_object(mysqli_query($db,"select id from agencies where owner_id='$uid'"))?->id;
    $is_owner_agency = $aid ? mysqli_num_rows(mysqli_query($db,"select id from properties where id='$id' and agency_id='$aid'")) : 0;
    if($is_owner_agency == 0){echo json_encode(array("status" => 0));exit();}

    $imgs = mysqli_real_escape_string($db,json_encode($imgs,JSON_UNESCAPED_UNICODE));

    /*$main_features = json_encode($main_features,JSON_UNESCAPED_UNICODE);
    $internal_features = json_encode($internal_features,JSON_UNESCAPED_UNICODE);
    $appliances = json_encode($appliances,JSON_UNESCAPED_UNICODE);
    $extra_features = json_encode($extra_features,JSON_UNESCAPED_UNICODE);
    $nearby_places = json_encode($nearby_places,JSON_UNESCAPED_UNICODE);*/

    $location = mysqli_real_escape_string($db,json_encode($location,true));
    mysqli_query($db,"update properties set agency_id='$aid',title='$title',description='$description',purpose='$purpose',type='$type',
                            price='$price',curr='$curr',bedrooms='$bedrooms',bathrooms='$bathrooms',garages='$garages',area_m2='$area_m2',address='$address',city='$city',state='$state',
                            location='$location',img='$img',video='$video',plan_img='$plan_img',imgs='$imgs',estate_status='$estate_status',status='$status',
                            is_owner='$is_owner',property_nature='$property_nature',floor='$floor',area_unit='$area_unit',building_age='$building_age',is_mortgaged='$is_mortgaged',property_status='$property_status',designated_for='$designated_for',facade='$facade',rent_duration='$rent_duration',payment_method='$payment_method',main_features='$main_features',internal_features='$internal_features',appliances='$appliances',extra_features='$extra_features',nearby_places='$nearby_places',is_furnished='$is_furnished'
                            where id='$id' and agency_id='$aid'");
    log_ads('edit',$id);
    echo json_encode(array("status" => 1));exit();
}
// remove
function remove($id){
    global $db,$auth;
    $uid = isset($auth['data']->id) ? $auth['data']->id : 0;
    $aid = mysqli_fetch_object(mysqli_query($db,"select id from agencies where owner_id='$uid'"))?->id;
    log_ads('remove',$id);
    mysqli_query($db,"delete from properties where id='$id' and agency_id='$aid'");
    $res = array("status" => 1);
    echo json_encode($res);exit();
}

function log_ads($type,$id){
    global $db,$auth;
    $uid = isset($auth['data']->id) ? $auth['data']->id : 0;
    $agency = mysqli_fetch_object(mysqli_query($db,"select id,name from agencies where owner_id='$uid'"));
    $aid = $agency->id;
    $agency_name = $agency->name;
    $ads = mysqli_fetch_object(mysqli_query($db,"select title from properties where id='$id'"))?->title;
    if($type == "add"){
        $msg = "قام المكتب : ".$agency_name." بإضافة إعلان بعنوان : ".$ads;
        telegram_sender($msg);
    }elseif($type == "edit"){
        $msg = "قام المكتب : ".$agency_name." بتعديل على إعلان بعنوان : ".$ads;
    }elseif($type == "remove"){
        $msg = "قام المكتب : ".$agency_name." بحذف إعلان بعنوان : ".$ads;
    }
    $msg = mysqli_real_escape_string($db,$msg);
    mysqli_query($db,"insert into logs_agencies (agency_id,content) values ('$aid','$msg')");
}