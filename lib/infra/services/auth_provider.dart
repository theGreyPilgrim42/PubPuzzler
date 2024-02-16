import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:pub_puzzler/infra/services/logger_util.dart';

final logger = getLogger();

class AuthProvider extends ChangeNotifier {
  late Client _client;
  late Account _account;
  late User? _user;

  AuthProvider() {
    _user = null;
    // Setup account and client
    _client = Client();
    _client = Client()
        .setEndpoint(GlobalConfiguration().getValue('baseAppwriteApiUrl'))
        .setProject(dotenv.env['APPWRITE_PROJECT_ID']);  // TODO: Provide this through env vars -> create new appwrite project
    _account = Account(_client);

    logger.i("Setup Appwrite Account and Client");
    notifyListeners();
  }

  /* setupAuth() {
    _client = Client();
    _client = Client()
        .setEndpoint(GlobalConfiguration().getValue('baseAppwriteApiUrl'))
        .setProject(dotenv.env['APPWRITE_PROJECT_ID']);  // TODO: Provide this through env vars -> create new appwrite project
    _account = Account(_client);
    notifyListeners();
    logger.i("Setup AuthProvider");
  } */

  Client get client => _client;
  Account get account => _account;
  User? get user => _user;

  Future<void> emailLogin(String email, String password) async {
    await _account.createEmailSession(email: email, password: password);
    _user = await account.get();
    notifyListeners();
  }

  Future<void> guestLogin() async {
    await _account.createAnonymousSession();
    notifyListeners();
  }

  Future<void> register(String email, String password, String name) async {
    await account.create(userId: ID.unique(), email: email, password: password); // TODO: Handle case - User already exists
    await emailLogin(email, password);
    notifyListeners();
  }

  Future<void> logout() async {
    await account.deleteSession(sessionId: 'current');
    _user = null;
    notifyListeners();
  }

  // TODO: Check if SMS login should be a possibility as well
  // TODO: Check if OAuth2 should be a possibility as well
  
}