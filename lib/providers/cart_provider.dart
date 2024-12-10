import 'package:flutter/material.dart';
import '../models/vehiculo.dart';

class CartProvider with ChangeNotifier {
  List<Vehiculo> _cart = [];

  List<Vehiculo> get cart => _cart;

  double get totalPrice {
    double total = 0;
    for (var vehiculo in _cart) {
      total += vehiculo.precio;
    }
    return total;
  }

  void addToCart(Vehiculo vehiculo) {
    _cart.add(vehiculo);
    notifyListeners();
  }

  void removeFromCart(Vehiculo vehiculo) {
    _cart.remove(vehiculo);
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }
}
