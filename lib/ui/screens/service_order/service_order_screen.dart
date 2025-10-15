import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart' as http;
import 'service_order_details_screen.dart';
import 'widgets/service_order_card.dart';
import '/core/services/api/api_service.dart';
import '/data/models/service_order.dart';
import '/ui/screens/intelligent_routing/intelligent_routing_screen.dart';
import '/ui/widgets/textfield.dart';

class ServiceOrderScreen extends StatefulWidget {
  const ServiceOrderScreen({super.key});

  @override
  State<ServiceOrderScreen> createState() => _ServiceOrderScreenState();
}

class _ServiceOrderScreenState extends State<ServiceOrderScreen> {
  List<ServiceOrder> allOrders = [];
  List<ServiceOrder> openOrders = [];
  List<ServiceOrder> inProgressOrders = [];

  bool isLoading = true;
  bool _isSelectionMode = false;
  final List<ServiceOrder> _selectedOrders = [];

  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _fetchServiceOrders();
  }

  Future<void> _fetchServiceOrders() async {
    final url = Uri.parse('${_apiService.baseUrl}/service-orders');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          allOrders = data.map((item) => ServiceOrder(
                id: item['id'],
                transformer: item['transformer_id'],
                address: item['address'],
                neighborhood: item['neighborhood'],
                priority: item['priority'],
                assignedTeam: item['assigned_team'],
                problem: item['problem'],
                timestamp: DateTime.parse(item['timestamp']),
              )).toList();

          // Filtrar as ordens para as duas listas
          openOrders = allOrders.where((order) => order.priority != "Em Andamento").toList();
          inProgressOrders = allOrders.where((order) => order.priority == "Em Andamento").toList();

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

  Future<void> _deleteOrder(int orderId, String? reason) async {
    final url = Uri.parse('${_apiService.baseUrl}/service-orders/$orderId');
    try {
      print('Tentando deletar Ordem ID: $orderId, Motivo: ${reason ?? "Não fornecido"}');

      final response = await http.delete(url);

      if (response.statusCode == 204) {
        setState(() {
          allOrders.removeWhere((order) => order.id == orderId);
          // Refiltrar as listas após a exclusão
          openOrders = allOrders.where((order) => order.priority != "Em Andamento").toList();
          inProgressOrders = allOrders.where((order) => order.priority == "Em Andamento").toList();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ordem de serviço deletada. Motivo: $reason'), backgroundColor: Colors.green),
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

  // Novo método para mostrar o diálogo de confirmação
  Future<String?> _showDeleteConfirmationDialog(BuildContext context, ServiceOrder order) async {
    final TextEditingController deleteReasonController = TextEditingController(); // Controller para o campo de texto
    return showDialog<String?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Você tem certeza que deseja deletar a ordem de serviço ${order.id}?'),
                const Gap(10),
                CustomTextField(
                  controller: deleteReasonController, // Atribuído o controller
                  icon: Icons.notes,
                  labelText: 'Motivo da exclusão',
                  maxLines: 1,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                // deleteReasonController.dispose(); // Não descartar aqui para evitar DoubleDispose se o diálogo for reconstruído
                Navigator.of(context).pop(null); // Retorna null se cancelar
              },
            ),
            TextButton(
              child: const Text('Confirmar'),
              onPressed: () {
                final String reason = deleteReasonController.text;
                // deleteReasonController.dispose(); // Não descartar aqui
                Navigator.of(context).pop(reason); // Retorna o motivo digitado
              },
            ),
          ],
        );
      },
    ).whenComplete(() {
      deleteReasonController.dispose(); // Discartar o controller quando o diálogo for fechado, independentemente do botão clicado.
    });
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
      length: 2,
      child: Scaffold(
        appBar: _buildAppBar(),
        body: TabBarView(
          children: [
            _buildOrderList(openOrders),
            _buildOrderList(inProgressOrders),
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
        bottom: TabBar(
          tabs: [
            Tab(text: 'Abertas'),
            Tab(text: 'Em Andamento'),
          ],
          dividerColor: Theme.of(context).colorScheme.background,
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

        return Dismissible(
          key: Key(order.id.toString()),
          direction: DismissDirection.endToStart,
          confirmDismiss: (direction) async {
            final reason = await _showDeleteConfirmationDialog(context, order);
            if (reason != null && reason.isNotEmpty) {
              await _deleteOrder(order.id, reason);
              return true;
            } else if (reason != null && reason.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Por favor, forneça um motivo para a exclusão.'), backgroundColor: Colors.orange),
              );
              return false;
            }
            return false;
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