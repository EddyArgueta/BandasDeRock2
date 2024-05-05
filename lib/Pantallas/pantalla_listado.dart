import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PantallaListadoBandas extends StatelessWidget {
  const PantallaListadoBandas({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listado de Bandas de Rock'),
      ),
      body: _buildListadoBandas(context),
    );
  }

  Widget _buildListadoBandas(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('coleccionImagen').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No hay bandas disponibles'),
          );
        }

        final bandas = snapshot.data!.docs.where((banda) =>
            banda['NombreBanda'] != null &&
            banda['NombreAlbum'] != null &&
            banda['AñoLanzamiento'] != null &&
            banda['CantidadVotos'] != null).toList();

        return ListView.builder(
          itemCount: bandas.length,
          itemBuilder: (BuildContext context, int index) {
            var banda = bandas[index];
            return Dismissible(
              key: Key(banda.id),
              onDismissed: (direction) {
                _eliminarBanda(banda.id);
              },
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              child: ListTile(
                title: Text(banda['NombreBanda']),
                subtitle: Text('Álbum: ${banda['NombreAlbum']} - Año: ${banda['AñoLanzamiento']} - Votos: ${banda['CantidadVotos']}'),
                leading: banda['imageUrl'] != null
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(banda['imageUrl']),
                      )
                    : const CircleAvatar(
                        backgroundColor: Colors.grey,
                        child: Icon(
                          Icons.music_note,
                          color: Colors.white,
                        ),
                      ),
                onTap: () {
                  _votarBanda(banda.id);
                },
                trailing: IconButton(
                  icon: const Icon(Icons.thumb_up),
                  onPressed: () {
                    _votarBanda(banda.id);
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _votarBanda(String id) async {
    CollectionReference bandas = FirebaseFirestore.instance.collection('coleccionImagen');
    DocumentSnapshot banda = await bandas.doc(id).get();
    int votosActuales = banda['CantidadVotos'];
    await bandas.doc(id).update({'CantidadVotos': votosActuales + 1});
  }

  void _eliminarBanda(String id) async {
    CollectionReference bandas = FirebaseFirestore.instance.collection('coleccionImagen');
    await bandas.doc(id).delete();
  }
}


