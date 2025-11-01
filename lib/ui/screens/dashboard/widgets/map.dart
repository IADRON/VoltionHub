import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/core/services/location_service.dart';
import '/data/models/transformer.dart';

class MapWidget extends StatefulWidget {
  final List<Transformer> transformers;
  final Function(Transformer) onMarkerTapped;

  const MapWidget({
    super.key,
    required this.transformers,
    required this.onMarkerTapped,
  });

  @override
  State<MapWidget> createState() => dgetState();
}

class dgetState extends State<MapWidget> {
  static const LatLng _defaultLocation = LatLng(-27.59537, -48.54804);
  
  CameraPosition? _initialCameraPosition;
  bool _isLoading = true;

  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _determineInitialLocation();
    });
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _determineInitialLocation() async {
    // Adicionamos um try-catch para garantir que, se a localização falhar,
    // o app ainda funcione com a localização padrão.
    try {
      final prefs = await SharedPreferences.getInstance();
      final bool useLocation = prefs.getBool('useLocationPreference') ?? true;

      Position? userPosition;
      LatLng targetLocation = _defaultLocation;
      double targetZoom = 12.0; // Zoom padrão (cidade)

      if (useLocation) {
        // Assumindo que LocationService lida com permissões
        userPosition = await LocationService().getCurrentLocation();
      }

      if (userPosition != null) {
        targetLocation = LatLng(userPosition.latitude, userPosition.longitude);
        targetZoom = 15.0; // Zoom mais próximo (rua)
      }

      // Atualiza o estado com a posição definida
      if (mounted) {
        setState(() {
          _initialCameraPosition = CameraPosition(
            target: targetLocation,
            zoom: targetZoom,
          );
          _isLoading = false;
        });
      }
    } catch (e) {
      // Em caso de erro (ex: permissão negada), 
      // apenas usa a localização padrão e remove o loading.
      if (mounted) {
        setState(() {
          _initialCameraPosition = const CameraPosition(
            target: _defaultLocation,
            zoom: 12.0,
          );
          _isLoading = false;
        });
      }
    }
  }

  BitmapDescriptor _getMarkerColor(String status) {
    switch (status) {
      case 'online':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
      case 'offline':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
      case 'alerta':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow);
      case 'em manutencao':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
      default:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return GoogleMap(
      initialCameraPosition: _initialCameraPosition!,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      onMapCreated: (GoogleMapController controller) {
        _mapController = controller;
      },
      markers: widget.transformers.map((transformer) {
        return Marker(
          markerId: MarkerId(transformer.id),
          position: LatLng(transformer.latitude, transformer.longitude),
          icon: _getMarkerColor(transformer.status),
          onTap: () => widget.onMarkerTapped(transformer),
        );
      }).toSet(),
    );
  }
} 
