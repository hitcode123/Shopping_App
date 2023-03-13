import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({Key? key}) : super(key: key);

  // ignore: prefer_const_declarations
  static const route = '/Detail-screen';
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)?.settings.arguments as String;
    final productDetail = Provider.of<Products>(context).findById(productId);
    print(productId);

    return Scaffold(
        appBar: AppBar(title: Text(productDetail.title)),
        body: SingleChildScrollView(
            child: Column(children: <Widget>[
          Container(
            height: 300,
            width: double.infinity,
            child: Image.network(
              productDetail.imageUrl,
              fit: BoxFit.fill,
            ),
          ),
          SizedBox(height: 10),
          Text(
            '\$${productDetail.price}',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 20,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(
                productDetail.description,
                textAlign: TextAlign.center,
                softWrap: true,
              ))
        ])));
  }
}
