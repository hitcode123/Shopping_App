import 'package:flutter/material.dart';
import '../Providers/order.dart' show Orders;
import '../Widgets/order_item.dart';
import '../Widgets/app_drawer.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatelessWidget {
  static const route = '/Order-screen';
  var _isloading = false;

  @override
  //then in itself returns the future and no need to return a future

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Your Orders"),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
            future:
                Provider.of<Orders>(context, listen: false).fetchandSetOrders(),
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                print("value");
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError == true) {
                return Center(
                  child: Text("Error Has Occured"),
                );
              } else {
                return Consumer<Orders>(
                    builder: (context, orderData, child) => ListView.builder(
                          itemBuilder: (context, index) =>
                              OrderItem(orderData.orders[index]),
                          itemCount: orderData.orders.length,
                        ));
              }
            }));
  }
}
