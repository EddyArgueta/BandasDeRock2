import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bandasrockeras/Pantallas/pantalla_listado.dart';

class PantallaCreaBandas extends StatefulWidget {
  const PantallaCreaBandas({Key? key}) : super(key: key);

  @override
  _PantallaCreaBandasState createState() => _PantallaCreaBandasState();
}

class _PantallaCreaBandasState extends State<PantallaCreaBandas> {
  TextEditingController nombreController = TextEditingController();
  TextEditingController albumController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  final _picker = ImagePicker();
  File? _imageFile;
  String? _imageUrl;

  Future<void> _guardarBanda(BuildContext context) async {
    final storage = FirebaseStorage.instance;
    String nombre = nombreController.text;
    String album = albumController.text;
    String year = yearController.text;

    if (_imageFile != null) {
      // Crear una referencia de almacenamiento dinámica
      final imageRef = storage.ref().child('Imagen_Banda/$nombre-${DateTime.now()}.png');
      await imageRef.putFile(_imageFile!);
      final imageUrl = await imageRef.getDownloadURL();

      setState(() {
        _imageUrl = imageUrl;
      });

      await FirebaseFirestore.instance.collection('coleccionImagen').add({
        'NombreBanda': nombre,
        'NombreAlbum': album,
        'AñoLanzamiento': year,
        'CantidadVotos': 0,
        'imageUrl': imageUrl,
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PantallaListadoBandas()),
      );
    } else {
      await FirebaseFirestore.instance.collection('coleccionImagen').add({
        'NombreBanda': nombre,
        'NombreAlbum': album,
        'AñoLanzamiento': year,
        'CantidadVotos': 0,
        'imageUrl': null, // Puedes asignar null si no se ha seleccionado una imagen
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PantallaListadoBandas()),
      );
    }
  }

  Future<void> _imagenGaleria() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Banda de Rock'),
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: nombreController,
                maxLength: 30,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                  labelText: 'Nombre de la Banda',
                  prefixIcon: Icon(Icons.group_outlined),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: albumController,
                maxLength: 30,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                  labelText: 'Nombre del Álbum',
                  prefixIcon: Icon(Icons.queue_music),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: yearController,
                maxLength: 10,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Año de Lanzamiento',
                  prefixIcon: Icon(Icons.calendar_today_rounded),
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _imagenGaleria,
                  child: const Text('Seleccionar Imagen desde Galería'),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () => _guardarBanda(context),
                  child: const Text('Agregar Banda'),
                ),
              ),

              const SizedBox(height: 20),
              if (_imageUrl != null)
                Center(
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(_imageUrl!),
                    radius: 60,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
