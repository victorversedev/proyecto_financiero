import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:proyecto_financiero/main.dart';

void main() {
  // Crear un mock de FirebaseAuth
  final mockAuth = MockFirebaseAuth();

  testWidgets('la app carga la pantalla de login correctamente',
      (WidgetTester tester) async {
    // Cargar la app con el mock
    await tester.pumpWidget(MyApp(auth: mockAuth, analytics: null));
    await tester.pumpAndSettle();

    // Verificar que estamos en la pantalla de Login
    expect(find.text("Inicia Sesión"), findsOneWidget);

    // Verificar que el botón "Continuar" existe
    expect(find.byKey(const Key('login_continue_btn')), findsOneWidget);

    // Verificar que los campos existen
    expect(find.byKey(const Key('login_username')), findsOneWidget);
    expect(find.byKey(const Key('login_password')), findsOneWidget);
  });
}
