import 'dart:async';
// ignore: uri_does_not_exist
import 'package:dart_appwrite/dart_appwrite.dart';

Future<dynamic> main(final context) async {
  if (context.req.method == 'POST' &&
      context.req.headers['content-type'] == 'application/json') {
    final formData = Uri.splitQueryString(context.req.body);

    String? errorMsg = formData['errorMsg'];

    // Guard clause
    if (errorMsg == null) {
      return context.res.send('Invalid content', 400);
    }

    context.error(formData['errorMsg']);

    return context.res.send('Logged message', 201);
  }
}
