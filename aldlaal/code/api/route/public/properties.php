<?php
if(!isset($fp)){echo json_encode(array("status" => 0));exit();}
// run
$page = isset($rawdata["page"]) ? mysqli_real_escape_string($db, $rawdata["page"]) : 1;
$uuid = isset($rawdata["uuid"]) && $rawdata["uuid"] != null ? mysqli_real_escape_string($db,$rawdata["uuid"]) : '';
$id = isset($rawdata["id"]) && $rawdata["id"] != null ? mysqli_real_escape_string($db,$rawdata["id"]) : 0;
$agency_id = isset($rawdata["agency_id"]) && $rawdata["agency_id"] != null ? mysqli_real_escape_string($db,$rawdata["agency_id"]) : 0;
$title = isset($rawdata["title"]) ? mysqli_real_escape_string($db,$rawdata["title"]) : '';
$description = isset($rawdata["description"]) ? mysqli_real_escape_string($db,$rawdata["description"]) : '';
$purpose = isset($rawdata["purpose"]) && $rawdata["purpose"] != null ? mysqli_real_escape_string($db,$rawdata["purpose"]) : '';
$type = isset($rawdata["type"]) && $rawdata["type"] != null ? mysqli_real_escape_string($db,$rawdata["type"]) : '';
$is_furnished = isset($rawdata["is_furnished"]) && $rawdata["is_furnished"] != null ? mysqli_real_escape_string($db,$rawdata["is_furnished"]) : '';
$is_new = isset($rawdata["is_new"]) && $rawdata["is_new"] != null ? mysqli_real_escape_string($db,$rawdata["is_new"]) : '';
$price = isset($rawdata["price"]) ? mysqli_real_escape_string($db,$rawdata["price"]) : '';
$bedrooms = isset($rawdata["bedrooms"]) && $rawdata["bedrooms"] != null && $rawdata["bedrooms"] != null ? mysqli_real_escape_string($db,$rawdata["bedrooms"]) : 0;
$bathrooms = isset($rawdata["bathrooms"]) && $rawdata["bathrooms"] != null && $rawdata["bathrooms"] != null ? mysqli_real_escape_string($db,$rawdata["bathrooms"]) : 0;
$garages = isset($rawdata["garages"]) && $rawdata["garages"] != null && $rawdata["garages"] != null ? mysqli_real_escape_string($db,$rawdata["garages"]) : 0;
$area_m2 = isset($rawdata["area_m2"]) ? mysqli_real_escape_string($db,$rawdata["area_m2"]) : '';
$address = isset($rawdata["address"]) ? mysqli_real_escape_string($db,$rawdata["address"]) : '';
$city = isset($rawdata["city"]) && $rawdata["city"] != null ? mysqli_real_escape_string($db,$rawdata["city"]) : '';
$state = isset($rawdata["state"]) && $rawdata["state"] != null ? mysqli_real_escape_string($db,$rawdata["state"]) : '';
$location = isset($rawdata["location"]) && $rawdata["location"] != null ? $rawdata["location"] : [];
$img = isset($rawdata["img"]) ? mysqli_real_escape_string($db,$rawdata["img"]) : '';
$imgs = isset($rawdata["imgs"]) ? $rawdata["imgs"] : [];
$estate_status = isset($rawdata["estate_status"]) && $rawdata["estate_status"] != null ? mysqli_real_escape_string($db,$rawdata["estate_status"]) : '';
$status = isset($rawdata["status"]) && $rawdata["status"] != null ? mysqli_real_escape_string($db,$rawdata["status"]) : 'active';
$admin_review = isset($rawdata["admin_review"]) && $rawdata["admin_review"] != null ? mysqli_real_escape_string($db,$rawdata["admin_review"]) : '';

$search = isset($rawdata["search"]) ? mysqli_real_escape_string($db,$rawdata["search"]) : '';
$sort = isset($rawdata["sort"]) ? mysqli_real_escape_string($db,$rawdata["sort"]) : '';
$size_min = isset($rawdata["size_min"]) ? mysqli_real_escape_string($db,$rawdata["size_min"]) : '';
$size_max = isset($rawdata["size_max"]) ? mysqli_real_escape_string($db,$rawdata["size_max"]) : '';
$price_min = isset($rawdata["price_min"]) ? mysqli_real_escape_string($db,$rawdata["price_min"]) : '';
$price_max = isset($rawdata["price_max"]) ? mysqli_real_escape_string($db,$rawdata["price_max"]) : '';
$date_filter = isset($rawdata["date_filter"]) ? mysqli_real_escape_string($db,$rawdata["date_filter"]) : '';




