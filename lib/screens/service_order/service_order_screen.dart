import 'package:flutter/material.dart';
import 'package:voltionhubapp/models/service_order.dart';
import 'package:voltionhubapp/screens/intelligent_routing/intelligent_routing_screen.dart';
import 'package:voltionhubapp/screens/service_order/service_order_details_screen.dart';
import 'package:voltionhubapp/screens/service_order/widgets/service_order_card.dart';

class ServiceOrderScreen extends StatefulWidget {
  const ServiceOrderScreen({super.key});

  @override
  State<ServiceOrderScreen> createState() => _ServiceOrderScreenState();
}

class _ServiceOrderScreenState extends State<ServiceOrderScreen> {
  // Dados de exemplo
  final List<ServiceOrder> openOrders = [
    ServiceOrder(
      title: 'Falha no Transformador #123',
      address: 'Rua das Flores, 123',
      neighborhood: 'Centro',
      priority: 'Urgente',
      assignedTeam: 'Equipe A',
      description: 'O transformador apresenta superaquecimento e ruído excessivo. Necessita de verificação imediata.'
    ),
    ServiceOrder(
      title: 'Vibração Anormal #456',
      address: 'Av. Principal, 456',
      neighborhood: 'Vila Nova',
      priority: 'Média',
      assignedTeam: 'Equipe B',
      description: 'Moradores relataram vibração incomum no poste do transformador.'
    ),
    ServiceOrder(
      title: 'Superaquecimento #789',
      address: 'Beco da Calesita, 789',
      neighborhood: 'Jardim América',
      priority: 'Alta',
      assignedTeam: 'Equipe A',
      description: 'Alerta de superaquecimento recebido pelo sistema de monitoramento.'
    ),
  ];

  // Gerenciamento de estado para o modo de seleção
  bool _isSelectionMode = false;
  final List<ServiceOrder> _selectedOrders = [];

  void _toggleSelection(ServiceOrder order) {
    setState(() {
      if (_selectedOrders.contains(order)) {
        _selectedOrders.remove(order);
      } else {
        _selectedOrders.add(order);
      }
      // Se não houver mais itens selecionados, sai do modo de seleção
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
            _buildOrderList([]), // Lista vazia para "Em Andamento"
            _buildOrderList([]), // Lista vazia para "Concluídas"
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
    if (orders.isEmpty) {
      return const Center(child: Text("Nenhuma ordem de serviço aqui."));
    }

    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        final isSelected = _selectedOrders.contains(order);

        return ServiceOrderCard(
          order: order,
          isSelected: isSelected,
          isSelectionMode: _isSelectionMode,
          onTap: () {
            if (_isSelectionMode) {
              _toggleSelection(order);
            } else {
              // Navega para os detalhes se não estiver em modo de seleção
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ServiceOrderDetailsScreen(order: order),
                ),
              );
            }
          },
          onLongPress: () {
            if (!_isSelectionMode) {
              _activateSelectionMode(order);
            }
          },
        );
      },
    );
  }
}