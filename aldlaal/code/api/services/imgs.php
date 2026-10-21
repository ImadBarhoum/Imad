<?php
if(!isset($fp)){echo json_encode(array("status" => 0));exit();}
// run
isset($rawdata["img_name"]) ? $img_name = $rawdata["img_name"] : $img_name = '';

if(!isset($p[1]) || $p[1] == ''){
    echo json_encode(array("status" => 0));exit();
}elseif($p[1] == 'save' && $auth["valid"] == 1){
    save_img($img_name);
}else{
    echo json_encode(array("status" => 0));exit();
}





// functions

function save_img($img){
    global $db;
    if($img == ''){echo json_encode(array("status" => 0));exit();}
    $yearMonth = date('Y-m');

    $name = time()."_".rand(1000,9999);
    $img_name = convertImage($img,$yearMonth,$name,'sm');
    convertImage($img,$yearMonth,$name,'md');
    convertImage($img,$yearMonth,$name,'lg');

    $res = array(
        "status" => 1,
        "img_name" => $yearMonth.'/'.$img_name
    );
    echo json_encode($res);exit();
}

function convertImage($img,$yearMonth,$name,$size){
    $file_type = exif_imagetype($img);

    if ($file_type === IMAGETYPE_GIF) {
        if ($size == 'sm') {
            $folder = 'sm/' . $yearMonth;
        } elseif ($size == 'md') {
            $folder = 'md/' . $yearMonth;
        } elseif ($size == 'lg') {
            $folder = 'lg/' . $yearMonth;
        }
        $path = 'uploads/imgs/'.$folder;
        if (!is_dir($path)) {mkdir($path, 0755, true);}
        $name = $name.'.gif';
        copy($img, $path."/".$name);
        return $name;
    }

    $name = $name.".webp";
    if (function_exists('imagewebp')){
        switch ($file_type) {
            case IMAGETYPE_GIF:
                $image = imagecreatefromgif($img);
                break;
            case IMAGETYPE_JPEG:
                $image = imagecreatefromjpeg($img);
                break;
            case IMAGETYPE_PNG:
                $image = imagecreatefrompng($img);
                imagepalettetotruecolor($image);
                imagealphablending($image, true);
                imagesavealpha($image, true);
                break;
            case IMAGETYPE_BMP:
                $image = imagecreatefrombmp($img);
                break;
            case IMAGETYPE_WEBP:
                $image = imagecreatefromwebp($img);
                break;
            case IMAGETYPE_XBM:
                $image = imagecreatefromxbm($img);
                break;
            default:
                return false;
        }
        list($org_width, $org_height) = getimagesize($img);

        if($size == 'sm'){
            $folder = 'sm/'.$yearMonth;
            $new_width = 200;
            //$new_height = 120;
            $new_height = ($new_width*$org_height)/$org_width;
        }elseif($size == 'md'){
            $folder = 'md/'.$yearMonth;
            $new_width = 450;
            //$new_height = 300;
            $new_height = ($new_width*$org_height)/$org_width;
        }elseif($size == 'lg'){
            $folder = 'lg/'.$yearMonth;
            if($org_width < 1200){
                $new_width = $org_width;
                //$new_height = (3/4)*$new_width;
                $new_height = ($new_width*$org_height)/$org_width;
            }else{
                $new_width = 1200;
                //$new_height = 900;
                $new_height = ($new_width*$org_height)/$org_width;
            }
        }
        $new_img = imagecreatetruecolor($new_width, $new_height);

        if ($file_type == IMAGETYPE_PNG || $file_type == IMAGETYPE_WEBP || $file_type == IMAGETYPE_GIF) {
            imagealphablending($new_img, false);
            imagesavealpha($new_img, true);
            $transparent = imagecolorallocatealpha($new_img, 0, 0, 0, 127);
            imagefill($new_img, 0, 0, $transparent);
        } else {
            $bwhite = imagecolorallocate($new_img, 255, 255, 255);
            imagefill($new_img, 0, 0, $bwhite);
        }

        imagecopyresampled($new_img, $image, 0, 0, 0, 0, $new_width, $new_height, $org_width, $org_height);
        $path = 'uploads/imgs/'.$folder;
        if (!is_dir($path)) {mkdir($path, 0755, true);}
        imagewebp($new_img, $path."/".$name, 80);
        imagedestroy($image);
        imagedestroy($new_img);
        return $name;
    }
}
