import 'package:flutter/material.dart';
import 'package:voltionhubapp/models/service_order.dart';
import 'package:voltionhubapp/screens/intelligent_routing/intelligent_routing_screen.dart';
import 'package:voltionhubapp/screens/service_order/service_order_details_screen.dart';
import 'package:voltionhubapp/screens/service_order/widgets/service_order_card.dart';
import '../service_order/widgets/os_form_screen.dart';

class ServiceOrderScreen extends StatefulWidget {
  const ServiceOrderScreen({super.key});

  @override
  State<ServiceOrderScreen> createState() => _ServiceOrderScreenState();
}

class _ServiceOrderScreenState extends State<ServiceOrderScreen> {
  // Dados de exemplo atualizados
  final List<ServiceOrder> openOrders = [
    ServiceOrder(
        title: 'Falha no Transformador #123',
        address: 'Rua das Flores, 123',
        neighborhood: 'Centro',
        priority: 'Urgente',
        assignedTeam: 'Equipe A',
        description:
            'O transformador apresenta superaquecimento e ruído excessivo. Necessita de verificação imediata.',
        timestamp: DateTime.now().subtract(const Duration(hours: 1))),
    ServiceOrder(
        title: 'Vibração Anormal #456',
        address: 'Av. Principal, 456',
        neighborhood: 'Vila Nova',
        priority: 'Média',
        assignedTeam: 'Equipe B',
        description:
            'Moradores relataram vibração incomum no poste do transformador.',
        timestamp: DateTime.now().subtract(const Duration(hours: 4))),
    ServiceOrder(
        title: 'Manutenção Preventiva #789',
        address: 'Beco da Calesita, 789',
        neighborhood: 'Jardim América',
        priority: 'Baixa',
        assignedTeam: 'Equipe A',
        description: 'Verificação de rotina agendada para hoje.',
        timestamp: DateTime.now().subtract(const Duration(days: 1))),
  ];

  final List<ServiceOrder> inProgressOrders = [
    ServiceOrder(
        title: 'Superaquecimento #789',
        address: 'Beco da Calesita, 789',
        neighborhood: 'Jardim América',
        priority: 'Em Andamento',
        assignedTeam: 'Equipe A',
        description:
            'Alerta de superaquecimento recebido pelo sistema de monitoramento.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 30))),
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
            _buildOrderList(inProgressOrders),
            _buildOrderList([]),
          ],
        ),
        floatingActionButton: !_isSelectionMode ? FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const OsFormScreen()),
            );
          },
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: const Icon(Icons.add),
        ) : null,
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
        );
      },
    );
  }
}