import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:proyecto_financiero/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group("Pruebas de Login", () {
    testWidgets("1️⃣ Carga correcta de la pantalla de Login", (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();

      expect(find.text("Inicia Sesión"), findsOneWidget);
      expect(find.byKey(const Key('login_username')), findsOneWidget);
      expect(find.byKey(const Key('login_password')), findsOneWidget);
      expect(find.byKey(const Key('login_continue_btn')), findsOneWidget);
    });

    testWidgets("2️⃣ Validación con campos vacíos", (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('login_continue_btn')));
      await tester.pump();

      expect(find.text("Ingresa tu usuario"), findsOneWidget);
      expect(find.text("Ingresa tu contraseña"), findsOneWidget);
    });

    testWidgets("3️⃣ Login real navega a Home", (WidgetTester tester) async {
      app.main(); // App REAL, sin mocks
      await tester.pumpAndSettle();

      // Escribir usuario REAL que exista en Firebase
      await tester.enterText(
        find.byKey(const Key('login_username')),
        "victor@gmail.com",
      );

      // Escribir contraseña REAL
      await tester.enterText(
        find.byKey(const Key('login_password')),
        "12345678",
      );

      await tester.pump();

      // Tocar botón
      await tester.tap(find.byKey(const Key('login_continue_btn')));
      await tester.pumpAndSettle();

      // Verificar que llegó a Home
      expect(find.text("Home"), findsOneWidget);
    });
  });
}
