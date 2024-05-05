import 'package:bandasrockeras/Pantallas/pantalla_crea_bandas.dart';
import 'package:bandasrockeras/Pantallas/pantalla_listado.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Votaciones de Bandas de Rock',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      home: const PantallaPrincipalScreen(),
    );
  }
}

class PantallaPrincipalScreen extends StatelessWidget {
  const PantallaPrincipalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Votaciones de Bandas de Rock'),
      ),
      body: Container(
        color: Colors.indigo,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PantallaCreaBandas()),
                  );
                },
                child: const Text('¡Agreguemos bandas de Rock!'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PantallaListadoBandas()),
                  );
                },
                child: const Text('¡A Votar!'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
