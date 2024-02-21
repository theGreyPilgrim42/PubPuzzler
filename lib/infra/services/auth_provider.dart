import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:pub_puzzler/infra/services/logger_util.dart';

final logger = getLogger();

// TODO: Improve error handling in general
class AuthProvider extends ChangeNotifier {
  late Client _client;
  late Account _account;
  late User? _user;
  late String? _userId;

  AuthProvider() {
    _user = null;
    _userId = null;
    // Setup account and client
    _client = Client();
    _client = Client()
        .setEndpoint(GlobalConfiguration().getValue('baseAppwriteApiUrl'))
        .setProject(dotenv.env['APPWRITE_PROJECT_ID']);
    _account = Account(_client);

    notifyListeners();
  }

  Client get client => _client;
  Account get account => _account;
  User? get user => _user;
  String? get userId => _userId;

  Future<void> emailLogin(String email, String password) async {
    await _account.createEmailSession(email: email, password: password);
    _user = await account.get();
    _userId = _user!.$id;
    notifyListeners();
  }

  Future<void> guestLogin() async {
    await _account.createAnonymousSession();
    notifyListeners();
  }

  Future<void> register(String email, String password) async {
    await account.create(
        userId: ID.unique(),
        email: email,
        password: password); // TODO: Handle case - User already exists
    await emailLogin(email, password);
    notifyListeners();
  }

  Future<void> logout() async {
    await account.deleteSession(sessionId: 'current');
    _user = null;
    notifyListeners();
  }
}
