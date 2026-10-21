<?php
function get_ads($id){
    global $db,$domain,$path,$ssl;
    $qr1 = mysqli_query($db,"select * from properties where id='$id' and status='active' and admin_review='approved'");
    if(mysqli_num_rows($qr1) != 0){
        $qr = mysqli_fetch_object($qr1);
        $data = array(
            "id" => $qr->id,
            "title" => "Aldlaal Syria - ".$qr->title,
            "description" => "Aldlaal Syria - الدلال سوريا - ".$qr->title,
            "img" => $ssl.$domain.$path."/api/uploads/imgs/md/".$qr->img,
            "url" => $ssl.$domain.$path."/api/link/".$id
        );
    }else{
        $data = array(
            "id" => 0,
            "title" => "Aldlaal Syria",
            "description" => "Aldlaal Syria - الدلال سوريا",
            "img" => $ssl.$domain.$path."/api/uploads/src/og.png",
            "url" => $ssl.$domain.$path."/api/link"
        );
    }
    return $data;
}
function getDeviceType() {
    $userAgent = strtolower($_SERVER['HTTP_USER_AGENT']);
    if (strpos($userAgent, 'android') !== false) {
        return 'android';
    } elseif (strpos($userAgent, 'iphone') !== false || strpos($userAgent, 'ipad') !== false || strpos($userAgent, 'ipod') !== false) {
        return 'ios';
    } else {
        return 'web';
    }
}

$id = isset($p[1]) ? mysqli_real_escape_string($db,$p[1]) : 0;
$data = get_ads($id);
$device = getDeviceType();
header('Content-Type: text/html; charset=utf-8');
?>
<html lang="ar">
<head>
    <meta charset="UTF-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title><?php echo $data['title'];?></title>
    <link rel="shortcut icon" type="image/x-icon" href="<?php echo $ssl.$domain.$path."/api/uploads/src/fav.png";?>">
    <link rel="canonical" href="<?php echo $ssl.$domain;?>"/>
    <meta name="description" content="<?php echo $data['description'];?>">
    <meta property="og:url" content="<?php echo $ssl.$domain;?>">
    <meta property="og:type" content="website">
    <meta property="og:title" content="<?php echo $data['title'];?>">
    <meta property="og:description" content="<?php echo $data['description'];?>">
    <meta property="og:image" content="<?php echo $data['img'];?>">
    <meta name="twitter:card" content="summary_large_image">
    <meta property="twitter:domain" content="<?php echo $ssl.$domain;?>">
    <meta property="twitter:url" content="<?php echo $data['url'];?>">
    <meta name="twitter:title" content="<?php echo $data['title'];?>">
    <meta name="twitter:description" content="<?php echo $data['description'];?>">
    <meta name="twitter:image" content="<?php echo $data['img'];?>">
</head>
</html>
<script type="text/javascript">
    const deviceType = "<?php echo $device; ?>";
    const playStoreUrl = "https://play.google.com/store/apps/details?id=com.aldlaal.app";
    const appleStoreUrl = "https://apps.apple.com/app/6753634087";
    const customWebUrl = "<?php echo $ssl.$domain.$path; ?>";
    setTimeout(function() {
        let targetUrl;
        switch (deviceType) {
            case 'android':
                targetUrl = playStoreUrl;
                break;
            case 'ios':
                targetUrl = appleStoreUrl;
                break;
            case 'web':
            default:
                targetUrl = customWebUrl;
                break;
        }
        window.location.href = targetUrl;
    }, 1000);
</script>