import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/core/services/location_service.dart';

class SecuritySettingsScreen extends StatefulWidget {
  const SecuritySettingsScreen({super.key});

  @override
  State<SecuritySettingsScreen> createState() => _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState extends State<SecuritySettingsScreen> {
  // O estado do switch no app, não é o estado da permissão do sistema
  bool _isLocationEnabledInApp = true; 

  @override
  void initState() {
    super.initState();
    _loadLocationSetting();
  }

  Future<void> _loadLocationSetting() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // Carrega o valor salvo ou usa 'true' (ativado) como padrão
      _isLocationEnabledInApp = prefs.getBool('useLocationPreference') ?? true;
    });
  }

  Future<void> _toggleLocationSetting(bool newValue) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('useLocationPreference', newValue);

    setState(() {
      _isLocationEnabledInApp = newValue;
    });

    if (newValue) {
      // Se o usuário ativou, verificamos e solicitamos a permissão do sistema
      LocationPermission permission = await LocationService().checkPermission();
      
      if (permission == LocationPermission.denied) {
        // Solicita a permissão se ainda não foi solicitada
        await LocationService().requestPermission();
      } else if (permission == LocationPermission.deniedForever) {
        // Exibe um diálogo se a permissão foi negada permanentemente
        _showPermissionDeniedDialog();
      }
    }
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permissão Necessária'),
        content: const Text(
          'A permissão de localização foi negada permanentemente. Para usar este recurso, ative-a nas configurações do sistema.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              LocationService().openAppSettings(); // Abre as configurações do app na OS
            },
            child: const Text('Abrir Configurações'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacidade & Segurança'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          SwitchListTile(
            title: const Text('Localização'),
            subtitle: const Text('Permitir que o VoltionHub acesse sua localização'),
            value: _isLocationEnabledInApp,
            onChanged: _toggleLocationSetting,
            secondary: const Icon(Icons.location_on),
          ),
          SwitchListTile(
            title: const Text('Autenticação Biométrica'),
            subtitle: const Text('Usar impressão digital para login'),
            value: false,
            onChanged: (bool value) {},
            secondary: const Icon(Icons.fingerprint),
          ),
          const ListTile(
            title: Text('Autenticação de Dois Fatores (2FA)'),
            subtitle: Text('Desativado'),
            leading: Icon(Icons.phonelink_lock),
          ),
        ],
      ),
    );
  }
}