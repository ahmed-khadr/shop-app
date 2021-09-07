import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/helper_models/http_exception.dart';
import 'package:shop_app/models/cart.dart';
import 'package:shop_app/models/products_provider.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/badge.dart';
import 'package:shop_app/widgets/products_gridview.dart';

import 'cart_screen.dart';

enum FilterOptions {
  favorites,
  all,
}

class ProductOverviewScreen extends StatefulWidget {
  ProductOverviewScreen({Key? key}) : super(key: key);

  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool _showFavorites = false;
  bool _isLoading = false;
  bool _isThereProducts = true;

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
    });
    Provider.of<ProductsProvider>(context, listen: false)
        .fetchAndSetProducts()
        .then(
          (_) => setState(() {
            _isLoading = false;
          }),
        )
        .catchError((error) {
      if (error is HttpException) {
        setState(() {
          _isLoading = false;
          _isThereProducts = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(251, 247, 249, 0.9),
      drawer: AppDrawer(),
      appBar: AppBar(
        title: const Text('My Shop'),
        actions: [
          Consumer<Cart>(
            builder: (_, cart, child) => Badge(
              child: child!,
              value: cart.quantity.toString(),
            ),
            child: IconButton(
              onPressed: () =>
                  Navigator.pushNamed(context, CartScreen.routeName),
              icon: Icon(Icons.shopping_cart),
            ),
          ),
          PopupMenuButton(
              onSelected: (FilterOptions selectedValue) {
                setState(() {
                  if (selectedValue == FilterOptions.favorites) {
                    _showFavorites = true;
                  } else {
                    _showFavorites = false;
                  }
                });
              },
              itemBuilder: (_) => [
                    PopupMenuItem(
                      child: Text('Show Favorites'),
                      value: FilterOptions.favorites,
                    ),
                    PopupMenuItem(
                      child: Text('Show all'),
                      value: FilterOptions.all,
                    ),
                  ]),
        ],
      ),
      body: _buildProductsWidgets(),
      // body: _isLoading
      //     ? Center(
      //         child: CircularProgressIndicator(),
      //       )
      //     : ProductsGridView(
      //         showFavorites: _showFavorites,
      //       ),
    );
  }

  Widget _buildProductsWidgets() {
    if (_isThereProducts && !_isLoading) {
      return ProductsGridView(
        showFavorites: _showFavorites,
      );
    }
    if (_isLoading && _isThereProducts) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return const Center(
        child: const Text(
          'There is no product yet',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
  }
}
