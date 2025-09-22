// lib/screens/main_navigation.dart

import 'package:flutter/material.dart';
import 'package:voltionhubapp/core/common/constants/theme/app_colors.dart';
import 'package:voltionhubapp/core/common/constants/theme/app_icons.dart';
import 'package:voltionhubapp/screens/dashboard/dashboard_screen.dart';
import 'package:voltionhubapp/screens/profile/profile_screen.dart';
import 'package:voltionhubapp/screens/service_order/service_order_screen.dart';
import 'package:voltionhubapp/screens/branches/branches_screen.dart';
import 'package:voltionhubapp/screens/teams/teams_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    DashboardScreen(),
    ServiceOrderScreen(),
    BranchesScreen(),
    TeamsScreen(),   
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
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(AppIcons.navMap),
            activeIcon: Icon(AppIcons.navMapOn),
            label: 'Mapa',
          ),
          BottomNavigationBarItem(
            icon: Icon(AppIcons.navOS),
            activeIcon: Icon(AppIcons.navOSOn),
            label: 'Ordens de Serviço',
          ),
          BottomNavigationBarItem(
            icon: Icon(AppIcons.navBranches),
            activeIcon: Icon(AppIcons.navBranchesOn),
            label: 'Sedes',
          ),
          BottomNavigationBarItem(
            icon: Icon(AppIcons.navTeams),
            activeIcon: Icon(AppIcons.navTeamsOn),
            label: 'Equipes',
          ),
          BottomNavigationBarItem(
            icon: Icon(AppIcons.navProfile),
            activeIcon: Icon(AppIcons.navProfileOn),
            label: 'Perfil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.orange,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}