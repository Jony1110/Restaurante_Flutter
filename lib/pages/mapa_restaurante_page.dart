import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// Jonathan Frias;

class MapaRestaurantePage extends StatefulWidget {
  const MapaRestaurantePage({super.key});

  @override
  MapaRestaurantePageState createState() => MapaRestaurantePageState();
}

class MapaRestaurantePageState extends State<MapaRestaurantePage> {

  final LatLng _ubicacionRestaurante = const LatLng(37.7749, -122.4194); 

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
            markerId: const MarkerId('restaurante'),
            position: _ubicacionRestaurante,
            infoWindow: const InfoWindow(title: 'Restaurante'),
          ),
        },
      ),
    );
  }
}
