import 'package:flutter/material.dart';
import 'package:shop_app/screens/order_screen.dart';
import 'package:shop_app/screens/user_products_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('Hello Friend!'),
          ),
          ListTile(
            leading: Icon(Icons.shop),
            title: const Text('Shop'),
            onTap: () => Navigator.pushReplacementNamed(context, '/'),
          ),
          const Divider(
            color: Colors.black54,
          ),
          ListTile(
            leading: Icon(Icons.payment),
            title: const Text('Orders'),
            onTap: () =>
                Navigator.pushReplacementNamed(context, OrderScreen.routeName),
          ),
          const Divider(
            color: Colors.black54,
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: const Text('Manage Products'),
            onTap: () => Navigator.pushReplacementNamed(
                context, UserProductsScreen.routeName),
          ),
          const Divider(
            color: Colors.black54,
          ),
        ],
      ),
    );
  }
}
