import 'package:bandasrockeras/Pantallas/pantalla_principal.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; 

//El Main quedara solo para inicializar el FireBase
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}