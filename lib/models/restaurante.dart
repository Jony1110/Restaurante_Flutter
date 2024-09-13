// Jonathan Frias;

class Sucursal {
  final String nombre;
  final double latitud;
  final double longitud;

  Sucursal({
    required this.nombre,
    required this.latitud,
    required this.longitud,
  });
}

class Restaurante {
  final String nombre;
  final int capacidadMaxima;
  final List<Sucursal> sucursales;

  Restaurante({
    required this.nombre,
    required this.capacidadMaxima,
    required this.sucursales,
  });
}
