import 'package:flutter/material.dart';
import 'package:shop_app/screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({
    Key? key,
    required this.id,
    required this.title,
    required this.imageUrl,
  }) : super(key: key);
  final String id;
  final String title;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(
          context,
          ProductDetailScreen.routeName,
          arguments: id,
        ),
        child: GridTile(
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
          ),
          footer: GridTileBar(
            leading: IconButton(
              icon: Icon(
                Icons.favorite,
                color: Theme.of(context).accentColor,
              ),
              onPressed: () {},
            ),
            trailing: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.shopping_cart_rounded,
                color: Theme.of(context).accentColor,
              ),
            ),
            title: Text(
              title,
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.black54,
          ),
        ),
      ),
    );
  }
}
