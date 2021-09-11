import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/orders.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/order_item.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({Key? key}) : super(key: key);
  static const String routeName = '/order-screen';

  // Future<void> _fetch(BuildContext context) async {
  //   try {
  //     final future =
  //         await Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  //     return future;
  //   } on HttpException catch (error) {
  //     print(error.toString());
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      backgroundColor: Color.fromRGBO(251, 247, 249, 0.9),
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: const CircularProgressIndicator(),
            );
          }

          if (snapshot.error != null) {
            return Center(
              child: const Text('An Error has occurred!'),
            );
          } else {
            return Consumer<Orders>(
              builder: (ctx, orderData, child) {
                if (orderData.orders.length == 0) {
                  return const Center(
                    child: const Text(
                      'No orders yet',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  itemBuilder: (_, index) =>
                      OrderItem(order: orderData.orders[index]),
                  itemCount: orderData.orders.length,
                );
              },
            );
          }
        },
      ),
    );
  }
}
