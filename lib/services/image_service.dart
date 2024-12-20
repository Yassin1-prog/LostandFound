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

      String curfileid = ID.unique();

      await Future.sync(() async {
        try {
          await _storage.createFile(
            bucketId: AppwriteConstants.bucketId,
            fileId: curfileid,
            file: InputFile.fromPath(
              path: imageFile.path,
              filename: fileName,
            ),
          );
        } catch (e) {
          // If the error is the type conversion issue we know about,
          // we can safely ignore it since the upload succeeded
          if (e.toString().contains(
              "type 'List<dynamic>' is not a subtype of type 'List<String>'")) {
            // Continue execution
            return;
          }
          // Rethrow any other errors
          rethrow;
        }
      });

      // Construct the public URL to access the uploaded file
      final String fileUrl =
          'https://cloud.appwrite.io/v1/storage/buckets/${AppwriteConstants.bucketId}/files/$curfileid/view?project=${AppwriteConstants.projectId}';

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
