import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:pub_puzzler/external/datasources/functions_datasource.dart';
import 'package:pub_puzzler/infra/services/logger_util.dart';

final logger = getLogger();

// TODO: Check how to persist a session
class AuthProvider extends ChangeNotifier {
  late Client _client;
  late Account _account;
  User? _user;
  String? _userId;
  bool _hasError = false;
  SnackBar _errorSnackBar = const SnackBar(content: Text(""));

  AuthProvider() {
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
  bool get hasError => _hasError;
  SnackBar get errorSnackBar => _errorSnackBar;

  Future<void> emailLogin(String email, String password) async {
    try {
      await _account.createEmailSession(email: email, password: password);
      _user = await account.get();
      _userId = _user!.$id;
      _hasError = false;
      _errorSnackBar = const SnackBar(content: Text(""));
      notifyListeners();
    } on AppwriteException catch (e) {
      final errorMsg = "E-Mail login failed - ${e.message}";
      logger.e(errorMsg);
      executeLogErrorFunction(errorMsg);
      _hasError = true;
      _errorSnackBar = SnackBar(content: Text(e.message!));
      notifyListeners();
    }
  }

  Future<void> register(String email, String password) async {
    try {
      await account.create(
          userId: ID.unique(), email: email, password: password);
      await emailLogin(email, password);
      notifyListeners();
    } on AppwriteException catch (e) {
      final errorMsg = "Failed to register new user - ${e.message}";
      logger.e(errorMsg);
      executeLogErrorFunction(errorMsg);
      _hasError = true;
      _errorSnackBar = SnackBar(content: Text(e.message!));
      notifyListeners();
    }
  }

  // TODO: After logging out, there are no descendant Scaffolds present
  Future<void> logout() async {
    try {
      await account.deleteSession(sessionId: 'current');
      _user = null;
      _hasError = false;
      _errorSnackBar = const SnackBar(content: Text(""));
      notifyListeners();
    } on AppwriteException catch (e) {
      final errorMsg = "Failed to logout user - ${e.message}";
      logger.e(errorMsg);
      executeLogErrorFunction(errorMsg);
      _hasError = true;
      _errorSnackBar = SnackBar(content: Text(e.message!));
      notifyListeners();
    }
  }
}
