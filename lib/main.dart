
import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'services/db_helper.dart';


void main() async {
WidgetsFlutterBinding.ensureInitialized();
await DBHelper.instance.initDB();
runApp(const Condo360App());
}


class Condo360App extends StatelessWidget {
const Condo360App({super.key});


@override
Widget build(BuildContext context) {
return MaterialApp(
title: 'Condo 360',
theme: ThemeData(
primarySwatch: Colors.blue,
),
home: const LoginScreen(),
);
}
}
