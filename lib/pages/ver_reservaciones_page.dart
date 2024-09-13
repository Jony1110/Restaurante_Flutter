import 'package:flutter/material.dart';
import 'package:myapp/pages/nueva_reservacion_page.dart';

class VerReservacionesPage extends StatelessWidget {
  const VerReservacionesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ver Reservaciones'),
        backgroundColor: Colors.teal,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: reservaciones.length,
        itemBuilder: (context, index) {
          final reservacion = reservaciones[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            elevation: 4,
            child: ListTile(
              title: Text('${reservacion.nombreCliente} (${reservacion.hora})'),
              subtitle: Text(
                'Personas: ${reservacion.cantidadPersonas}, Restaurante: ${reservacion.restaurante.nombre}',
              ),
            ),
          );
        },
      ),
    );
  }
}