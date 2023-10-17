import 'dart:convert';

import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> signIn(String email, String password) async {
  const apiKey = 'AIzaSyC6uv_zv5nnu9to07xlKHPl1fCrGur2YyI';
  const url =
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$apiKey';
  final header = {
    'Content-Type': 'application/json',
  };
  final body = {
    'email': email,
    'password': password,
    'returnSecureToken': true,
  };

  final response =
      await http.post(Uri.parse(url), headers: header, body: json.encode(body));
  final Map<String, dynamic> data = json.decode(response.body);

  if (response.statusCode != 200) {
    if (data['error']['message'] == 'INVALID_PASSWORD') {
      throw 'Incorrect mot de passe';
    } else if (data['error']['message'] == 'EMAIL_NOT_FOUND') {
      throw 'Email non trouvé';
    } else if (data['error']['message'] ==
        'TOO_MANY_ATTEMPTS_TRY_LATER : Access to this account has been temporarily disabled due to many failed login attempts. You can immediately restore it by resetting your password or you can try again later.') {
      throw 'Nombre de tentatives trop élevé. Veuillez réessayer plus tard';
    } else {
      throw data['error']['message'];
    }
  }
  return data;
}

Future<void> resetPassword(String email) async {
  const apiKey = 'AIzaSyC6uv_zv5nnu9to07xlKHPl1fCrGur2YyI';
  const url =
      'https://identitytoolkit.googleapis.com/v1/accounts:sendOobCode?key=$apiKey';
  final header = {
    'Content-Type': 'application/json',
  };
  final body = {
    'requestType': "PASSWORD_RESET",
    'email': email,
  };

  final response =
      await http.post(Uri.parse(url), headers: header, body: json.encode(body));

  if (response.statusCode != 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    if (data['error']['message'] == 'EMAIL_NOT_FOUND') {
      throw 'Email non trouvé';
    } else {
      throw data['error']['message'];
    }
  }
}
