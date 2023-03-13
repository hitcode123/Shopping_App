import 'package:flutter/material.dart';
import '../Providers/order.dart';
import '../Widgets/app_drawer.dart';
import 'package:provider/provider.dart';

import '../Providers/cart.dart' show Cart;
import '../Widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);
  static const route = 'Cart-Route';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(title: Text("Your Cart")),
      drawer: AppDrawer(),
      body: Column(children: <Widget>[
        Card(
          margin: EdgeInsets.all(15),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Total',
                  style: TextStyle(fontSize: 20),
                ),
                Spacer(),
                Chip(
                  label: Text(
                    '\$${cart.totalAmount.toStringAsFixed((2))}',
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
                TextButton(
                  onPressed: () {
                    if (cart.totalAmount > 0) {
                      Provider.of<Orders>(context, listen: false).addOrder(
                          cart.items.values.toList(), cart.totalAmount);
                      cart.clear();
                    }
                  },
                  child: Text(
                    "Order Now",
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                )
              ],
            ),
          ),
        ),
        SizedBox(height: 10),
        Divider(),
        if (cart.items.isNotEmpty)
          Expanded(
              child: ListView.builder(
            itemBuilder: ((context, i) => CartItem(
                cart.items.values.toList()[i].id,
                cart.items.values.toList()[i].price,
                cart.items.keys.toList()[i],
                cart.items.values.toList()[i].quantity,
                cart.items.values.toList()[i].title)),
            itemCount: cart.items.length,
          )),
      ]),
    );
  }
}

