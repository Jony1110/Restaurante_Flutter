import 'package:flutter/material.dart';
import 'nueva_reservacion_page.dart';
import 'ver_reservaciones_page.dart';
import 'imprimir_reservaciones_page.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sistema de Reservaciones'),
        centerTitle: true,
        backgroundColor: Colors.teal, 
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Seleccione una opción',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            _buildMenuOption(
              context,
              'Realizar una nueva reservación',
              Icons.restaurant_menu,
              Colors.blueAccent,
              const NuevaReservacionPage(),
            ),
            const SizedBox(height: 20),
            _buildMenuOption(
              context,
              'Ver las reservaciones',
              Icons.view_list,
              Colors.orangeAccent,
              const VerReservacionesPage(),
            ),
            const SizedBox(height: 20),
            _buildMenuOption(
              context,
              'Imprimir reservaciones por restaurante',
              Icons.print,
              Colors.green,
              const ImprimirReservacionesPage(),
            ),
          ],
        ),
      ),
    );
  }

  
  Widget _buildMenuOption(
      BuildContext context, String title, IconData icon, Color color, Widget page) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Icon(icon, color: color, size: 30),
        title: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: color),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => page));
        },
      ),
    );
  }
}