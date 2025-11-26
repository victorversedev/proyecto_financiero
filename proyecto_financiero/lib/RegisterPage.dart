import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_financiero/homePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateUserPage extends StatefulWidget {
  const CreateUserPage({super.key});

  @override
  State createState() {
    return _CreateUserState();
  }
}

class _CreateUserState extends State<CreateUserPage> {
  late String nombre, email, password;
  final _formKey = GlobalKey<FormState>();
  String error='';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tutorial Firebase"),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("Crear Usuario", style: TextStyle(color: Colors.black, fontSize: 24),),
          ),
          Offstage(
            offstage:error == '' ,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(error, style: TextStyle(color: Colors.red, fontSize: 16),),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: formulario(),
          ),
          butonCrearUsuario(),
        ],
      ),
    );
  }

  Widget formulario() {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            buildNombre(),
            const SizedBox(height: 12),
            buildEmail(),
            const Padding(padding: EdgeInsets.only(top: 12)),
            buildPassword(),

          ],
        ));
  }


// Crear Nombre
Widget buildNombre() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Nombre completo",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.black),
        ),
      ),
      onSaved: (value) => nombre = value!,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Este campo es obligatorio";
        }
        return null;
      },
    );
  }

  Widget buildEmail() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: "Correo",
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.black))),
      keyboardType: TextInputType.emailAddress,
      onSaved: (String? value) {
        email = value!;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return "Este campo es obligatorio";
        }
        return null;
      },
    );
  }

  Widget buildPassword() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: "Password",
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.black))),
      obscureText: true,
      validator: (value) {
        if (value!.isEmpty) {
          return "Este campo es obligatorio";
        }
        return null;
      },
      onSaved: (String? value) {
        password = value!;
      },
    );
  }




  Widget butonCrearUsuario() {
    return FractionallySizedBox(
      widthFactor: 0.6,
      child: ElevatedButton(
          onPressed: () async{

            if(_formKey.currentState!.validate()){
              _formKey.currentState!.save();
              UserCredential? credenciales = await crear(email, password);
              if(credenciales !=null){
                if(credenciales.user != null){
                   await credenciales.user!.sendEmailVerification();
                   Navigator.of(context).pop();
                }
              }
            }
          },
          child: Text("Registrarse")
      ),
    );
  }

  
   Future<UserCredential?> crear(String email, String password) async {
  try {
     //  Crear el usuario en Firebase Authentication
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    //  Obtener el UID del nuevo usuario
    String uid = userCredential.user!.uid;

    //  Crear referencia al documento del usuario en la colección "usuarios"
    DocumentReference userRef =
        FirebaseFirestore.instance.collection('usuarios').doc(uid);

    //  Verificar si ya existe el documento
    DocumentSnapshot doc = await userRef.get();

    if (!doc.exists) {
      //  Si no existe, lo creamos con los datos capturados del formulario
      await userRef.set({
        'nombre': nombre,
        'email': email,
        'rol': 'usuario', //admin o usuario
        'fechaRegistro': FieldValue.serverTimestamp(),
      });
    } else {
      // solo la primera vez se creara posteriormente Si ya existe, solo actualizamos los campos que correspondan
      await userRef.update({
        'nombre': nombre,
        'email': email,
      });
    }

    return userCredential;
    }
    on FirebaseAuthException catch (e) {
    if (e.code == 'email-already-in-use') {
      setState(() {
        error = "El correo ya se encuentra en uso";
      });
    } else if (e.code == 'weak-password') {
      setState(() {
        error = "Contraseña débil";
      });
    } else {
      setState(() {
        error = "Error: ${e.message}";
      });
    }
  } catch (e) {
    setState(() {
      error = "Error inesperado: $e";
    });
  }

  return null;
}
}