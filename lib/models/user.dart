class UserModel {
final int? id;
final String name;
final String email;
final String password;
final String role; // 'client' or 'seller'


UserModel({this.id, required this.name, required this.email, required this.password, required this.role});


Map<String, dynamic> toMap() {
return {
'id': id,
'name': name,
'email': email,
'password': password,
'role': role,
};
}


factory UserModel.fromMap(Map<String, dynamic> m) {
return UserModel(
id: m['id'],
name: m['name'],
email: m['email'],
password: m['password'],
role: m['role'],
);
}
}