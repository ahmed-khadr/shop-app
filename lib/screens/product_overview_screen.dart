import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/widgets/products_gridview.dart';

class ProductOverviewScreen extends StatelessWidget {
  ProductOverviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductsProvider>(context).items;
    return Scaffold(
      backgroundColor: Color.fromRGBO(251, 247, 249, 0.9),
      appBar: AppBar(
        title: const Text('My Shop'),
      ),
      body: ProductsGridView(products: products),
    );
  }
}
