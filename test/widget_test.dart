// test/widget_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:condo360/main.dart';

void main() {
  testWidgets('Tela de login aparece com título e botão de criar conta', (WidgetTester tester) async {
    // Build the app
    await tester.pumpWidget(const Condo360App());

    // Espera o frame inicial
    await tester.pumpAndSettle();

    // Verifica se o AppBar com o título 'Condo 360 - Login' está presente
    expect(find.text('Condo 360 - Login'), findsOneWidget);

    // Verifica se existe um botão de 'Criar conta' (o Register)
    expect(find.text('Criar conta'), findsOneWidget);

    // Verifica se existe um campo de Email e um campo de Senha
    expect(find.byType(TextField), findsNWidgets(2));
  });
}
