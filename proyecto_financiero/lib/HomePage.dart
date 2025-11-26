import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseAnalytics.instance.logEvent(
      name: 'home_page_open',
      parameters: {'description': 'Usuario abrió HomePage'},
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: const Center(
        child: Text(
          'Firebase conectado correctamente',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}