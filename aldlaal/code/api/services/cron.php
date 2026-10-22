<?php
if(!isset($fp)){echo json_encode(array("status" => 0));exit();}

// when $cron_key is set in config.php, the cron URL must be /cron/autorun/<cron_key>
if(isset($cron_key) && $cron_key != '' && (!isset($p[2]) || !hash_equals($cron_key, $p[2]))){
    echo json_encode(array("status" => 0));exit();
}

if (!isset($p[1]) || $p[1] == '') {
    echo json_encode(array("status" => 0));exit();
}elseif($p[1] == 'autorun'){
    autorun();
}else{
    echo json_encode(array("status" => 0));exit();
}

// functions
function autorun(){

    send_notifications();
    echo json_encode(array("status" => 1));exit();
}

function send_notifications(){
    global $db;
    $current_hour = (int)date('H');
    if ($current_hour >= 9) {
        $qr1 = mysqli_query($db, "SELECT * FROM search_favorites WHERE update_at < NOW() - INTERVAL 20 HOUR");
        while($qr = mysqli_fetch_object($qr1)){

            $id = intval($qr->id);
            $uid = intval($qr->user_id);
            $count = intval($qr->count);
            $sql_qeury = $qr->search_query;
            $notification_email = $qr->notification_email;
            $notification_app = $qr->notification_app;

            if($sql_qeury == ''){
                $sql_qeury = "WHERE status='active' and admin_review='approved' and update_at < NOW() - INTERVAL 24 HOUR limit 10";
            }else{
                $sql_qeury = "WHERE $sql_qeury and status='active' and admin_review='approved' and update_at < NOW() - INTERVAL 20 HOUR limit 10";
            }
            $ads_qr1 = mysqli_query($db, "SELECT * FROM properties $sql_qeury");
            $ads_row = mysqli_num_rows($ads_qr1);
            if($ads_row > 0){
                $ads = [];
                while($ads_qr = mysqli_fetch_object($ads_qr1)){
                    $ads[] = array(
                        "id" => intval($ads_qr->id),
                        "title" => $ads_qr->title,
                        "price" => $ads_qr->price,
                        "bedrooms" => $ads_qr->bedrooms,
                        "bathrooms" => $ads_qr->bathrooms,
                        "garages" => $ads_qr->garages,
                        "area_m2" => $ads_qr->area_m2,
                        "city" => $ads_qr->city,
                        "state" => $ads_qr->state,
                        "img" => $ads_qr->img,
                    );
                }

                // send notication
                if($notification_email == 1){

                }
                if($notification_app == 1){
                    sendNotification($uid,'عقارات جديدة مطابقة لبحثك','تمت إضافة '.$ads_row.' عقار، وهي مطابقة لبحثك.','New properties matching your search',$ads_row.' properties have been added, And they match your search','/ads/ads',$id);
                }
            }
            $rnd = random_int(1000,9999);
            $count = $count+$ads_row;
            mysqli_query($db,"UPDATE search_favorites SET count='$count',rnd='$rnd' WHERE id='$id'");
        }
    }
    return true;
}

function auto_clear_search(){
    global $db;
    mysqli_query($db, "delete from search_recent where create_at > NOW() - INTERVAL 60 DAY");
    return true;
}