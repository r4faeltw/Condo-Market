import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/db_helper.dart';

class PurchaseScreen extends StatefulWidget {
  final Product product;
  const PurchaseScreen({super.key, required this.product});

  @override
  State<PurchaseScreen> createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  int _qty = 1;
  bool _loading = false;

  void _buy() async {
    setState(() => _loading = true);
    final success =
        await DBHelper.instance.purchaseProduct(widget.product.id!, _qty);
    if (!mounted) return;
    setState(() => _loading = false);
    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Compra falhou (estoque insuficiente)')));
      Navigator.pop(context, false);
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Compra realizada com sucesso')));
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Comprar - ${widget.product.name}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          Text(widget.product.description),
          const SizedBox(height: 10),
          Text(
              'Preço unitário: R\$ ${widget.product.price.toStringAsFixed(2)}'),
          const SizedBox(height: 10),
          Row(children: [
            const Text('Quantidade:'),
            IconButton(
                onPressed: () {
                  if (_qty > 1) setState(() => _qty--);
                },
                icon: const Icon(Icons.remove)),
            Text('$_qty'),
            IconButton(
                onPressed: () {
                  if (_qty < widget.product.stock) setState(() => _qty++);
                },
                icon: const Icon(Icons.add)),
          ]),
          const SizedBox(height: 20),
          ElevatedButton(
              onPressed: _loading ? null : _buy,
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text('Confirmar compra'))
        ]),
      ),
    );
  }
}
