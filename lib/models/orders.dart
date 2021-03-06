import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/cart.dart';

class OrderElement {
  final String id;
  final double amount;
  final List<CartElement> products;
  final DateTime dateTime;

  const OrderElement({
    required this.id,
    required this.amount,
    required this.dateTime,
    required this.products,
  });
}

class Orders with ChangeNotifier {
  List<OrderElement> _orders = [];
  String? authToken;
  String? _userId;

  void update(String? token, String? userId) {
    authToken = token;
    _userId = userId;
  }

  List<OrderElement> get orders => [..._orders];

  int get ordersCount => _orders.length;

  Future<void> fetchAndSetOrders() async {
    var url = Uri.parse(
        'https://shop-app-a8a58-default-rtdb.firebaseio.com/orders/$_userId.json?auth=$authToken');
    try {
      final response = await http.get(
        url,
        headers: {HttpHeaders.authorizationHeader: '$authToken'},
      );
      final List<OrderElement> loadedOrders = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>?;
      if (extractedData == null) {
        return null;
      }
      extractedData.forEach(
        (orderId, orderData) {
          loadedOrders.add(
            OrderElement(
              id: orderId,
              amount: orderData['amount'],
              dateTime: DateTime.parse(orderData['dateTime']),
              products: (orderData['products'] as List<dynamic>)
                  .map(
                    (item) => CartElement(
                      id: item['id'],
                      title: item['title'],
                      price: item['price'],
                      quantity: item['quantity'],
                    ),
                  )
                  .toList(),
            ),
          );
        },
      );
      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> addOrder(List<CartElement> cartProducts, double total) async {
    var url = Uri.parse(
        'https://shop-app-a8a58-default-rtdb.firebaseio.com/orders/$_userId.json?auth=$authToken');

    final timeStamp = DateTime.now();
    final List<dynamic> products = cartProducts.map(
      (cartProduct) {
        return {
          'id': cartProduct.id,
          'title': cartProduct.title,
          'quantity': cartProduct.quantity,
          'price': cartProduct.price,
        };
      },
    ).toList();
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'amount': total,
            'dateTime': timeStamp.toIso8601String(),
            'products': products,
          },
        ),
        headers: {HttpHeaders.authorizationHeader: '$authToken'},
      );
      _orders.insert(
        0,
        OrderElement(
          id: json.decode(response.body)['name'],
          amount: total,
          dateTime: timeStamp,
          products: cartProducts,
        ),
      );
      notifyListeners();
    } catch (e) {
      print(e.toString());
    }
  }
}
