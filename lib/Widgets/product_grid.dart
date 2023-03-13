import 'package:flutter/material.dart';
import 'package:flutter_application_2/Widgets/product_item.dart';
import 'package:provider/provider.dart';

import '../Providers/products.dart';

class ProductGrid extends StatelessWidget {
  final bool showFav;

  const ProductGrid(this.showFav, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    final products = showFav ? productData.favoriteItems : productData.items;

    return GridView.builder(
      padding: EdgeInsets.all(8),
      itemCount: products.length,
      itemBuilder: (context, i) => ChangeNotifierProvider.value(
        value: products[i],
        child: ProductItem(),
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5),
    );
  }
}
