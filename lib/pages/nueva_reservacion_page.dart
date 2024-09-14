import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // Importa el paquete de Google Maps
import '../models/restaurante.dart';
import '../models/reservacion.dart';

List<Reservacion> reservaciones = [];

class NuevaReservacionPage extends StatefulWidget {
  const NuevaReservacionPage({super.key});

  @override
  NuevaReservacionPageState createState() => NuevaReservacionPageState();
}

class NuevaReservacionPageState extends State<NuevaReservacionPage> {
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
        Sucursal(nombre: 'Sucursal 1', latitud: 37.7749, longitud: -122.4194, capacidadMaxima: 2),
        Sucursal(nombre: 'Sucursal 2', latitud: 37.7799, longitud: -122.4294, capacidadMaxima: 3),
      ],
    ),
    Restaurante(
      nombre: 'Zao',
      capacidadMaxima: 4,
      sucursales: [
        Sucursal(nombre: 'Sucursal 1', latitud: 40.7128, longitud: -74.0060, capacidadMaxima: 2),
        Sucursal(nombre: 'Sucursal 2', latitud: 40.7228, longitud: -74.0160, capacidadMaxima: 2),
      ],
    ),
    Restaurante(
      nombre: 'Larimar',
      capacidadMaxima: 5,
      sucursales: [
        Sucursal(nombre: 'Sucursal 1', latitud: 34.0522, longitud: -118.2437, capacidadMaxima: 3),
        Sucursal(nombre: 'Sucursal 2', latitud: 34.0622, longitud: -118.2537, capacidadMaxima: 2),
      ],
    ),
    Restaurante(
      nombre: 'Grappa',
      capacidadMaxima: 6,
      sucursales: [
        Sucursal(nombre: 'Sucursal 1', latitud: 41.8781, longitud: -87.6298, capacidadMaxima: 3),
        Sucursal(nombre: 'Sucursal 2', latitud: 41.8881, longitud: -87.6398, capacidadMaxima: 3),
      ],
    ),
    Restaurante(
      nombre: 'Jade Teriyaki',
      capacidadMaxima: 6,
      sucursales: [
        Sucursal(nombre: 'Plaza cuadra, Prol. Av. 27 de Febrero', latitud: 18.498443955832833, longitud: -69.99969485422658, capacidadMaxima: 3),
        Sucursal(nombre: 'Plaza Lama, Autop. Juan Pablo Duarte 13', latitud: 18.499066946144247, longitud: -69.99443400000256, capacidadMaxima: 3),
        Sucursal(nombre: 'Av. República de Colombia, Santo Domingo', latitud: 18.506814082062398, longitud: -69.98422110001916, capacidadMaxima: 3),
        Sucursal(nombre: 'Plaza Duarte, Autop. Juan Pablo Duarte 10 1/2', latitud: 18.48923611797026, longitud: -69.97792460001915, capacidadMaxima: 3),
        Sucursal(nombre: 'Centro Occidental Mall, Av. 27 de Febrero', latitud: 18.48557313370175, longitud: -69.99997945891475, capacidadMaxima: 3),
        Sucursal(nombre: 'Garden Plaza BTI, Av. de los Próceres 123', latitud: 18.488509046085195, longitud: -69.96309360001915, capacidadMaxima: 2),
        Sucursal(nombre: 'C. Cam. Chiquito, Santo Domingo', latitud: 18.497128056087085, longitud:  -69.93964887915607, capacidadMaxima: 2),
        Sucursal(nombre: 'Foodcourt, Jumbo Luperon, Av. Gregorio Luperón', latitud: 18.4633226819817, longitud: -69.96844040001915, capacidadMaxima: 2),
        Sucursal(nombre: 'Avenida Winston Churchill, Multicentro La Sirena', latitud: 18.47294408199953, longitud:-69.94258890001916, capacidadMaxima: 2),
      ],
    ),
  ];

  List<String> horas = ['6 a 8 pm', '8 a 10 pm'];

  GoogleMapController? _mapController;
  LatLng? _ubicacionRestaurante;

  // Función para calcular cupos disponibles por sucursal
  int cuposDisponiblesPorSucursal(Sucursal sucursal, String hora) {
    int reservacionesActuales = reservaciones
        .where((r) => r.sucursal.nombre == sucursal.nombre && r.hora == hora)
        .fold(0, (prev, r) => prev + r.cantidadPersonas);

    return sucursal.capacidadMaxima - reservacionesActuales;
  }

  void _actualizarCuposRestantes() {
    if (sucursalSeleccionada != null && horaSeleccionada != null) {
      setState(() {
        cuposRestantes = cuposDisponiblesPorSucursal(sucursalSeleccionada!, horaSeleccionada!);
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
                      _actualizarSucursal(null); // Limpiar mapa
                    });
                  },
                ),
                const SizedBox(height: 16),
                // Mostrar solo si se ha seleccionado un restaurante
                if (restauranteSeleccionado != null)
                  DropdownButtonFormField<Sucursal>(
                    decoration: const InputDecoration(
                      labelText: 'Sucursal',
                      border: OutlineInputBorder(),
                    ),
                    value: sucursalSeleccionada, // Inicializar el valor
                    items: restauranteSeleccionado?.sucursales.map((s) {
                      return DropdownMenuItem<Sucursal>(
                        value: s,
                        child: Text(s.nombre),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        sucursalSeleccionada = value;
                        _actualizarCuposRestantes();
                        _actualizarSucursal(sucursalSeleccionada);
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
                  items: horas.map((h) {
                    return DropdownMenuItem<String>(
                      value: h,
                      child: Text(h),
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
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Cantidad de Personas',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  initialValue: cantidadPersonas.toString(),
                  onSaved: (value) => cantidadPersonas = int.parse(value!),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Ingrese la cantidad de personas';
                    }
                    final intValue = int.parse(value);
                    if (intValue <= 0) {
                      return 'Ingrese un número válido de personas';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Mostrar cupos restantes con color
                if (cuposRestantes != null)
                  Text(
                    cuposRestantes! > 0
                        ? 'Cupos restantes: $cuposRestantes'
                        : 'No hay cupos disponibles',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: cuposRestantes! > 0 ? Colors.green : Colors.red, // Color según disponibilidad
                    ),
                  ),
                const SizedBox(height: 16),
                // Agregamos el mapa
                if (_ubicacionRestaurante != null)
                  Container(
                    height: 300,
                    width: double.infinity,
                    child: GoogleMap(
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: CameraPosition(
                        target: _ubicacionRestaurante!,
                        zoom: 14,
                      ),
                      markers: {
                        Marker(
                          markerId: const MarkerId('sucursal'),
                          position: _ubicacionRestaurante!,
                        ),
                      },
                    ),
                  ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _realizarReservacion,
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
