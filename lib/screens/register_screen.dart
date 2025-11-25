import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/db_helper.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  String _role = 'client';

  void _register() async {
    final u = UserModel(
        name: _name.text.trim(),
        email: _email.text.trim(),
        password: _pass.text.trim(),
        role: _role);
    try {
      await DBHelper.instance.createUser(u);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Conta criada com sucesso')));
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erro: ${e.toString()}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          TextField(
              controller: _name,
              decoration: const InputDecoration(labelText: 'Nome')),
          TextField(
              controller: _email,
              decoration: const InputDecoration(labelText: 'Email')),
          TextField(
              controller: _pass,
              decoration: const InputDecoration(labelText: 'Senha'),
              obscureText: true),
          const SizedBox(height: 10),
          DropdownButton<String>(
              value: _role,
              items: const [
                DropdownMenuItem(value: 'client', child: Text('Cliente')),
                DropdownMenuItem(value: 'seller', child: Text('Vendedor'))
              ],
              onChanged: (v) {
                if (v != null) setState(() => _role = v);
              }),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: _register, child: const Text('Registrar'))
        ]),
      ),
    );
  }
}
