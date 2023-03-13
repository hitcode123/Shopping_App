import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Providers/products.dart';
import '../Screeens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String? id;
  UserProductItem(this.id, this.title, this.imageUrl);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(children: [
          IconButton(
            icon:
                Icon(Icons.delete, color: Theme.of(context).colorScheme.error),
            onPressed: () {
              Provider.of<Products>(context, listen: false).deleteProduct(id);
            },
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(EditProductScreen.route, arguments: id);
            },
            icon:
                Icon(Icons.edit, color: Theme.of(context).colorScheme.primary),
          )
        ]),
      ),
    );
  }
}
