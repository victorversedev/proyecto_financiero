import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_financiero/homePage.dart';
import 'package:proyecto_financiero/screens/home/views/home_screen.dart';
import 'package:proyecto_financiero/RegisterPage.dart';
import 'package:proyecto_financiero/app.dart';

class LoginPage extends StatefulWidget {
  final FirebaseAuth auth;

  LoginPage({super.key, FirebaseAuth? auth})
    : auth = auth ?? FirebaseAuth.instance;

  @override
  State<LoginPage> createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  late String email, password;
  final _formKey = GlobalKey<FormState>();
  String error = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 32.0,
              vertical: 24.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Inicia Sesión",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Utiliza tu contraseña y usuario para continuar.",
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 24),

                // Formulario
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        key: const Key('login_username'),
                        decoration: InputDecoration(
                          hintText: "Nombre de usuario",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade400),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        onSaved: (value) => email = value!,
                        validator: (value) =>
                            value!.isEmpty ? 'Ingresa tu usuario' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        key: const Key('login_password'),
                        decoration: InputDecoration(
                          hintText: "Contraseña",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade400),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                        obscureText: true,
                        onSaved: (value) => password = value!,
                        validator: (value) =>
                            value!.isEmpty ? 'Ingresa tu contraseña' : null,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    key: const Key('login_register_button'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateUserPage(),
                        ),
                      );
                    },
                    child: const Text(
                      "No tienes cuenta? registrate.",
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 15,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    key: const Key('login_continue_btn'),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        UserCredential? cred = await login(email, password);
                        if (cred != null && cred.user != null) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MyApp(),
                            ),
                            (route) => false,
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2196F3),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Continuar",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                if (error.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    error,
                    key: const Key('login_error_msg'),
                    style: const TextStyle(color: Colors.red, fontSize: 14),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<UserCredential?> login(String email, String password) async {
    try {
      UserCredential userCredential = await widget.auth
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == 'user-not-found') {
          error = 'Usuario no encontrado';
        } else if (e.code == 'wrong-password') {
          error = 'Contraseña incorrecta';
        } else {
          error = 'Error al iniciar sesión: ${e.message}';
        }
      });
      return null;
    }
  }
}
