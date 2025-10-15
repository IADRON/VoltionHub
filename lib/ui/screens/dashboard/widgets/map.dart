import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/core/services/location_service.dart';
import '/data/models/transformer.dart';

class Map extends StatefulWidget {
  final List<Transformer> transformers;
  final Function(Transformer) onMarkerTapped;

  const Map({
    super.key,
    required this.transformers,
    required this.onMarkerTapped,
  });

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  static const LatLng _defaultLocation = LatLng(-27.59537, -48.54804); 
  
  CameraPosition _initialCameraPosition = const CameraPosition(
    target: _defaultLocation,
    zoom: 12,
  );

  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _loadInitialLocation();
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _loadInitialLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final bool useLocation = prefs.getBool('useLocationPreference') ?? true;

    Position? userPosition;

    if (useLocation) {
      userPosition = await LocationService().getCurrentLocation();
    }

    if (userPosition != null) {
      final newPosition = CameraPosition(
        target: LatLng(userPosition.latitude, userPosition.longitude),
        zoom: 15,
      );

      if (mounted) {
        setState(() {
          _initialCameraPosition = newPosition;
        });
      }

      if (_mapController != null) {
        _mapController!.animateCamera(CameraUpdate.newCameraPosition(newPosition));
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
      default:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: _initialCameraPosition, 
      myLocationEnabled: true, 
      myLocationButtonEnabled: true,
      onMapCreated: (GoogleMapController controller) {
        _mapController = controller;
        _loadInitialLocation();
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