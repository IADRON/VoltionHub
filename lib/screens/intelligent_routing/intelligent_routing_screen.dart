import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../models/service_order.dart';

class IntelligentRoutingModule extends StatelessWidget {
  final List<ServiceOrder> serviceOrders;

  const IntelligentRoutingModule({super.key, required this.serviceOrders});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Roteirização Inteligente'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(-27.59537, -48.54804),
                zoom: 12,
              ),
              markers: serviceOrders.map((order) {
                // Para um aplicativo real, você precisaria de um geocodificador para converter o endereço em coordenadas
                return Marker(
                  markerId: MarkerId(order.title),
                  position: const LatLng(-27.59537, -48.54804), // Coordenada de exemplo
                  infoWindow: InfoWindow(
                    title: order.title,
                    snippet: order.address,
                  ),
                );
              }).toSet(),
            ),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tempo Estimado: 2h 30m',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Distância Total: 45 km',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: ListView.builder(
              itemCount: serviceOrders.length,
              itemBuilder: (context, index) {
                final order = serviceOrders[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text('${index + 1}'),
                  ),
                  title: Text(order.title),
                  subtitle: Text(order.address),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Lógica para abrir o Waze ou Google Maps
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // Lógica para iniciar a navegação
              },
              child: const Text('Iniciar Navegação'),
            ),
          ),
        ],
      ),
    );
  }
}