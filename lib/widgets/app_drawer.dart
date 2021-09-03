import 'package:flutter/material.dart';
import 'package:shop_app/screens/order_screen.dart';

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
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: const Text('Orders'),
            onTap: () =>
                Navigator.pushReplacementNamed(context, OrderScreen.routeName),
          ),
          Divider(),
        ],
      ),
    );
  }
}
