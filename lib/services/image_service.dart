//import 'dart:io'; // This is actually used via InputFile.fromPath
import 'package:appwrite/appwrite.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import '../constants.dart';
import '../appwrite_client.dart';

class ImageService {
  final Storage _storage = Storage(AppwriteClientService.client);
  final ImagePicker _picker = ImagePicker();

  Future<XFile?> takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 85,
      );
      return photo;
    } catch (e) {
      print('Error taking photo: $e');
      return null;
    }
  }

  Future<String?> uploadImage(XFile imageFile, String userId) async {
    try {
      // Generate a unique file name using the user's ID and a timestamp
      final String fileName =
          '${userId}_${DateTime.now().millisecondsSinceEpoch}${path.extension(imageFile.path)}';

      const List<String> permissions = ['read("any")', 'write("any")'];

      print('Attempting to upload file from path: ${imageFile.path}');
      final bytes = await imageFile.readAsBytes();

      // Upload file to Appwrite Storage using InputFile.fromPath
      final uploadedFile = await _storage.createFile(
        bucketId: AppwriteConstants.bucketId, // Replace with your bucket ID
        fileId: ID.unique(), // Generate a unique file ID
        file: InputFile.fromBytes(
          bytes: bytes, // Correctly pass the file path
          filename: fileName, // Set the file name
        ),
        permissions: permissions,
      );

      // Construct the public URL to access the uploaded file
      final String fileUrl =
          'https://cloud.appwrite.io/v1/storage/buckets/${AppwriteConstants.bucketId}/files/${uploadedFile.$id}/view?project=${AppwriteConstants.projectId}';

      print('File uploaded successfully. URL: $fileUrl');
      return fileUrl;
    } on AppwriteException catch (e) {
      print('Appwrite error uploading image: ${e.message}');
      return null;
    } catch (e) {
      print('General error uploading image: $e');
      return null;
    }
  }
}
