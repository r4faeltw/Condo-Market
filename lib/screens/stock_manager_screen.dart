import 'package:flutter/material.dart';

import '../services/db_helper.dart';
import '../models/product.dart';

class StockManagerScreen extends StatefulWidget {
	final int sellerId;
	const StockManagerScreen({super.key, required this.sellerId});

	@override
	State<StockManagerScreen> createState() => _StockManagerScreenState();
}


class _StockManagerScreenState extends State<StockManagerScreen> {
late Future<List<Product>> _products;
final _name = TextEditingController();
final _desc = TextEditingController();
final _price = TextEditingController();
final _stock = TextEditingController();


@override
void initState() {
super.initState();
_load();
}

@override
void dispose() {
	_name.dispose();
	_desc.dispose();
	_price.dispose();
	_stock.dispose();
	super.dispose();
}


void _load() {
setState(() { _products = DBHelper.instance.getProductsBySeller(widget.sellerId); });
}


void _addProduct() async {
final p = Product(
name: _name.text.trim(),
description: _desc.text.trim(),
price: double.tryParse(_price.text.trim()) ?? 0.0,
stock: int.tryParse(_stock.text.trim()) ?? 0,
sellerId: widget.sellerId,
);
await DBHelper.instance.addProduct(p);
_name.clear(); _desc.clear(); _price.clear(); _stock.clear();
_load();
}


void _editStock(Product p) async {
final ctrl = TextEditingController(text: p.stock.toString());
final res = await showDialog<int?>(context: context, builder: (_) => AlertDialog(
title: const Text('Editar estoque'),
content: TextField(controller: ctrl, keyboardType: TextInputType.number),
actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')), TextButton(onPressed: () => Navigator.pop(context, int.tryParse(ctrl.text)), child: const Text('Salvar'))],
));
if (res != null) {
await DBHelper.instance.updateProductStock(p.id!, res);
_load();
}
}


@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(title: const Text('Gerenciar Estoque')),
body: Padding(
padding: const EdgeInsets.all(12.0),
child: Column(children: [
TextField(controller: _name, decoration: const InputDecoration(labelText: 'Nome')),
TextField(controller: _desc, decoration: const InputDecoration(labelText: 'Descrição')),
TextField(controller: _price, decoration: const InputDecoration(labelText: 'Preço'), keyboardType: TextInputType.number),
TextField(controller: _stock, decoration: const InputDecoration(labelText: 'Estoque'), keyboardType: TextInputType.number),
const SizedBox(height: 8),
ElevatedButton(onPressed: _addProduct, child: const Text('Adicionar Produto')),
const SizedBox(height: 12),
Expanded(
child: FutureBuilder<List<Product>>(
future: _products,
builder: (context, snap) {
if (!snap.hasData) return const Center(child: CircularProgressIndicator());
final list = snap.data!;
if (list.isEmpty) return const Center(child: Text('Sem produtos'));
return ListView.builder(
itemCount: list.length,
itemBuilder: (context, i) {
final p = list[i];
return ListTile(
title: Text(p.name),
subtitle: Text('Estoque: ${p.stock} | Preço: R\$ ${p.price.toStringAsFixed(2)}'),
trailing: IconButton(icon: const Icon(Icons.edit), onPressed: () => _editStock(p)),
);
},
);
},
),
)
]),
),
);
}
}