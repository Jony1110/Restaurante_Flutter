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
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Ember'),
            onTap: () {
              _mostrarReservaciones(context, 'Ember');
            },
          ),
          ListTile(
            title: const Text('Zao'),
            onTap: () {
              _mostrarReservaciones(context, 'Zao');
            },
          ),
          ListTile(
            title: const Text('Grappa'),
            onTap: () {
              _mostrarReservaciones(context, 'Grappa');
            },
          ),
          ListTile(
            title: const Text('Larimar'),
            onTap: () {
              _mostrarReservaciones(context, 'Larimar');
            },
          ),
        ],
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
                return ListTile(
                  title: Text('${reservacion.nombreCliente} (${reservacion.hora})'),
                  subtitle: Text('Personas: ${reservacion.cantidadPersonas}'),
                  onTap: () {
                    Navigator.of(context).pop(); // Cierra el diálogo
                    _generarPdf(context, reservacion);
                  },
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

    // Muestra el PDF en una vista previa antes de imprimir
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}
