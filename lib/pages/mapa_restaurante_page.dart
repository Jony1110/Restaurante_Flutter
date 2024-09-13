import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapaRestaurantePage extends StatefulWidget {
  const MapaRestaurantePage({super.key});

  @override
  _MapaRestaurantePageState createState() => _MapaRestaurantePageState();
}

class _MapaRestaurantePageState extends State<MapaRestaurantePage> {
  // Configura la ubicación del restaurante
  final LatLng _ubicacionRestaurante = LatLng(37.7749, -122.4194); // Lat y Long del restaurante

  GoogleMapController? _mapController;

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ubicación del Restaurante'),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _ubicacionRestaurante,
          zoom: 15,
        ),
        markers: {
          Marker(
            markerId: MarkerId('restaurante'),
            position: _ubicacionRestaurante,
            infoWindow: InfoWindow(title: 'Restaurante'),
          ),
        },
      ),
    );
  }
}
