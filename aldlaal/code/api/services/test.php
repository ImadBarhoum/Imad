<?php
if(!isset($fp)){echo json_encode(array("status" => 0));exit();}


//sendNotification('4','AdeL','TEST 1','AdeL','TEST 2','/chat',1);
//migrate_users_to_agency();

function migrate_users_to_agency(){
    global $db;
    $qr1 = mysqli_query($db,"select * from users");
    while($qr = mysqli_fetch_object($qr1)){
        $rr = mysqli_num_rows(mysqli_query($db,"select * from agencies where email='$qr->email'"));
        if($rr == 0){
            mysqli_query($db,"insert into agencies (id,owner_id,name,email,phone,description,address,city,state,img) values ('$qr->id','$qr->id','$qr->name','$qr->email','$qr->phone','','','$qr->city','$qr->state','')");
        }
    }

    $agency_list=[];
    $qr2 = mysqli_query($db,"select * from agencies");
    while($qr0 = mysqli_fetch_object($qr2)){$agency_list[] = $qr0->owner_id;}

    $qr1 = mysqli_query($db,"select * from users");
    while($qr = mysqli_fetch_object($qr1)){if(!in_array($qr->id,$agency_list)){mysqli_query($db,"delete from users where id='$qr->id'");}}

    //$qr3 = mysqli_query($db,"select owner_id from agencies");
    //while ($qrr = mysqli_fetch_object($qr3)){mysqli_query($db,"update agencies set id='$qrr->owner_id' where owner_id='$qrr->owner_id'");}
}
