import 'package:flutter/material.dart';
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
  String? horaSeleccionada;
  int? cuposRestantes; 

  List<Restaurante> restaurantes = [
    Restaurante(nombre: 'Ember', capacidadMaxima: 3),
    Restaurante(nombre: 'Zao', capacidadMaxima: 4),
    Restaurante(nombre: 'Grappa', capacidadMaxima: 2),
    Restaurante(nombre: 'Larimar', capacidadMaxima: 3),
  ];

  List<String> horas = ['6 a 8 pm', '8 a 10 pm'];

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

  void _realizarReservacion() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (cuposRestantes != null && cuposRestantes! >= cantidadPersonas) {
        final nuevaReservacion = Reservacion(
          nombreCliente: nombreCliente,
          cantidadPersonas: cantidadPersonas,
          restaurante: restauranteSeleccionado!,
          hora: horaSeleccionada!,
        );
        
        reservaciones.add(nuevaReservacion);

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Reservación realizada')));
        Navigator.pop(context);
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
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
                items: restaurantes.map((r) {
                  return DropdownMenuItem<Restaurante>(
                    value: r,
                    child: Text(r.nombre),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    restauranteSeleccionado = value;
                    _actualizarCuposRestantes(); 
                  });
                },
                validator: (value) => value == null ? 'Seleccione un restaurante' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Hora',
                  border: OutlineInputBorder(),
                ),
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
    );
  }
}
// Jonathan Frias