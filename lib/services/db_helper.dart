import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/user.dart';
import '../models/product.dart';

class DBHelper {
	DBHelper._privateConstructor();
	static final DBHelper instance = DBHelper._privateConstructor();

	static Database? _database;

	Future<Database> get database async {
		if (_database != null) return _database!;
		await initDB();
		return _database!;
	}

	Future<void> initDB() async {
		final databasesPath = await getDatabasesPath();
		final path = join(databasesPath, 'condo360.db');

		_database = await openDatabase(
			path,
			version: 1,
			onCreate: (db, version) async {
				await db.execute('''
					CREATE TABLE users (
						id INTEGER PRIMARY KEY AUTOINCREMENT,
						name TEXT,
						email TEXT UNIQUE,
						password TEXT,
						role TEXT
					)
				''');

				await db.execute('''
					CREATE TABLE products (
						id INTEGER PRIMARY KEY AUTOINCREMENT,
						name TEXT,
						description TEXT,
						price REAL,
						stock INTEGER,
						seller_id INTEGER
					)
				''');

				await db.execute('''
					CREATE TABLE orders (
						id INTEGER PRIMARY KEY AUTOINCREMENT,
						product_id INTEGER,
						quantity INTEGER,
						total REAL,
						timestamp TEXT
					)
				''');
			},
		);
	}

	// Users
	Future<int> createUser(UserModel user) async {
		final db = await database;
		return await db.insert('users', user.toMap());
	}

	Future<UserModel?> getUserByEmail(String email) async {
		final db = await database;
		final res = await db.query('users', where: 'email = ?', whereArgs: [email]);
		if (res.isNotEmpty) return UserModel.fromMap(res.first);
		return null;
	}

	Future<UserModel?> login(String email, String password) async {
		final db = await database;
		final res = await db.query('users', where: 'email = ? AND password = ?', whereArgs: [email, password]);
		if (res.isNotEmpty) return UserModel.fromMap(res.first);
		return null;
	}

	// Products
	Future<List<Product>> getAllProducts() async {
		final db = await database;
		final res = await db.query('products');
		return res.map((m) => Product.fromMap(m)).toList();
	}

	Future<List<Product>> getProductsBySeller(int sellerId) async {
		final db = await database;
		final res = await db.query('products', where: 'seller_id = ?', whereArgs: [sellerId]);
		return res.map((m) => Product.fromMap(m)).toList();
	}

	Future<int> addProduct(Product p) async {
		final db = await database;
		return await db.insert('products', p.toMap());
	}

	Future<int> updateProductStock(int productId, int newStock) async {
		final db = await database;
		return await db.update('products', {'stock': newStock}, where: 'id = ?', whereArgs: [productId]);
	}

	// Purchase / Orders: decrement stock atomically
	Future<bool> purchaseProduct(int productId, int quantity) async {
		final db = await database;

		return await db.transaction((txn) async {
			final res = await txn.query('products', where: 'id = ?', whereArgs: [productId]);
			if (res.isEmpty) return false;
			final prod = res.first;
			final currentStock = prod['stock'] as int;
			if (currentStock < quantity) return false; // not enough stock

			final newStock = currentStock - quantity;
			await txn.update('products', {'stock': newStock}, where: 'id = ?', whereArgs: [productId]);

			final total = (prod['price'] as num) * quantity;
			await txn.insert('orders', {
				'product_id': productId,
				'quantity': quantity,
				'total': total,
				'timestamp': DateTime.now().toIso8601String(),
			});

			return true;
		});
	}
}