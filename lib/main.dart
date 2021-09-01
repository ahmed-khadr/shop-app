import 'package:flutter/material.dart';
import 'package:shop_app/screens/product_overview_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My shop',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: ProductOverviewScreen(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My shop'),
      ),
      body: Center(child: Text('Let\'s get started')),
    );
  }
}
