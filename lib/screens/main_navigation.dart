// lib/screens/main_navigation.dart

import 'package:flutter/material.dart';
import 'package:voltionhubapp/screens/dashboard/dashboard_screen.dart';
import 'package:voltionhubapp/screens/profile/profile_screen.dart';
import 'package:voltionhubapp/screens/service_order/service_order_screen.dart';
import 'package:voltionhubapp/screens/branches/branches_screen.dart'; // Import BranchesScreen
import 'package:voltionhubapp/screens/teams/teams_screen.dart'; // Import TeamsScreen
import 'package:voltionhubapp/theme/app_colors.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  // Adicione as novas telas à lista de widgets
  static const List<Widget> _widgetOptions = <Widget>[
    DashboardScreen(),
    ServiceOrderScreen(),
    BranchesScreen(), // Aba de Sedes
    TeamsScreen(),    // Aba de Equipes
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        // Aumente o número de items
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Mapa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Ordens de Serviço',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business), // Ícone para Sedes
            label: 'Sedes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group), // Ícone para Equipes
            label: 'Equipes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.laranjaVoltion,
        unselectedItemColor: Colors.grey, // Adicione para melhor visualização
        onTap: _onItemTapped,
      ),
    );
  }
}