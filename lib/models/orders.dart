import 'package:flutter/material.dart';
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

  List<OrderElement> get orders => [..._orders];

  int get ordersCount => _orders.length;

  void addOrder(List<CartElement> cartProducts, double total) {
    _orders.insert(
      0,
      OrderElement(
        id: DateTime.now().toString(),
        amount: total,
        dateTime: DateTime.now(),
        products: cartProducts,
      ),
    );
    notifyListeners();
  }
}
