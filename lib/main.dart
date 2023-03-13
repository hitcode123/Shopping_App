import 'package:flutter/material.dart';
import '../Screeens/edit_product_screen.dart';

import '../Providers/products.dart';
import '../Screeens/product_detail_screen.dart';
import '../Screeens/product_overview_screen.dart';
import 'package:provider/provider.dart';
import 'Providers/cart.dart';
import './Screeens/cart_screen.dart';
import './Screeens/order_screen.dart';
import './Providers/order.dart';
import '../Screeens/user_product_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: Products(),
          ),
          ChangeNotifierProvider.value(value: Cart()),
          ChangeNotifierProvider.value(
            value: Orders(),
          )
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'MyShop',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch().copyWith(
                secondary: Colors.deepOrange,
                primary: Color.fromARGB(135, 197, 34, 34),
                ),
            fontFamily: 'Lato',
            textTheme: TextTheme(displayMedium: TextStyle(color: Colors.orange))
          ),
          home: ProductOverviewScreen(),
          routes: {
            ProductDetailScreen.route: (context) => ProductDetailScreen(),
            CartScreen.route: (ctx) => CartScreen(),
            OrderScreen.route: (ctx) => OrderScreen(),
            UserProductScreen.route: ((ctx) => UserProductScreen()),
            EditProductScreen.route: (ctx) => EditProductScreen()
          },
        ));
  }
}
