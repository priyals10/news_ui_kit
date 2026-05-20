import 'package:image_picker/image_picker.dart';

/// A utility class that centralises all [ImagePicker] access.
/// 
/// Rationale: if image_picker is ever replaced (or its API changes), the
/// change only needs to happen here. Screens never import image_picker directly.
class MediaPickerHelper {
  MediaPickerHelper._();

  static final ImagePicker _picker = ImagePicker();

  /// Pick a single image from the device gallery.
  /// Returns `null` if the user cancelled or an error occurred.
  /// 
  /// Returns [XFile] to ensure cross-platform compatibility (web/mobile).
  static Future<XFile?> pickFromGallery({int imageQuality = 80}) async {
    final XFile? file = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: imageQuality,
    );
    return file;
  }

  /// Capture a photo from the device camera.
  /// Returns `null` if the user cancelled or an error occurred.
  static Future<XFile?> pickFromCamera({int imageQuality = 80}) async {
    final XFile? file = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: imageQuality,
    );
    return file;
  }

  /// Pick a single video from the gallery (for future use).
  static Future<XFile?> pickVideoFromGallery() async {
    final XFile? file = await _picker.pickVideo(
      source: ImageSource.gallery,
    );
    return file;
  }
}
