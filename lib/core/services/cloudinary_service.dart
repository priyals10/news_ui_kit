import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class CloudinaryService {

  static const String cloudName = 'dyf2p0gaf';
  static const String uploadPreset = 'news_ui_kit';

  static Future<String?> uploadImage(XFile imageFile) async {
    // Return a dummy image immediately if credentials haven't been provided yet.
    if (cloudName == 'YOUR_CLOUD_NAME' ||
        uploadPreset == 'YOUR_UPLOAD_PRESET') {
      debugPrint(
        'Cloudinary credentials missing. Returning placeholder image for testing!',
      );
      await Future.delayed(
        const Duration(seconds: 1),
      ); // Simulate network latency
      final seed = DateTime.now().millisecondsSinceEpoch;
      return 'https://picsum.photos/seed/$seed/600/400';
    }

    try {
      final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
      );
      final request = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = uploadPreset;

      if (kIsWeb) {
        final bytes = await imageFile.readAsBytes();
        request.files.add(
          http.MultipartFile.fromBytes('file', bytes, filename: imageFile.name),
        );
      } else {
        request.files.add(
          await http.MultipartFile.fromPath('file', imageFile.path),
        );
      }

      final response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await response.stream.toBytes();
        final responseString = String.fromCharCodes(responseData);
        final jsonMap = jsonDecode(responseString);
        return jsonMap['secure_url'];
      } else {
        // Handle error or print response for debugging
        final responseData = await response.stream.toBytes();
        final responseString = String.fromCharCodes(responseData);
        debugPrint('Cloudinary Error: $responseString');
        return null;
      }
    } catch (e) {
      debugPrint('Cloudinary Exception: $e');
      return null;
    }
  }
}
