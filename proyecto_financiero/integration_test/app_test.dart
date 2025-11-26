import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:proyecto_financiero/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('la app carga la pantalla de login correctamente',
      (WidgetTester tester) async {

    // Cargar la app real
    app.main();
    await tester.pumpAndSettle();

    // Verificar que estamos en la pantalla de Login
    expect(find.text("Inicia Sesión"), findsOneWidget);

    // Verificar que el botón "Continuar" existe
    expect(find.text("Continuar"), findsOneWidget);

    // Verificar que el campo de usuario existe
    expect(find.widgetWithText(TextFormField, "Nombre de usuario"), findsOneWidget);

    // Verificar que el campo de contraseña existe
    expect(find.widgetWithText(TextFormField, "Contraseña"), findsOneWidget);
  });
}
