import 'dart:async';
import 'dart:convert';
// ignore: uri_does_not_exist
import 'package:dart_appwrite/dart_appwrite.dart';

Future<dynamic> main(final context) async {
  if (context.req.method == 'POST') {
    context.log('Processing POST request');

    // Extract errorMsg
    final data = jsonDecode(context.req.body);
    String? errorMsg = data['errorMsg'];

    // Guard clause
    if (errorMsg == null) {
      return context.res.send('Invalid content', 400);
    }

    context.error(errorMsg);

    return context.res.send('Logged message', 201);
  }
  context.log('Could not process request');
}
