// Jonathan Frias;

// restaurante.dart
class Restaurante {
  final String nombre;
  final int capacidadMaxima;
  final double latitud;  // Agregar latitud
  final double longitud; // Agregar longitud

  Restaurante({
    required this.nombre,
    required this.capacidadMaxima,
    required this.latitud,  // Inicializar latitud
    required this.longitud, // Inicializar longitud
  });
}
