class Product {
final int? id;
final String name;
final String description;
final double price;
final int stock;
final int sellerId;


Product({this.id, required this.name, required this.description, required this.price, required this.stock, required this.sellerId});


Map<String, dynamic> toMap() {
return {
'id': id,
'name': name,
'description': description,
'price': price,
'stock': stock,
'seller_id': sellerId,
};
}


factory Product.fromMap(Map<String, dynamic> m) {
return Product(
id: m['id'],
name: m['name'],
description: m['description'],
price: m['price'],
stock: m['stock'],
sellerId: m['seller_id'],
);
}
}