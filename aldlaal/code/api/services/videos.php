<?php
if(!isset($fp)){echo json_encode(array("status" => 0));exit();}
// run
isset($rawdata["video"]) ? $video = $rawdata["video"] : $video = '';

if(!isset($p[1]) || $p[1] == ''){
    echo json_encode(array("status" => 0));exit();
}elseif($p[1] == 'save'){
    save($video);
}else{
    echo json_encode(array("status" => 0));exit();
}





// functions

function save($video){
    if($video == ''){echo json_encode(array("status" => 0));exit();}
    $res = saveBase64Video($video);
    if($res['success']){
        $res = array(
            "status" => 1,
            "video_name" => $res['video_name']
        );
    }else{
        $res = array("status" => 0);
    }
    echo json_encode($res);exit();
}

function saveBase64Video($base64Data, $uploadDir = 'uploads/videos/', $fileName = null) {
    $yearMonth = date('Y-m');
    $uploadDir = $uploadDir."/".$yearMonth."/";
    // Validate base64 data format
    if (!preg_match('/^data:video\/(\w+);base64,/', $base64Data, $matches)) {
        return ['success' => false, 'error' => 'Invalid base64 video format'];
    }

    // Extract video type and data
    $videoType = $matches[1];
    $base64Data = substr($base64Data, strpos($base64Data, ',') + 1);
    $decodedData = base64_decode($base64Data, true);

    // Check if decoding succeeded
    if ($decodedData === false) {
        return ['success' => false, 'error' => 'Base64 decoding failed'];
    }

    // Validate video content
    $finfo = new finfo(FILEINFO_MIME_TYPE);
    $mimeType = $finfo->buffer($decodedData);

    $allowedTypes = [
        'mp4' => 'video/mp4',
        'mov' => 'video/quicktime',
        'avi' => 'video/x-msvideo',
        'webm' => 'video/webm'
    ];

    if (!in_array($mimeType, $allowedTypes)) {
        return ['success' => false, 'error' => 'Invalid video format'];
    }

    // Create upload directory if it doesn't exist
    if (!is_dir($uploadDir)) {
        if (!mkdir($uploadDir, 0755, true)) {
            return ['success' => false, 'error' => 'Failed to create directory'];
        }
    }

    // Generate filename if not provided
    $extension = array_search($mimeType, $allowedTypes);
    $fileName = $fileName ?: uniqid('video_') . '.' . $extension;
    $filePath = $uploadDir . $fileName;

    // Save the file
    if (file_put_contents($filePath, $decodedData) === false) {
        return ['success' => false, 'error' => 'Failed to save video'];
    }

    return [
        'success' => true,
        'video_name' => $yearMonth."/".$fileName,
        'size' => strlen($decodedData)/1000,
        'mime_type' => $mimeType
    ];
}