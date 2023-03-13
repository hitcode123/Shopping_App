import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../Providers/cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime datetime;
  OrderItem(
      {required this.id,
      required this.amount,
      required this.products,
      required this.datetime});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = Uri.https(
        'myshop-app-6715d-default-rtdb.firebaseio.com', '/orders.json');
    final timestamp = DateTime.now();
    final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'id': timestamp.toIso8601String(),
          'products': cartProducts
              .map((cp) => {
                    'id': cp.id,
                    'price': cp.price,
                    'quantity': cp.quantity,
                    'title': cp.title
                  })
              .toList(),
          'datetime': timestamp.toIso8601String()
        }));
    print(response.body);
    _orders.insert(
        0,
        OrderItem(
            id: json.decode(response.body)['name'],
            amount: total,
            products: cartProducts,
            datetime: timestamp));
    notifyListeners();
  }

  Future<void> fetchandSetOrders() async {
    // print("hello");
    final url = Uri.https(
        'myshop-app-6715d-default-rtdb.firebaseio.com', '/orders.json');
    final response = await http.get(url);
    // print(response.body);
    List<OrderItem> LoadedProducts = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((Orderkey, ordervalue) {
      // print(ordervalue['datetime']);
      LoadedProducts.add(OrderItem(
          id: Orderkey,
          amount: ordervalue['amount'],
          products: (ordervalue['products'] as List<dynamic>)
              .map((order) => CartItem(
                  id: order['id'],
                  title: order['title'],
                  quantity: order['quantity'],
                  price: order['price']))
              .toList(),
          datetime: DateTime.parse(ordervalue['datetime'])));
    });
    _orders = LoadedProducts.reversed.toList();
    notifyListeners();
  }
}
