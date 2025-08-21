import 'package:flutter/material.dart';
import 'package:voltionhubapp/models/service_order.dart';
import 'package:voltionhubapp/widgets/custom_button.dart';
import 'package:voltionhubapp/widgets/custom_textfield.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OsFormScreen extends StatefulWidget {
  final ServiceOrder? order;

  const OsFormScreen({super.key, this.order});

  @override
  State<OsFormScreen> createState() => _OsFormScreenState();
}

class _OsFormScreenState extends State<OsFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _addressController;
  late TextEditingController _neighborhoodController;
  late TextEditingController _teamController;
  late TextEditingController _descriptionController;
  String _priority = 'Baixa';

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.order?.title ?? '');
    _addressController = TextEditingController(text: widget.order?.address ?? '');
    _neighborhoodController = TextEditingController(text: widget.order?.neighborhood ?? '');
    _teamController = TextEditingController(text: widget.order?.assignedTeam ?? '');
    _descriptionController = TextEditingController(text: widget.order?.description ?? '');
    _priority = widget.order?.priority ?? 'Baixa';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _addressController.dispose();
    _neighborhoodController.dispose();
    _teamController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
  
  // --- FUNÇÃO DE SALVAR ---
  Future<void> _saveOrder() async {
    if (_formKey.currentState!.validate()) {
      // Substitua pelo IP da sua máquina
      final url = Uri.parse('http://192.168.100.51:3000/service-orders');

      try {
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'title': _titleController.text,
            'address': _addressController.text,
            'neighborhood': _neighborhoodController.text,
            'priority': _priority,
            'assigned_team': _teamController.text,
            'description': _descriptionController.text,
          }),
        );

        if (response.statusCode == 201) { // 201 = Created
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Ordem de Serviço salva com sucesso!'), backgroundColor: Colors.green),
          );
          // Retorna 'true' para a tela anterior para indicar que a lista deve ser atualizada
          Navigator.of(context).pop(true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Falha ao salvar a Ordem de Serviço.'), backgroundColor: Colors.red),
          );
        }
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro de conexão com o servidor.'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.order == null ? 'Nova Ordem de Serviço' : 'Editar Ordem de Serviço'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(controller: _titleController, labelText: 'Título', icon: Icons.title),
              const SizedBox(height: 16),
              CustomTextField(controller: _addressController, labelText: 'Endereço', icon: Icons.location_on),
              const SizedBox(height: 16),
              CustomTextField(controller: _neighborhoodController, labelText: 'Bairro', icon: Icons.location_city),
              const SizedBox(height: 16),
              CustomTextField(controller: _teamController, labelText: 'Equipe Designada', icon: Icons.group),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _priority,
                decoration: const InputDecoration(
                  labelText: 'Prioridade',
                  prefixIcon: Icon(Icons.priority_high),
                ),
                items: <String>['Baixa', 'Média', 'Urgente']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _priority = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Descrição do Problema',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Salvar',
                // Chamando a função _saveOrder
                onPressed: _saveOrder,
              ),
            ],
          ),
        ),
      ),
    );
  }
}