import 'dart:convert';

import 'package:appwrite/appwrite.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:pub_puzzler/infra/services/logger_util.dart';

final _logger = getLogger();
final _client = Client()
    .setEndpoint(GlobalConfiguration().getValue('baseAppwriteApiUrl'))
    .setProject(dotenv.env['APPWRITE_PROJECT_ID']);
final _functions = Functions(_client);

Future<Map<String, dynamic>> getExecutionResult(String functionId) async {
  try {
    final execution = await _functions.createExecution(
        functionId: functionId,
        body: json.encode({'test': 'test'}),
        xasync: false,
        path: '/',
        method: 'GET',
        headers: {});
    return execution.toMap();
  } on AppwriteException catch (e) {
    _logger.e(
        "An error occurred while getting execution results - ${e.message} - ${e.type} - ${e.code.toString()}");
    throw Future.error("An error occurred while getting execution results");
  }
}
