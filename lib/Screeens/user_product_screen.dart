import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';

import '../Screeens/edit_product_screen.dart';
import '../Widgets/app_drawer.dart';
import '../Widgets/user_product_item.dart';
import '../Providers/products.dart';

class UserProductScreen extends StatelessWidget {
  static const route = '/user_products';
  Future<void> _refreshProducts(BuildContext context) async {
    Provider.of<Products>(context, listen: false).FetchandSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context).items;
    return Scaffold(
        appBar: AppBar(
          title: const Text("Your Product"),
          actions: <Widget>[
            IconButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(EditProductScreen.route, arguments: null);
                },
                icon: const Icon(Icons.add))
          ],
        ),
        drawer: AppDrawer(),
        body: RefreshIndicator(
          onRefresh: () => _refreshProducts(context),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: ListView.builder(
              itemBuilder: ((_, i) => UserProductItem(productData[i].id,
                  productData[i].title, productData[i].imageUrl)),
              itemCount: productData.length,
            ),
          ),
        ));
  }
}
