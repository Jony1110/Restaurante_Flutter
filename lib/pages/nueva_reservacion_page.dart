import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // Importa el paquete de Google Maps
import '../models/restaurante.dart';
import '../models/reservacion.dart';

List<Reservacion> reservaciones = [];

class NuevaReservacionPage extends StatefulWidget {
  const NuevaReservacionPage({super.key});

  @override
  _NuevaReservacionPageState createState() => _NuevaReservacionPageState();
}

class _NuevaReservacionPageState extends State<NuevaReservacionPage> {
  final _formKey = GlobalKey<FormState>();
  String nombreCliente = '';
  int cantidadPersonas = 1;
  Restaurante? restauranteSeleccionado;
  Sucursal? sucursalSeleccionada;
  String? horaSeleccionada;
  int? cuposRestantes;

  List<Restaurante> restaurantes = [
    Restaurante(
      nombre: 'Ember',
      capacidadMaxima: 3,
      sucursales: [
        Sucursal(nombre: 'Sucursal 1', latitud: 37.7749, longitud: -122.4194),
        Sucursal(nombre: 'Sucursal 2', latitud: 37.7799, longitud: -122.4294),
      ],
    ),
    Restaurante(
      nombre: 'Zao',
      capacidadMaxima: 4,
      sucursales: [
        Sucursal(nombre: 'Sucursal 1', latitud: 40.7128, longitud: -74.0060),
        Sucursal(nombre: 'Sucursal 2', latitud: 40.7228, longitud: -74.0160),
      ],
    ),
    Restaurante(
      nombre: 'Larimar',
      capacidadMaxima: 5,
      sucursales: [
        Sucursal(nombre: 'Sucursal 1', latitud: 34.0522, longitud: -118.2437),
        Sucursal(nombre: 'Sucursal 2', latitud: 34.0622, longitud: -118.2537),
      ],
    ),
    Restaurante(
      nombre: 'Grappa',
      capacidadMaxima: 6,
      sucursales: [
        Sucursal(nombre: 'Sucursal 1', latitud: 41.8781, longitud: -87.6298),
        Sucursal(nombre: 'Sucursal 2', latitud: 41.8881, longitud: -87.6398),
      ],
    ),
  ];

  List<String> horas = ['6 a 8 pm', '8 a 10 pm'];

  GoogleMapController? _mapController;
  LatLng? _ubicacionRestaurante;

  int cuposDisponibles(Restaurante restaurante, String hora) {
    int reservacionesActuales = reservaciones
        .where((r) => r.restaurante.nombre == restaurante.nombre && r.hora == hora)
        .fold(0, (prev, r) => prev + r.cantidadPersonas);

    return restaurante.capacidadMaxima - reservacionesActuales;
  }

  void _actualizarCuposRestantes() {
    if (restauranteSeleccionado != null && horaSeleccionada != null) {
      setState(() {
        cuposRestantes = cuposDisponibles(restauranteSeleccionado!, horaSeleccionada!);
      });
    }
  }

  void _actualizarSucursal(Sucursal? sucursal) {
    if (sucursal != null) {
      setState(() {
        _ubicacionRestaurante = LatLng(sucursal.latitud, sucursal.longitud);
      });
      _mapController?.animateCamera(CameraUpdate.newLatLng(_ubicacionRestaurante!));
    } else {
      setState(() {
        _ubicacionRestaurante = null; // Limpiar la ubicación cuando no hay sucursal
      });
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _realizarReservacion() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (cuposRestantes != null && cuposRestantes! >= cantidadPersonas) {
        if (sucursalSeleccionada != null) {
          final nuevaReservacion = Reservacion(
            nombreCliente: nombreCliente,
            cantidadPersonas: cantidadPersonas,
            restaurante: restauranteSeleccionado!,
            sucursal: sucursalSeleccionada!,
            hora: horaSeleccionada!,
          );

          reservaciones.add(nuevaReservacion);

          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Reservación realizada')));
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Seleccione una sucursal')));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No hay suficientes cupos disponibles')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Reservación'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Nombre del Cliente',
                    border: OutlineInputBorder(),
                  ),
                  onSaved: (value) => nombreCliente = value!,
                  validator: (value) => value!.isEmpty ? 'Por favor, ingrese un nombre' : null,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<Restaurante>(
                  decoration: const InputDecoration(
                    labelText: 'Restaurante',
                    border: OutlineInputBorder(),
                  ),
                  value: restauranteSeleccionado, // Inicializar el valor
                  items: restaurantes.map((r) {
                    return DropdownMenuItem<Restaurante>(
                      value: r,
                      child: Text(r.nombre),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      restauranteSeleccionado = value;
                      sucursalSeleccionada = null; // Reiniciar sucursal seleccionada
                      _actualizarCuposRestantes();
                      _actualizarSucursal(null); // Limpiar la ubicación del mapa
                    });
                  },
                  validator: (value) => value == null ? 'Seleccione un restaurante' : null,
                ),
                const SizedBox(height: 16),
                if (restauranteSeleccionado != null)
                  DropdownButtonFormField<Sucursal>(
                    decoration: const InputDecoration(
                      labelText: 'Sucursal',
                      border: OutlineInputBorder(),
                    ),
                    value: sucursalSeleccionada, // Inicializar el valor
                    items: restauranteSeleccionado!.sucursales.map((sucursal) {
                      return DropdownMenuItem<Sucursal>(
                        value: sucursal,
                        child: Text(sucursal.nombre),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        sucursalSeleccionada = value;
                        _actualizarCuposRestantes();
                        _actualizarSucursal(value); // Actualiza el mapa cuando se selecciona una sucursal
                      });
                    },
                    validator: (value) => value == null ? 'Seleccione una sucursal' : null,
                  ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Hora',
                    border: OutlineInputBorder(),
                  ),
                  value: horaSeleccionada, // Inicializar el valor
                  items: horas.map((hora) {
                    return DropdownMenuItem<String>(
                      value: hora,
                      child: Text(hora),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      horaSeleccionada = value;
                      _actualizarCuposRestantes();
                    });
                  },
                  validator: (value) => value == null ? 'Seleccione una hora' : null,
                ),
                const SizedBox(height: 16),
                if (cuposRestantes != null)
                  Text(
                    'Cupos restantes: $cuposRestantes',
                    style: const TextStyle(fontSize: 16, color: Colors.red),
                  ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Cantidad de personas',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => cantidadPersonas = int.parse(value!),
                  validator: (value) => int.tryParse(value!) == null ? 'Ingrese un número válido' : null,
                ),
                const SizedBox(height: 24),
                // Agregar el mapa si se ha seleccionado una sucursal
                if (_ubicacionRestaurante != null)
                  SizedBox(
                    height: 200,
                    child: GoogleMap(
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: CameraPosition(
                        target: _ubicacionRestaurante!,
                        zoom: 15,
                      ),
                      markers: {
                        Marker(
                          markerId: const MarkerId('restaurante'),
                          position: _ubicacionRestaurante!,
                          infoWindow: InfoWindow(
                            title: sucursalSeleccionada?.nombre ?? 'Sucursal',
                          ),
                        ),
                      },
                    ),
                  ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _realizarReservacion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Reservar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
