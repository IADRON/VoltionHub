import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Map extends StatefulWidget {
  const Map({super.key});

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  // Coordenadas de exemplo
  static const LatLng _pGooglePlex = LatLng(37.4223, -122.0848);

  @override
  Widget build(BuildContext context) {
    return const GoogleMap(
      initialCameraPosition: CameraPosition(
        target: _pGooglePlex,
        zoom: 13,
      ),
    );
  }
}