import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_experiment/auth/auth.dart';
import 'package:flutter_experiment/logger.dart';
import 'package:http/http.dart' as http;

class RequestHelper {
  final String url = dotenv.env['API_URL']!;
  int retryCount = 0;

  Future<dynamic> send(String method, String path,
      {Map<String, String>? headers, body, retry = false}) async {
    if (retryCount > 1) {
      logger.e("Too many retries");
      return null;
    }
    String? token = retry
        ? await AuthService.instance.refreshToken
        : await AuthService.instance.accessToken;

    if (token == null) {
      logger.e("No token");
      return null;
    }

    var baseHeader = {"Authorization": "Bearer $token"};

    if (headers != null) {
      headers.remove("Authorization");
      baseHeader.addAll(headers);
    }

    switch (method) {
      case "GET":
        return get(path, headers: headers);
      case "POST":
        return post(path, headers: headers, body: body);
      default:
        logger.e("Invalid method: $method");
        return null;
    }
  }

  Future<dynamic> checkResponse(http.Response response, [requestBody]) async {
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      if (await AuthService.instance.refreshTokens()) {
        retryCount++;
        retry(response, requestBody);
      } else {
        AuthService.instance.logout();
        return null;
      }
    } else {
      logger.e(response.body);
      return null;
    }
  }

  Future<Map<String, dynamic>?> retry(
      http.Response response, requestBody) async {
    // Retry the request
    return await send(response.request!.method, response.request!.url.path,
        headers: response.request?.headers, body: requestBody);
  }

  Future<dynamic> get(String path, {Map<String, String>? headers}) async {
    http.Response response =
        await http.get(Uri.parse("$url$path"), headers: headers);
    return await checkResponse(response);
  }

  Future<Map<String, dynamic>?> post(String path,
      {Map<String, String>? headers, body}) async {
    http.Response response =
        await http.post(Uri.parse("$url$path"), headers: headers, body: body);
    return await checkResponse(response);
  }
}
