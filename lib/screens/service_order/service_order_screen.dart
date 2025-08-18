import 'package:flutter/material.dart';
import '../../models/service_order.dart';
import '../intelligent_routing/intelligent_routing_screen.dart';

// Convertido para StatefulWidget para gerenciar o estado da seleção
class ServiceOrderScreen extends StatefulWidget {
  ServiceOrderScreen({super.key});

  @override
  State<ServiceOrderScreen> createState() => _ServiceOrderScreenState();
}

class _ServiceOrderScreenState extends State<ServiceOrderScreen> {
  // Lista de ordens de serviço (dados de exemplo)
  final List<ServiceOrder> openOrders = [
    ServiceOrder(
      title: 'Falha no Transformador #123',
      address: 'Rua das Flores, 123',
      neighborhood: 'Centro',
      priority: 'Urgente',
      assignedTeam: 'Equipe A',
    ),
    ServiceOrder(
      title: 'Vibração Anormal #456',
      address: 'Av. Principal, 456',
      neighborhood: 'Vila Nova',
      priority: 'Média',
      assignedTeam: 'Equipe B',
    ),
    ServiceOrder(
      title: 'Superaquecimento #789',
      address: 'Beco da Calesita, 789',
      neighborhood: 'Jardim América',
      priority: 'Alta',
      assignedTeam: 'Equipe A',
    ),
  ];

  // Nova lista para controlar as ordens de serviço selecionadas
  final List<ServiceOrder> selectedOrders = [];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Ordens de Serviço'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Abertas'),
              Tab(text: 'Em Andamento'),
              Tab(text: 'Concluídas'),
            ],
          ),
          actions: [
            // O botão de roteirização agora só é clicável se houver ordens selecionadas
            IconButton(
              icon: const Icon(Icons.route),
              tooltip: 'Criar Rota Selecionada',
              onPressed: selectedOrders.isEmpty
                  ? null // Desabilita o botão se nenhuma OS for selecionada
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => IntelligentRoutingModule(
                              serviceOrders: selectedOrders),
                        ),
                      );
                    },
            ),
          ],
        ),
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

  // O método agora constrói a lista com a lógica de seleção
  Widget _buildOrderList(List<ServiceOrder> orders) {
    if (orders.isEmpty) {
      return const Center(child: Text("Nenhuma ordem de serviço aqui."));
    }

    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        final isSelected = selectedOrders.contains(order);

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: ListTile(
            // Checkbox para seleção
            leading: Checkbox(
              value: isSelected,
              onChanged: (bool? value) {
                setState(() {
                  if (value == true) {
                    selectedOrders.add(order);
                  } else {
                    selectedOrders.remove(order);
                  }
                });
              },
            ),
            title: Text(order.title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${order.address}, ${order.neighborhood}'),
                Chip(
                  label: Text(
                    order.priority,
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: order.priority == 'Urgente'
                      ? Colors.red
                      : Colors.orange,
                  padding: const EdgeInsets.all(2),
                ),
              ],
            ),
            trailing: Text(order.assignedTeam),
            onTap: () {
              // Lógica para ver detalhes da OS
            },
          ),
        );
      },
    );
  }
}