import 'package:flutter/cupertino.dart';

class CartElement {
  final String id;
  final String title;
  final double price;
  final int quantity;

  const CartElement({
    required this.id,
    required this.title,
    required this.price,
    required this.quantity,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartElement> _items = {};

  Map<String, CartElement> get items => {..._items};

  int get itemCount => _items.length;

  int get quantity {
    int quantity = 0;
    _items.forEach((key, cartItem) {
      quantity += cartItem.quantity;
    });
    return quantity;
  }

  double get total {
    double total = 0.0;
    _items.forEach((product, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(String productId, String productTitle, double price) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existingCartItem) => CartElement(
          id: existingCartItem.id,
          title: existingCartItem.title,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartElement(
          id: DateTime.now().toString(),
          title: productTitle,
          price: price,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) return;
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existingCartItem) => CartElement(
          id: existingCartItem.id,
          title: existingCartItem.title,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity - 1,
        ),
      );
    } else {
      removeItem(productId);
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
