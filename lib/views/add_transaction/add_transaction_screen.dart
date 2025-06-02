import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Removed Provider imports
// Removed model import as we don't need to create a full object for mock submission

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  String _type = 'saída'; // Default to expense
  String _category = 'Alimentação';
  double _amount = 0.0;
  String _description = '';
  DateTime _selectedDate = DateTime.now();

  // Define categories based on type
  final List<String> _expenseCategories = [
    'Alimentação',
    'Transporte',
    'Lazer',
    'Educação',
    'Saúde',
    'Moradia',
    'Contas',
    'Outros'
  ];
  final List<String> _incomeCategories = [
    'Salário',
    'Freelance',
    'Investimentos',
    'Presente',
    'Outros'
  ];

  List<String> get _currentCategories =>
      _type == 'saída' ? _expenseCategories : _incomeCategories;

  @override
  void initState() {
    super.initState();
    // Ensure the default category is valid for the default type
    _category = _currentCategories.first;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
             colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: const Color(0xFF0A1D37),
                onPrimary: Colors.white,
                surface: Colors.white,
                onSurface: Colors.black87,
             ),
             dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _submitTransaction() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isLoading = true;
      });

      // Simulate saving delay
      await Future.delayed(const Duration(milliseconds: 400));

      // In a real app without state management, you might pass data back
      // or trigger a refresh. Here, we just simulate success.
      final success = true; 

      if (success && mounted) {
         ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Transação adicionada (mock)!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context); // Go back after successful mock submission
      } else if (!success && mounted) {
         ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Falha ao adicionar transação (mock).'),
            backgroundColor: Colors.red,
          ),
        );
      }
      
      if (mounted) {
          setState(() {
            _isLoading = false;
          });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Removed Provider access

    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Transação'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Tipo'),
                value: _type,
                items: const [
                  DropdownMenuItem(value: 'saída', child: Text('Saída')),
                  DropdownMenuItem(value: 'entrada', child: Text('Entrada')),
                ],
                onChanged: (value) {
                  if (value != null && value != _type) {
                    setState(() {
                      _type = value;
                      _category = _currentCategories.first;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Categoria'),
                value: _category,
                items: _currentCategories
                    .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                    .toList(),
                onChanged: (value) => setState(() => _category = value!),
                validator: (value) => value == null ? 'Selecione uma categoria' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Valor', prefixText: 'Mt '),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe um valor';
                  }
                  if (double.tryParse(value.replaceAll(',', '.')) == null || double.parse(value.replaceAll(',', '.')) <= 0) {
                    return 'Valor inválido';
                  }
                  return null;
                },
                onSaved: (value) =>
                    _amount = double.parse(value!.replaceAll(',', '.')),
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Data'),
                subtitle: Text(DateFormat('dd/MM/yyyy').format(_selectedDate)),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Descrição (opcional)',
                ),
                onSaved: (value) => _description = value ?? '',
              ),
              const SizedBox(height: 30),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _submitTransaction,
                      child: const Text('Salvar Transação'),
                    )
            ],
          ),
        ),
      ),
    );
  }
}

