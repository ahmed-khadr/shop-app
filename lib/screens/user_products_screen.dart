import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/products_provider.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  const UserProductsScreen({Key? key}) : super(key: key);

  static const String routeName = '/user-products-screen';

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductsProvider>(context).items;
    return Scaffold(
      backgroundColor: Color.fromRGBO(251, 247, 249, 0.9),
      drawer: AppDrawer(),
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, EditProductScreen.routeName,arguments: '');
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemBuilder: (_, index) => Column(
            children: [
              UserProductItem(
                id: products[index].id,
                title: products[index].title,
                imageUrl: products[index].imageUrl,
              ),
              const Divider(
                color: Colors.black54,
              ),
            ],
          ),
          itemCount: products.length,
        ),
      ),
    );
  }
}
