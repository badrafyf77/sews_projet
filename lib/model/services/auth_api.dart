import 'dart:convert';
import 'package:http/http.dart' as http;

const apiKey = 'AIzaSyC6uv_zv5nnu9to07xlKHPl1fCrGur2YyI';
const baseUrl = 'https://identitytoolkit.googleapis.com/v1/accounts:';

Future<Map<String, dynamic>> signIn(String email, String password) async {
  const url = '${baseUrl}signInWithPassword?key=$apiKey';
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

Future<Map<String, dynamic>> signUp(String email, String password) async {
  const url = '${baseUrl}signUp?key=$apiKey';
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
    if (data['error']['message'] == 'EMAIL_EXISTS') {
      throw 'E-mail existe déjà';
    } else if (data['error']['message'] == 'OPERATION_NOT_ALLOWED') {
      throw 'Opération non autorisée';
    } else if (data['error']['message'] == 'TOO_MANY_ATTEMPTS_TRY_LATER') {
      throw 'Nombre de tentatives trop élevé. Veuillez réessayer plus tard';
    } else {
      throw data['error']['message'];
    }
  }
  return data;
}

Future<void> resetPassword(String email) async {
  const url = '${baseUrl}sendOobCode?key=$apiKey';
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

Future<Map<String, dynamic>> updateEmail(String email, String idToken) async {
  const url = '${baseUrl}update?key=$apiKey';
  final header = {
    'Content-Type': 'application/json',
  };
  final body = {
    "idToken": idToken,
    "email": email,
    "returnSecureToken": true,
  };

  final response =
      await http.post(Uri.parse(url), headers: header, body: json.encode(body));

  final Map<String, dynamic> data = json.decode(response.body);

  if (response.statusCode != 200) {
    if (data['error']['message'] == 'EMAIL_EXISTS') {
      throw 'E-mail déja utilisé';
    } else if (data['error']['message'] == 'INVALID_ID_TOKEN') {
      throw 'Id Token invalide';
    } else {
      throw data['error']['message'];
    }
  }
  return data;
}

Future<Map<String, dynamic>> updatePassword(
    String password, String idToken) async {
  const url = '${baseUrl}update?key=$apiKey';
  final header = {
    'Content-Type': 'application/json',
  };
  final body = {
    "idToken": idToken,
    "password": password,
    "returnSecureToken": true,
  };

  final response =
      await http.post(Uri.parse(url), headers: header, body: json.encode(body));

  final Map<String, dynamic> data = json.decode(response.body);

  if (response.statusCode != 200) {
    if (data['error']['message'] == 'INVALID_ID_TOKEN') {
      throw 'Id Token invalide';
    } else {
      throw data['error']['message'];
    }
  }
  return data;
}

Future<Map<String, dynamic>> updateName(String idToken, String name) async {
  const url = '${baseUrl}update?key=$apiKey';
  final header = {
    'Content-Type': 'application/json',
  };
  final body = {
    "idToken": idToken,
    "displayName": name,
    "returnSecureToken": true,
  };

  final response =
      await http.post(Uri.parse(url), headers: header, body: json.encode(body));

  final Map<String, dynamic> data = json.decode(response.body);

  if (response.statusCode != 200) {
    if (data['error']['message'] == 'INVALID_ID_TOKEN') {
      throw 'Id Token invalide';
    } else {
      throw data['error']['message'];
    }
  }
  return data;
}
