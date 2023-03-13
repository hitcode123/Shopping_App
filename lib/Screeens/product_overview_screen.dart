import 'package:flutter/material.dart';

import '../Providers/products.dart';
import '../Screeens/cart_screen.dart';
import '../Widgets/app_drawer.dart';
import '../Widgets/badge.dart';
import '../Widgets/product_grid.dart';
import 'package:provider/provider.dart';

import '../Providers/cart.dart';

enum FilteredOption { Favourites, All }

class ProductOverviewScreen extends StatefulWidget {
  const ProductOverviewScreen({Key? key}) : super(key: key);

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showFavourites = false;
  var _isInit = false;
  var _loading = false;
  @override
  void didChangeDependencies() {
    if (!_isInit) {
      print("heelo");
      setState(() {
        _loading = true;
      });
      Provider.of<Products>(context, listen: false)
          .FetchandSetProducts()
          .then((value) => setState(() {
                print("234");
                _loading = false;
              }));
    }
    _isInit = true;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text("My Shop"),
        actions: <Widget>[
          PopupMenuButton(
              onSelected: (FilteredOption optionvalue) {
                setState(() {
                  if (optionvalue == FilteredOption.Favourites) {
                    _showFavourites = true;
                  } else {
                    _showFavourites = false;
                  }
                });
              },
              icon: const Icon(Icons.more_vert),
              itemBuilder: (_) {
                return [
                  const PopupMenuItem(
                    child: Text("Only Show_Favourites"),
                    value: FilteredOption.Favourites,
                  ),
                  // ignore: prefer_const_constructors
                  const PopupMenuItem(
                    child: Text("Show all"),
                    value: FilteredOption.All,
                  )
                ];
              }),
          Consumer<Cart>(
            builder: ((ctx, Cart, ch) => Badge(
                  child: IconButton(
                      icon: Icon(Icons.shopping_cart),
                      onPressed: () {
                        Navigator.of(context)
                            .pushReplacementNamed(CartScreen.route);
                      }),
                  value: Cart.itemcount.toString(),
                )),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : ProductGrid(_showFavourites),
    );
  }
}
