import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  var id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;

  Product(
      {required this.id,
      required this.title,
      required this.description,
      required this.imageUrl,
      required this.price,
      this.isFavourite = false});

  void _setfavStatus(bool newValue) {
    isFavourite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavouriteStatus() async {
    print("hello i am into favourited");
    final oldstatus = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();
    try {
      final url = Uri.https(
          'myshop-app-6715d-default-rtdb.firebaseio.com', '/products/$id.json');
      final response = await http.patch(url,
          body: json.encode({'isFavourite': isFavourite}));
      print(response.statusCode);
      if (response.statusCode >= 400) {
        _setfavStatus(oldstatus);
      }
    } catch (e) {
      _setfavStatus(oldstatus);
    }
  }
}
