// location_service.dart
import 'package:geolocator/geolocator.dart';

class LocationService {
  // ... métodos de verificação e solicitação (mantidos do seu código original)
  Future<bool> isServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  Future<LocationPermission> checkPermission() async {
    return await Geolocator.checkPermission();
  }

  Future<LocationPermission> requestPermission() async {
    return await Geolocator.requestPermission();
  }

  Future<bool> openAppSettings() async {
    return await Geolocator.openAppSettings();
  }

  Future<Position?> getCurrentLocation() async {
    bool serviceEnabled = await isServiceEnabled();
    if (!serviceEnabled) {
      // O serviço de GPS do dispositivo está desativado
      return null;
    }

    LocationPermission permission = await checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await requestPermission();
    }
    
    // Verifica novamente se a permissão foi negada
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      return null;
    }
    
    // Obtém a posição
    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high
      );
    } catch (e) {
      print("Erro ao obter a localização: $e");
      return null;
    }
  }
}