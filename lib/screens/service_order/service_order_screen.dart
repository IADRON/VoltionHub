import 'package:flutter/material.dart';
import 'package:voltionhubapp/models/service_order.dart';
import 'package:voltionhubapp/screens/intelligent_routing/intelligent_routing_screen.dart';
import 'package:voltionhubapp/screens/service_order/service_order_details_screen.dart';
import 'package:voltionhubapp/screens/service_order/widgets/service_order_card.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ServiceOrderScreen extends StatefulWidget {
  const ServiceOrderScreen({super.key});

  @override
  State<ServiceOrderScreen> createState() => _ServiceOrderScreenState();
}

class _ServiceOrderScreenState extends State<ServiceOrderScreen> {
  List<ServiceOrder> openOrders = [];
  bool isLoading = true;
  bool _isSelectionMode = false;
  final List<ServiceOrder> _selectedOrders = [];

  @override
  void initState() {
    super.initState();
    _fetchServiceOrders();
  }

  Future<void> _fetchServiceOrders() async {
    // IMPORTANTE: Use o IP da sua máquina na rede Wi-Fi.
    final url = Uri.parse('http://192.168.100.51:3000/service-orders');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          openOrders = data.map((item) => ServiceOrder(
                // Mapeando o 'id' que vem da API
                id: item['id'],
                title: item['title'],
                address: item['address'],
                neighborhood: item['neighborhood'],
                priority: item['priority'],
                assignedTeam: item['assigned_team'],
                description: item['description'],
                timestamp: DateTime.parse(item['timestamp']),
              )).toList();
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      print(e);
      setState(() => isLoading = false);
    }
  }

  // --- FUNÇÃO DE DELETAR ---
  Future<void> _deleteOrder(int orderId) async {
    final url = Uri.parse('http://192.168.100.51:3000/service-orders/$orderId');
    try {
      final response = await http.delete(url);

      if (response.statusCode == 204) {
        setState(() {
          openOrders.removeWhere((order) => order.id == orderId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ordem de serviço deletada.'), backgroundColor: Colors.green),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Falha ao deletar a ordem.'), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro de conexão.'), backgroundColor: Colors.red),
      );
    }
  }

  void _toggleSelection(ServiceOrder order) {
    setState(() {
      if (_selectedOrders.contains(order)) {
        _selectedOrders.remove(order);
      } else {
        _selectedOrders.add(order);
      }
      if (_selectedOrders.isEmpty) {
        _isSelectionMode = false;
      }
    });
  }

  void _activateSelectionMode(ServiceOrder order) {
    setState(() {
      _isSelectionMode = true;
      _selectedOrders.add(order);
    });
  }

  void _deactivateSelectionMode() {
    setState(() {
      _isSelectionMode = false;
      _selectedOrders.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: _buildAppBar(),
        body: TabBarView(
          children: [
            _buildOrderList(openOrders),
            _buildOrderList([]), // Placeholder para "Em Andamento"
            _buildOrderList([]), // Placeholder para "Concluídas"
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    if (_isSelectionMode) {
      return AppBar(
        title: Text('${_selectedOrders.length} selecionada(s)'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: _deactivateSelectionMode,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.route),
            tooltip: 'Criar Rota Selecionada',
            onPressed: _selectedOrders.isEmpty
                ? null
                : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => IntelligentRoutingModule(
                            serviceOrders: _selectedOrders),
                      ),
                    );
                  },
          ),
        ],
      );
    } else {
      return AppBar(
        title: const Text('Ordens de Serviço'),
        bottom: const TabBar(
          tabs: [
            Tab(text: 'Abertas'),
            Tab(text: 'Em Andamento'),
            Tab(text: 'Concluídas'),
          ],
        ),
      );
    }
  }

  Widget _buildOrderList(List<ServiceOrder> orders) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (orders.isEmpty) {
      return const Center(child: Text("Nenhuma ordem de serviço encontrada."));
    }
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        final isSelected = _selectedOrders.contains(order);

        // --- ADICIONADO DISMISSIBLE PARA DELETAR ---
        return Dismissible(
          key: Key(order.id.toString()), // Chave única para o widget
          direction: DismissDirection.endToStart, // Deslizar da direita para a esquerda
          onDismissed: (direction) {
            _deleteOrder(order.id); // Chama a função para deletar
          },
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          child: ServiceOrderCard(
            order: order,
            isSelected: isSelected,
            isSelectionMode: _isSelectionMode,
            onTap: () {
              if (_isSelectionMode) {
                _toggleSelection(order);
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ServiceOrderDetailsScreen(order: order),
                  ),
                );
              }
            },
            onLongPress: () {
              if (!_isSelectionMode) {
                _activateSelectionMode(order);
              }
            },
          ),
        );
      },
    );
  }
}