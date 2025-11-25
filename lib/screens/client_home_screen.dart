import 'package:flutter/material.dart';
import '../services/db_helper.dart';
import '../models/product.dart';
import 'purchase_screen.dart';


class ClientHomeScreen extends StatefulWidget {
final int userId;
const ClientHomeScreen({super.key, required this.userId});


@override
State<ClientHomeScreen> createState() => _ClientHomeScreenState();
}


class _ClientHomeScreenState extends State<ClientHomeScreen> {
late Future<List<Product>> _products;


@override
void initState() {
super.initState();
_load();
}


void _load() {
setState(() { _products = DBHelper.instance.getAllProducts(); });
}


@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(title: const Text('Condo 360 - Compras')),
body: FutureBuilder<List<Product>>(
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
subtitle: Text('${p.description}\nPreço: R\$ ${p.price.toStringAsFixed(2)} | Estoque: ${p.stock}'),
isThreeLine: true,
trailing: ElevatedButton(onPressed: p.stock>0? () async {
final ok = await Navigator.push(context, MaterialPageRoute(builder: (_) => PurchaseScreen(product: p)));
if (ok == true) _load();
} : null, child: const Text('Comprar')),
);
},
);
},
),
);
}
}