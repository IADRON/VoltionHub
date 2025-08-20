import 'package:url_launcher/url_launcher.dart';

class MapsService {
  MapsService._(); // Construtor privado para evitar instanciação

  static Future<void> openMap(double latitude, double longitude) async {
    // Tenta abrir no Google Maps
    Uri googleUrl = Uri.parse('https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');
    
    // Tenta abrir no Waze
    Uri wazeUrl = Uri.parse('https://waze.com/ul?ll=$latitude,$longitude&navigate=yes');

    if (await canLaunchUrl(googleUrl)) {
      await launchUrl(googleUrl);
    } else if (await canLaunchUrl(wazeUrl)) {
      await launchUrl(wazeUrl);
    } else {
      throw 'Não foi possível abrir nenhum aplicativo de mapa.';
    }
  }
}