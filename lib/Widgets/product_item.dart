import 'package:flutter/material.dart';
import '../Providers/cart.dart';
import '../Providers/product.dart';
import '../Screeens/product_detail_screen.dart';
import 'package:provider/provider.dart';
// import '../Screeens/';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context);
    return GridTile(
        child: GestureDetector(
          child: Image.network(product.imageUrl),
          onTap: () {
            Navigator.of(context)
                .pushNamed(ProductDetailScreen.route, arguments: product.id);
          },
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (ctx, product, _) => IconButton(
              icon: product.isFavourite
                  ? Icon(Icons.favorite)
                  : Icon(Icons.favorite_border_outlined),
              onPressed: () {
                product.toggleFavouriteStatus();
              },
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          title: Text(
            product.title,
            style: TextStyle(),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              cart.addItem(product.id, product.price, product.title);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar((SnackBar(
                  content: Text("Add Item to the Cart??"),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () => cart.removeSingleItem(product.id),
                  ))));
            },
            color: Theme.of(context).colorScheme.secondary,
          ),
        ));
  }
}
