import 'dart:io';

import 'package:flutter/foundation.dart';
import './product.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  // ignore: prefer_final_fields
  List<Product> _items = [];
  // var _showFavoritesOnly = false;

  List<Product> get items {
    // if (_showFavoritesOnly) {
    //   return _items.where((prodItem) => prodItem.isFavorite).toList();
    // }
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavourite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  // void showFavoritesOnly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }

  Future<void> FetchandSetProducts() async {
    try {
      final url = Uri.https(
          'myshop-app-6715d-default-rtdb.firebaseio.com', '/products.json');
      final response = await http.get(url);
      // print(response.body);

      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      List<Product> prod = [];

      extractedData.forEach((prodId, prodvalue) {
        print(prodvalue['isFavourite']);
        prod.add(Product(
            id: prodId,
            description: prodvalue['description'],
            imageUrl: prodvalue['imageUrl'],
            price: prodvalue['price'],
            isFavourite: prodvalue['isFavourite'] == null
                ? false
                : prodvalue['isFavourite'],
            title: prodvalue['title']));
      });
      _items = prod;

      print(_items);
      notifyListeners();
    } catch (error) {
      print(error);
      print("123");
      throw error;
    }
  }

  Future<void> addProduct(Product addProduct) async {
    final url = Uri.https(
        'myshop-app-6715d-default-rtdb.firebaseio.com', '/products.json');
    // ignore: avoid_single_cascade_in_expression_statements
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': addProduct.title,
            'price': addProduct.price,
            'description': addProduct.description,
            'imageUrl': addProduct.imageUrl,
            'isFavourite': addProduct.isFavourite,
            'id': addProduct.id
          }));

      final NewProduct = Product(
          id: json.decode(response.body)['name'],
          title: addProduct.title,
          description: addProduct.description,
          imageUrl: addProduct.imageUrl,
          price: addProduct.price);
      _items.add(NewProduct);
      notifyListeners();
      // print(NewProduct.id);
      // print("Hello BUdbak");
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String? id, Product productValue) async {
    final prodIndex = _items.indexWhere((products) => products.id == id);
    if (prodIndex >= 0) {
      final url = Uri.https(
          'myshop-app-6715d-default-rtdb.firebaseio.com', '/products/$id.json');
      final response = await http.patch(url,
          body: json.encode({
            'id': productValue.id,
            'title': productValue.title,
            'description': productValue.description,
            'imageUrl': productValue.imageUrl,
            'price': productValue.price
          }));
      print(response.body);
      _items[prodIndex] = productValue;
      notifyListeners();
    } else {
      print("...");
    }
  }

  Future<void> deleteProduct(String? id) async {
    final Url = Uri.https(
        'myshop-app-6715d-default-rtdb.firebaseio.com', '/products/$id.json');
    final existingProductIndex =
        _items.indexWhere((product) => product.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(Url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException("Could not delete a Product");
    }

    // existingProduct = null;
  }
}
