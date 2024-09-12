import 'restaurante.dart';

class Reservacion {
  final String nombreCliente;
  final int cantidadPersonas;
  final Restaurante restaurante;
  final String hora;

  Reservacion({required this.nombreCliente, required this.cantidadPersonas, required this.restaurante, required this.hora});
}
