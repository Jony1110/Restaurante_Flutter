// Jonathan Frias;

class Sucursal {
  String nombre;
  double latitud;
  double longitud;
  int capacidadMaxima;

  Sucursal({
    required this.nombre,
    required this.latitud,
    required this.longitud,
    required this.capacidadMaxima,
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
