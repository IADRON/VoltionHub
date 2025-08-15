import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../screens/dashboard/dashboard_screen.dart'; // Importa a classe Transformer

class Map extends StatelessWidget {
  final List<Transformer> transformers;
  final Function(Transformer) onMarkerTapped;

  const Map({
    super.key,
    required this.transformers,
    required this.onMarkerTapped,
  });

  // Define a cor do marcador com base no status do transformador[cite: 110, 111, 112].
  BitmapDescriptor _getMarkerColor(String status) {
    switch (status) {
      case 'online':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen); // Verde para online
      case 'offline':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed); // Vermelho para offline
      case 'alerta':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow); // Amarelo para alerta
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