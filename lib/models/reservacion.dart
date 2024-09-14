import 'restaurante.dart';

class Reservacion {
  String nombreCliente;
  int cantidadPersonas;
  Restaurante restaurante;
  Sucursal sucursal;
  String hora;

  Reservacion({
    required this.nombreCliente,
    required this.cantidadPersonas,
    required this.restaurante,
    required this.sucursal,
    required this.hora,
  });
}
