// Jonathan Frias;

import 'restaurante.dart';

class Reservacion {
  final String nombreCliente;
  final String correoCliente;
  final int cantidadPersonas;
  final Restaurante restaurante;
  final Sucursal sucursal;
  final String hora;

  Reservacion({
    required this.nombreCliente,
    required this.correoCliente, 
    required this.cantidadPersonas,
    required this.restaurante,
    required this.sucursal,
    required this.hora,
  });
}

