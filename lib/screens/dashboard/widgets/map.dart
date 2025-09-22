import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:voltionhubapp/models/transformer.dart';

class Map extends StatelessWidget {
  final List<Transformer> transformers;
  final Function(Transformer) onMarkerTapped;

  const Map({
    super.key,
    required this.transformers,
    required this.onMarkerTapped,
  });

  BitmapDescriptor _getMarkerColor(String status) {
    switch (status) {
      case 'online':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
      case 'offline':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
      case 'alerta':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow);
      default:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: const CameraPosition(
        target: LatLng(-27.59537, -48.54804), // Coordenada inicial do mapa
        zoom: 15,
      ),
      markers: transformers.map((transformer) {
        return Marker(
          markerId: MarkerId(transformer.id),
          position: LatLng(transformer.latitude, transformer.longitude),
          icon: _getMarkerColor(transformer.status),
          onTap: () => onMarkerTapped(transformer),
        );
      }).toSet(),
    );
  }
}