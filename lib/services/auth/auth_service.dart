import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:loginsi2v2/models/models.dart';
import 'package:http/http.dart' as http;
import 'package:loginsi2v2/services/services.dart';

class AuthService extends ChangeNotifier {
  bool _isLoggerdIn = false;
  User? _user;
  String? _token;

  bool get authentificated => _isLoggerdIn;
  User get user => _user!;
  Servidor servidor = Servidor();

  final _storage = const FlutterSecureStorage();

  Future<String> login(
      String email, String password, String device_name) async {
    try {
      final response =
          await http.post(Uri.parse('${servidor.baseUrl}/sanctum/token'),
              body: ({
                'email': email,
                'password': password,
                'device_name': device_name,
              }));

      if (response.statusCode == 200) {
        String token = response.body.toString();
        tryToken(token);
        return 'correcto';
      } else {
        return 'incorrecto';
      }
    } catch (e) {
      return 'error';
    }
  }

  Future<String> register(
      String name, String email, String type, String password) async {
    try {
      final response =
          await http.post(Uri.parse('${servidor.baseUrl}/register'),
              body: ({
                'name': name,
                'email': email,
                'password': password,
                'type': type,
              }));

      if (response.statusCode == 200) {
        String token = response.body.toString();
        tryToken(token);
        return 'correcto';
      } else {
        return 'incorrecto';
      }
    } catch (e) {
      return 'error';
    }
  }

  void tryToken(String? token) async {
    if (token == null) {
      return;
    } else {
      try {
        final response = await http.get(Uri.parse('${servidor.baseUrl}/user'),
            headers: {'Authorization': 'Bearer $token'});

        print(response.body);
        _isLoggerdIn = true;
        _user = User.fromJson(jsonDecode(response.body));
        _token = token;
        storeToken(token);
        notifyListeners();
      } catch (e) {
        print(e);
      }
    }
  }

  void storeToken(String token) async {
    _storage.write(key: 'token', value: token);
  }

  void logout() async {
    try {
      final response = await http.get(
          Uri.parse('${servidor.baseUrl}/user/revoke'),
          headers: {'Authorization': 'Bearer $_token'});
      cleanUp();
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void cleanUp() async {
    _user = null;
    _isLoggerdIn = false;
    _user = null;
    await _storage.delete(key: 'token');
  }
}
