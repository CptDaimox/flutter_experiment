import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_experiment/api/request.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:flutter_experiment/logger.dart';

/// A class that handles user authentication.
///
/// The [AuthService] class includes methods for logging in, logging out, and checking the authentication state.
class AuthService {
  static final AuthService instance = AuthService._singletonConstructor();
  late Map<String, dynamic> _currentUser;
  final RequestHelper _requestHelper = RequestHelper();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final StreamController<bool> _authStreamController = StreamController<bool>();

  // singleton constructor
  AuthService._singletonConstructor() {
    checkAuthState();
  }

  /// Getter for the authentication state stream.
  Stream<bool> get authState => _authStreamController.stream;

  Map<String, dynamic> get currentUser => _currentUser;

  Future<String?> get accessToken async => await _storage.read(key: "token");
  Future<String?> get refreshToken async =>
      await _storage.read(key: "refreshToken");

  /// Checks the authentication state by reading the user's token from secure storage.
  ///
  /// If the token is not null, the authentication state stream is updated to true.
  /// If the token is null, the authentication state stream is updated to false.
  Future<bool> checkAuthState() async {
    try {
      String? accessToken = await _storage.read(key: "token");
      String? refreshToken = await _storage.read(key: "refreshToken");
      if (accessToken == null || JwtDecoder.isExpired(accessToken)) {
        if (refreshToken != null) {
          // refresh tokens
        }
        _authStreamController.add(false);
        return false;
      }

      _authStreamController.add(true);
      _currentUser = JwtDecoder.decode(accessToken);
      return true;
    } catch (e) {
      _authStreamController.addError(e);
      return false;
    }
  }

  /// Deletes all stored tokens and closes the authentication state stream.
  void dispose() async {
    await _storage.deleteAll();
  }

  /// Stores a token in secure storage.
  ///
  /// This method takes a [token] as input and uses the [_storage] object to write the [token] to secure storage with the key "token".
  /// Inputs:
  /// - [token] (String): The token to be stored in secure storage.
  Future<void> storeToken(String accessToken, String refreshToken) async {
    await _storage.write(key: "token", value: accessToken);
    await _storage.write(key: "refreshToken", value: refreshToken);
  }

  /// Handles the login functionality.
  ///
  /// Sends a POST request to the server with the user's email and password.
  /// If the login is successful, it stores the user's token in secure storage
  /// and updates the authentication state stream to true.
  ///
  /// Example Usage:
  /// ```dart
  /// bool success = await login("user@example.com", "password");
  /// print(success); // true
  /// ```
  ///
  /// Inputs:
  /// - [email] (String): The user's email.
  /// - [password] (String): The user's password.
  ///
  /// Outputs:
  /// - Returns `true` if the login is successful.
  /// - Returns `false` if the login fails or an exception occurs.
  Future<bool> login(String email, String password) async {
    try {
      logger.d("Login");
      var response = await _requestHelper.post("/login", body: {
        "email": email,
        "password": password,
      });
      if (!await checkTokens(response)) {
        logger.e("Login failed");
        return false;
      }
      return true;
    } catch (e) {
      logger.e(e.toString());
      _authStreamController.add(false);
      return false;
    }
  }

  /// Refreshes the user's tokens by sending a POST request to the server with the user's refresh token.
  ///
  /// The method sends a POST request to the server with the provided [refreshToken] in the headers.
  /// It then awaits the response from the server and checks if the tokens are valid by calling the [checkTokens] method.
  ///
  /// If the tokens are valid, it returns `true` indicating a successful refresh.
  /// If the tokens are not valid, it logs an error message and returns `false`.
  /// If an exception occurs during the process, it updates the authentication state and returns `false`.
  ///
  /// Parameters:
  ///   - [refreshToken]: The user's refresh token.
  ///
  /// Returns:
  ///   - `true` if the tokens are successfully refreshed.
  ///   - `false` if the tokens are not valid or an exception occurs.
  Future<bool> refreshTokens() async {
    logger.d("Refresh");
    try {
      String? refreshToken = await _storage.read(key: "refreshToken");
      if (refreshToken == null) {
        throw Exception("Refresh token not found");
      }
      Map<String, dynamic>? response = await _requestHelper.send(
          "POST", "/token",
          headers: {"Authentication": "Bearer $refreshToken"});
      if (!await checkTokens(response)) {
        logger.e("Refresh failed");
        return false;
      }
      return true;
    } catch (e) {
      _authStreamController.add(false);
      return false;
    }
  }

  Future<bool> checkTokens(Map<String, dynamic>? response) async {
    try {
      if (response == null ||
          !response.containsKey("accessToken") ||
          !response.containsKey("refreshToken")) {
        throw Exception('Login failed');
      }
      await storeToken(response["accessToken"], response["refreshToken"]);
      return checkAuthState();
    } catch (e) {
      _authStreamController.add(false);
      return false;
    }
  }

  /// Logs out the user by deleting the user's token from secure storage.
  ///
  /// The authentication state stream is updated to false.
  Future<void> logout() async {
    _authStreamController.add(false);
    dispose();
  }
}