if (!isset($p[2]) || $p[2] == '') {
    echo json_encode(array("status" => 0));exit();
}elseif($p[2] == 'get_all'){
    get_all($page,$sort,$search,$purpose,$type,$bedrooms,$bathrooms,$garages,$city,$state,$estate_status,$size_min,$size_max,$price_min,$price_max,$is_furnished,$is_new,$agency_id,$date_filter);
}elseif($p[2] == 'get_one'){
    get_one($id);
}elseif($p[2] == 'get_history'){
    get_history($uuid);
}elseif($p[2] == 'add_history'){
    add_history($uuid,$id);
}elseif($p[2] == 'clear_history'){
    clear_history($uuid);
}elseif($p[2] == 'get_map'){
    get_map($search,$purpose,$type,$bedrooms,$bathrooms,$garages,$city,$state,$estate_status,$size_min,$size_max,$price_min,$price_max,$is_furnished,$is_new,$date_filter);
}else{
    echo json_encode(array("status" => 0));exit();
}


// functions

function get_all($page,$sort,$search,$purpose,$type,$bedrooms,$bathrooms,$garages,$city,$state,$estate_status,$size_min,$size_max,$price_min,$price_max,$is_furnished,$is_new,$agency_id,$date_filter){
    global $db,$auth;
    $data = [];
    $perPage=10;
    $page = ($page-1)*$perPage;

    if($search != ''){
        $qq = explode(' ', $search);
        $search_str = implode(' OR ', array_map(function($word) {
            return "title LIKE '%$word%'";
        }, $qq));
        $search_str = "and (".$search_str.")";
    }else{$search_str = "";}


    $q_purpose = $purpose != '' ? "purpose='$purpose' and " : "";
    $q_type = $type != '' ? "type='$type' and " : "";
    $q_is_furnished = $is_furnished != '' ? "is_furnished='$is_furnished' and " : "";
    $q_is_new = $is_new != '' ? "is_new='$is_new' and " : "";
    $q_bedrooms = $bedrooms != 0 ? "bedrooms='$bedrooms' and " : "";
    $q_bathrooms = $bathrooms != 0 ? "bathrooms='$bathrooms' and " : "";
    $q_garages = $garages != 0 ? "garages='$garages' and " : "";
    $q_city = $city != '' ? "city='$city' and " : "";
    $q_state = $state != '' ? "state='$state' and " : "";
    $q_estate_status = $estate_status != '' ? "estate_status='$estate_status' and " : "";
    $q_size_min = $size_min == "" ? "":"area_m2 >= '$size_min' and ";
    $q_size_max = $size_max == "" ? "":"area_m2 <= '$size_max' and ";
    $q_price_min = $price_min == "" ? "":"price >= '$price_min' and ";
    $q_price_max = $price_max == "" ? "":"price <= '$price_max' and ";
    $q_agency_id = $agency_id == 0 ? "":"agency_id = '$agency_id' and ";

    if($date_filter != null && $date_filter != ''){
        if($date_filter == 'last_7d'){
            $q_date_filter = "create_at >= CURDATE() - INTERVAL 7 DAY and ";
        }elseif($date_filter == 'last_30d'){
            $q_date_filter = "create_at >= CURDATE() - INTERVAL 30 DAY and ";
        }elseif($date_filter == 'all'){
            $q_date_filter = "";
        }
    }else{$q_date_filter = "";}

    if($q_purpose == "" && $q_type == "" && $q_is_furnished == "" && $q_is_new == "" && $q_bedrooms == "" && $q_bathrooms == "" && $q_garages == "" && $q_city == "" && $q_state == "" && $q_estate_status == "" && $q_size_min == "" && $q_size_max == "" && $q_price_min == "" && $q_price_max == "" && $q_agency_id == "" && $q_date_filter){
        $str = "";
    }else{
        $str = "and ".$q_purpose.$q_type.$q_is_furnished.$q_is_new.$q_bedrooms.$q_bathrooms.$q_garages.$q_city.$q_state.$q_estate_status.$q_size_min.$q_size_max.$q_price_min.$q_price_max.$q_agency_id.$q_date_filter;
        $str = substr($str, 0, -5);
    }

    if($sort == 'price_min'){
        $order_by = "order by price asc";
    }elseif($sort == 'price_max'){
        $order_by = "order by price desc";
    }elseif($sort == 'new'){
        $order_by = "order by id desc";
    }else{
        $order_by = "order by id desc";
    }

    $qr1 = mysqli_query($db,"select * from properties where status='active' and admin_review='approved' $str $search_str $order_by limit $page,$perPage");

    while ($qr = mysqli_fetch_object($qr1)){
        $agency = mysqli_fetch_object(mysqli_query($db,"select owner_id,phone,name from agencies where id='$qr->agency_id'"));

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

function get_one($id){
    global $db,$auth;
    if($auth['valid'] == 1){
        $uid = $auth['data']->id;
        $aid = mysqli_fetch_object(mysqli_query($db,"select id from agencies where owner_id='$uid'"))?->id;
    }else{$aid = 0;}
    $qr1 = mysqli_query($db,"select * from properties where id='$id' and status='active' and (admin_review='approved' || agency_id='$aid')");
    if(mysqli_num_rows($qr1) != 0){
        $qr = mysqli_fetch_object($qr1);
        $agency = mysqli_fetch_object(mysqli_query($db,"select owner_id,name,phone,img,rate,reviews from agencies where id='$qr->agency_id'"));

        if($auth['valid'] == 1){
            $uid = $auth['data']->id;
            $is_fav = mysqli_num_rows(mysqli_query($db,"select * from favorites where property_id='$id' and user_id='$uid'"));
        }else{
            $is_fav = 0;
        }

        $user_verify = mysqli_fetch_object(mysqli_query($db,"select verify from users where id='$agency->owner_id'"))?->verify;

        $total = 0;
        $total_rate = 0;
        $qr_rate = mysqli_query($db,"select rate from reviews where agency_id='$qr->agency_id'");
        while ($rates = mysqli_fetch_object($qr_rate)){
            $total_rate = $total_rate+$rates->rate;
            $total = $total+1;
        }

        $data = array(
            "id" => $qr->id,
            "agency_id" => $qr->agency_id ?? 0,
            "owner_id" => $agency->owner_id ?? 0,
            "phone" => $agency->phone ?? 0,
            "agency" => $agency->name != '' ? $agency->name : '',
            "agency_img" => $agency->img != '' ? $agency->img : '',
            "user_verify" => $user_verify != '' ? $user_verify : 'no',
            "agency_reviews" => number_format($agency->reviews),
            "agency_rate" => $agency->rate,

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
            "is_fav" => $is_fav,
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

function get_history($uuid){
    global $db,$auth;
    $data = [];
    if($auth['valid'] == 1){
        $uid = $auth['data']->id;
        $qr1 = mysqli_query($db,"select * from search_recent where user_id='$uid' order by id desc limit 20");
    }else{

        $qr1 = mysqli_query($db,"select * from search_recent where uuid='$uuid' order by id desc limit 20");
    }
    while ($qq = mysqli_fetch_object($qr1)){
        $qr = mysqli_fetch_object(mysqli_query($db,"select * from properties where id='$qq->ads_id'"));
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
            "location" => json_decode($qr->location,true),
            "img" => $qr->img,
            "plan_img" => $qr->plan_img,
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

function add_history($uuid,$id){
    global $db,$auth;
    if($auth['valid'] == 1){
        $uid = $auth['data']->id;
        mysqli_query($db, "DELETE FROM search_recent WHERE user_id='$uid' AND ads_id='$id'");
        mysqli_query($db,"insert into search_recent (user_id,ads_id) values ('$uid','$id')");
        mysqli_query($db, "DELETE FROM search_recent WHERE user_id='$uid' AND id NOT IN (SELECT id FROM (SELECT id FROM search_recent WHERE user_id='$uid' ORDER BY id DESC LIMIT 20) AS t)");
    }else{
        mysqli_query($db, "DELETE FROM search_recent WHERE uuid='$uuid' AND ads_id='$id'");
        mysqli_query($db,"insert into search_recent (uuid,ads_id) values ('$uuid','$id')");
        mysqli_query($db, "DELETE FROM search_recent WHERE uuid='$uuid' AND id NOT IN (SELECT id FROM (SELECT id FROM search_recent WHERE uuid='$uuid' ORDER BY id DESC LIMIT 20) AS t)");
    }
    echo json_encode(array("status" => 1));exit();
}

function clear_history($uuid){
    global $db,$auth;
    if($auth['valid'] == 1){
        $uid = $auth['data']->id;
        mysqli_query($db,"delete from search_recent where user_id='$uid'");
    }else{
        mysqli_query($db,"delete from search_recent where uuid='$uuid'");
    }
    echo json_encode(array("status" => 1));exit();
}


function get_map($search,$purpose,$type,$bedrooms,$bathrooms,$garages,$city,$state,$estate_status,$size_min,$size_max,$price_min,$price_max,$is_furnished,$is_new,$date_filter){
    global $db,$auth;
    $data = [];
    $perPage=250;

    if($search != ''){
        $qq = explode(' ', $search);
        $search_str = implode(' OR ', array_map(function($word) {
            return "title LIKE '%$word%'";
        }, $qq));
        $search_str = "and (".$search_str.")";
    }else{$search_str = "";}


    $q_purpose = $purpose != '' ? "purpose='$purpose' and " : "";
    $q_type = $type != '' ? "type='$type' and " : "";
    $q_is_furnished = $is_furnished != '' ? "is_furnished='$is_furnished' and " : "";
    $q_is_new = $is_new != '' ? "is_new='$is_new' and " : "";
    $q_bedrooms = $bedrooms != 0 ? "bedrooms='$bedrooms' and " : "";
    $q_bathrooms = $bathrooms != 0 ? "bathrooms='$bathrooms' and " : "";
    $q_garages = $garages != 0 ? "garages='$garages' and " : "";
    $q_city = $city != '' ? "city='$city' and " : "";
    $q_state = $state != '' ? "state='$state' and " : "";
    $q_estate_status = $estate_status != '' ? "estate_status='$estate_status' and " : "";
    $q_size_min = $size_min == "" ? "":"area_m2 >= '$size_min' and ";
    $q_size_max = $size_max == "" ? "":"area_m2 <= '$size_max' and ";
    $q_price_min = $price_min == "" ? "":"price >= '$price_min' and ";
    $q_price_max = $price_max == "" ? "":"price <= '$price_max' and ";

    if($date_filter != null && $date_filter != ''){
        if($date_filter == 'last_7d'){
            $q_date_filter = "create_at >= CURDATE() - INTERVAL 7 DAY and ";
        }elseif($date_filter == 'last_30d'){
            $q_date_filter = "create_at >= CURDATE() - INTERVAL 30 DAY and ";
        }elseif($date_filter == 'all'){
            $q_date_filter = "";
        }
    }else{$q_date_filter = "";}

    if($q_purpose == "" && $q_type == "" && $q_is_furnished == "" && $q_is_new == "" && $q_bedrooms == "" && $q_bathrooms == "" && $q_garages == "" && $q_city == "" && $q_state == "" && $q_estate_status == "" && $q_size_min == "" && $q_size_max == "" && $q_price_min == "" && $q_price_max == "" && $q_date_filter == ""){
        $str = "";
    }else{
        $str = "and ".$q_purpose.$q_type.$q_is_furnished.$q_is_new.$q_bedrooms.$q_bathrooms.$q_garages.$q_city.$q_state.$q_estate_status.$q_size_min.$q_size_max.$q_price_min.$q_price_max.$q_date_filter;
        $str = substr($str, 0, -5);
    }

    $qr1 = mysqli_query($db,"select * from properties where status='active' and admin_review='approved' and location != '[]' and location != '' $str $search_str order by id desc limit $perPage");

    while ($qr = mysqli_fetch_object($qr1)){
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
            "location" => $qr->location != "[]" && $qr->location != '' ? json_decode($qr->location,true) : null,
            "img" => $qr->img,
            "plan_img" => $qr->plan_img,
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
