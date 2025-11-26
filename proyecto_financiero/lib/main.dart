import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:proyecto_financiero/LoginPage.dart';
import 'firebase_options.dart';

/// Ahora el main permite inyectar FirebaseAuth en pruebas
void main({FirebaseAuth? auth, FirebaseAnalytics? analytics}) async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MyApp(auth: auth, analytics: analytics));
}

class MyApp extends StatelessWidget {
  final FirebaseAuth? auth;
  final FirebaseAnalytics? analytics;

  const MyApp({super.key, this.auth, this.analytics});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi App con Firebase',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      navigatorObservers: [
        if (analytics != null) FirebaseAnalyticsObserver(analytics: analytics!),
      ],
      home: LoginPage(auth: auth ?? FirebaseAuth.instance), // <-- Nunca null
    );
  }
}
