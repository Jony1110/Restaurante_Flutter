import 'package:flutter/material.dart';
import 'package:myapp/pages/nueva_reservacion_page.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import '../models/reservacion.dart';

class ImprimirReservacionesPage extends StatelessWidget {
  const ImprimirReservacionesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Imprimir Reservaciones'),
        backgroundColor: Colors.teal, 
      ),
      body: Padding(
        padding: const EdgeInsets.all(16), 
        child: ListView(
          children: [
            _buildRestaurantTile(context, 'Ember'),
            _buildRestaurantTile(context, 'Zao'),
            _buildRestaurantTile(context, 'Grappa'),
            _buildRestaurantTile(context, 'Larimar'),
          ],
        ),
      ),
    );
  }

  Widget _buildRestaurantTile(BuildContext context, String nombreRestaurante) {
    final reservacionesRestaurante = reservaciones
        .where((r) => r.restaurante.nombre == nombreRestaurante)
        .toList();

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8), 
      elevation: 4, 
      child: ListTile(
        title: Text(nombreRestaurante, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Número de reservaciones: ${reservacionesRestaurante.length}'),
        trailing: const Icon(Icons.arrow_forward_ios), 
        onTap: () {
          _mostrarReservaciones(context, nombreRestaurante);
        },
      ),
    );
  }

  void _mostrarReservaciones(BuildContext context, String nombreRestaurante) {
    final reservacionesRestaurante = reservaciones
        .where((r) => r.restaurante.nombre == nombreRestaurante)
        .toList();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Reservaciones - $nombreRestaurante'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: reservacionesRestaurante.length,
              itemBuilder: (context, index) {
                final reservacion = reservacionesRestaurante[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  elevation: 4,
                  child: ListTile(
                    title: Text('${reservacion.nombreCliente} (${reservacion.hora})'),
                    subtitle: Text('Personas: ${reservacion.cantidadPersonas}'),
                    trailing: const Icon(Icons.picture_as_pdf), 
                    onTap: () {
                      Navigator.of(context).pop();
                      _generarPdf(context, reservacion);
                    },
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _generarPdf(BuildContext context, Reservacion reservacion) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text('Detalles de la Reservación', style: const pw.TextStyle(fontSize: 24)),
              pw.SizedBox(height: 16),
              pw.Text('Nombre del Cliente: ${reservacion.nombreCliente}'),
              pw.Text('Restaurante: ${reservacion.restaurante.nombre}'),
              pw.Text('Hora: ${reservacion.hora}'),
              pw.Text('Cantidad de Personas: ${reservacion.cantidadPersonas}'),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}

// Jonathan Frias //