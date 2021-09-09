import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/constants.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryTime;
  String? _userId;

  Future<void> _authenticate(
      String? email, String? password, String? apiAction) async {
    var url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$apiAction?key=$kAPIKEY');
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );

      print(json.decode(response.body));
    } catch (error) {
      print(error.toString());
    }
  }

  Future<void> signup({String? email, String? password}) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> signin({String? email, String? password}) async {
    return _authenticate(email, password, 'signInWithPassword');
  }
}
