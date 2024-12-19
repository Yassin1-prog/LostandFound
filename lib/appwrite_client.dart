import 'package:appwrite/appwrite.dart';
import './constants.dart';

class AppwriteClientService {
  static Client get client {
    Client client = Client();
    return client
      ..setEndpoint(AppwriteConstants.endpoint)
      ..setProject(AppwriteConstants.projectId)
      ..setSelfSigned(status: true); // Remove this line in production
  }
}
