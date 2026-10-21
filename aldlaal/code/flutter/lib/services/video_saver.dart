import 'package:image_picker/image_picker.dart';
import 'package:video_compress/video_compress.dart';
import 'dart:io';
import 'dart:convert';
import 'api_service.dart';

class VideoSaver {
  final ImagePicker _picker = ImagePicker();
  static const maxVideoSize = 25 * 1024 * 1024;

  Future<File?> _compressVideo(File videoFile) async {
    /*final originalSize = await videoFile.length();
    if (originalSize <= maxVideoSize) return videoFile;*/

    final MediaInfo? compressedVideo = await VideoCompress.compressVideo(
      videoFile.path,
      quality: VideoQuality.MediumQuality,
      deleteOrigin: false,
    );
    if (compressedVideo == null) return null;
    final compressedFile = File(compressedVideo.path!);
    final compressedSize = await compressedFile.length();
    if (compressedSize > maxVideoSize) {
      throw Exception('Video is too large even after compression');
    }
    return compressedFile;
  }

  Future<String?> _fileToBase64(File file) async {
    try {
      final bytes = await file.readAsBytes();
      final base64Data = base64Encode(bytes);
      return 'data:video/mov;base64,$base64Data';
    } catch (e) {
      print('Error converting to Base64: $e');
      return null;
    }
  }

  Future<dynamic> save() async {
    try {
      // Pick video
      final pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
      if (pickedFile == null) {return null;}
      File videoFile = File(pickedFile.path);
      //compress video
      final processedFile = await _compressVideo(videoFile);
      if (processedFile == null) {
        return null;
      }
      // Convert to Base64
      final videoBase64 = await _fileToBase64(processedFile);
      if (videoBase64 == null) {return null;}
      // Upload to API
      final response = await apiService('/videos/save', {'video': videoBase64},timeout: 1000);
      return response;
    } catch (e) {
      print('Video handling error: $e');
      return null;
    }
  }
}