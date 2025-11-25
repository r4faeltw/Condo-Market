import 'package:flutter/material.dart';
import 'stock_manager_screen.dart';

class SellerHomeScreen extends StatelessWidget {
  final int sellerId;
  const SellerHomeScreen({super.key, required this.sellerId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Condo 360 - Vendedor')),
      body: Center(
        child: ElevatedButton(
          child: const Text('Gerenciar estoque'),
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => StockManagerScreen(sellerId: sellerId))),
        ),
      ),
    );
  }
}
