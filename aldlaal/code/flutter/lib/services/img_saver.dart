import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'api_service.dart';

class ImageSaver{

  Future<String?> Save() async{
    String? base64Image = await pickCompressAndConvertToBase64();
    if (base64Image != null) {
      var res = await apiService('/img/save', {'img_name':base64Image},timeout: 120);
      if(res != null && res['status'] == 1){
        return res['img_name'];
      }else{return null;}
    } else {return null;}
  }

  Future<String?> pickCompressAndConvertToBase64() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) {return null;}

    String mimeType = '';
    if (pickedFile.path.endsWith('.jpg') || pickedFile.path.endsWith('.jpeg')) {mimeType = 'image/jpeg';}
    else if (pickedFile.path.endsWith('.png')) {mimeType = 'image/png';}
    else if (pickedFile.path.endsWith('.webp')) {mimeType = 'image/webp';}

    final compressedImage = await compressImage(File(pickedFile.path));
    if (compressedImage == null) {return null;}

    final imageBytes = await compressedImage.readAsBytes();
    String base64Image = base64Encode(imageBytes);

    return 'data:$mimeType;base64,$base64Image';
  }

  Future<XFile?> compressImage(File file) async {
    final dir = await getTemporaryDirectory();
    final targetPath = '${dir.absolute.path}/${basename(file.path)}_compressed.jpg';
    final compressedFile = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 70,
      minWidth: 1200,
    );
    return compressedFile;
  }


}