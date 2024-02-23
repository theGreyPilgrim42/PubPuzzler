import 'dart:convert';

import 'package:appwrite/appwrite.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:pub_puzzler/domain/entities/question.dart';
import 'package:pub_puzzler/infra/services/logger_util.dart';

final _logger = getLogger();
final _client = Client()
    .setEndpoint(GlobalConfiguration().getValue('baseAppwriteApiUrl'))
    .setProject(dotenv.env['APPWRITE_PROJECT_ID']);
final _functions = Functions(_client);

Future<Map<String, dynamic>> _getPostExecutionResult(String functionId, Map<String, String> body, Map<dynamic, dynamic> headers) async {
  try {
    final execution = await _functions.createExecution(
        functionId: functionId,
        body: json.encode(body),
        xasync: false,
        path: '/',
        method: 'POST',
        headers: headers);
    return execution.toMap();
  } on AppwriteException catch(e) {
    throw Future.error("An error occurred while getting execution results");
  }
}

Future<void> executeLogErrorFunction(String errorMsg) async {
  try {
    final result = await _getPostExecutionResult(dotenv.env['APPWRITE_FUNCTION_ERROR_LOGGING_ID']!, {'errorMsg': errorMsg}, {});
    final statusCode = result['responseStatusCode'];

    if (statusCode != 201) _logger.e('An error occurred while requesting to execute logging function - StatusCode: $statusCode');
  } catch(e) {
    logger.e(e);
  }
  }
