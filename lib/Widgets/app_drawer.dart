import 'package:flutter/material.dart';

import '../Screeens/edit_product_screen.dart';
import '../Screeens/order_screen.dart';
import '../Screeens/user_product_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      children: <Widget>[
        AppBar(
          title: Text('MyShop'),
          automaticallyImplyLeading: false,
        ),
        ListTile(
          leading: Icon(Icons.shop),
          title: Text('Shop'),
          onTap: () {
            Navigator.of(context).pushReplacementNamed('/');
          },
        ),
        ListTile(
          leading: Icon(Icons.payment),
          title: Text('Orders'),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(OrderScreen.route);
          },
        ),
        ListTile(
          leading: Icon(Icons.edit),
          title: Text("Manage Your Products"),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(UserProductScreen.route);
          },
        )
      ],
    ));
  }
}
