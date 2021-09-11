import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/helper_models/http_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryTime;
  String? _userId;
  Timer? _authTimer;

  bool get isAuth {
    return token != null;
  }

  String? get userId {
    return _userId;
  }

  String? get token {
    if (_token != null &&
        _expiryTime != null &&
        _expiryTime!.isAfter(DateTime.now())) {
      return _token;
    }
    return null;
  }

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
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryTime = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData['expiresIn']),
        ),
      );
      _autoSignOut();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'expiryTime': _expiryTime?.toIso8601String(),
        },
      );
      await prefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

  Future<bool> trySignin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final sharedData = prefs.getString('userData');
    final extractedData = json.decode(sharedData!);
    final expiryTime = DateTime.parse(extractedData['expiryTime']);
    if (expiryTime.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedData['token'];
    _userId = extractedData['userId'];
    _expiryTime = expiryTime;
    notifyListeners();
    _autoSignOut();
    return true;
  }

  Future<void> signup({String? email, String? password}) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> signin({String? email, String? password}) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<void> signout() async {
    _token = null;
    _userId = null;
    _expiryTime = null;
    if (_authTimer != null) {
      _authTimer?.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  void _autoSignOut() {
    if (_authTimer != null) {
      _authTimer?.cancel();
    }
    final int timeToExpiry = _expiryTime!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(
        Duration(
          seconds: timeToExpiry,
        ),
        signout);
  }
}
