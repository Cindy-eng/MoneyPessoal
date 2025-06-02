import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For month formatting

// Removed Provider imports
import '../../models/budget_model.dart'; // Import the simplified model

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  // --- Mock Data --- 
  List<Budget> _mockBudgets = [];
  String _currentMonth = '';

  @override
  void initState() {
    super.initState();
    _loadMockData();
  }

  void _loadMockData() {
    // In a real mock, you might want ways to add/edit this list
    _mockBudgets = Budget.getMockBudgets(); 
    _currentMonth = DateFormat('yyyy-MM').format(DateTime.now());
    // Filter budgets for the current month for display
    _mockBudgets = _mockBudgets.where((b) => b.month == _currentMonth).toList();
    // Trigger rebuild if needed (though initState handles initial load)
    // setState(() {}); 
  }

  // Function to potentially add/update mock data (called from dialog)
  // Note: This simple mock won't persist changes across app restarts
  void _handleBudgetSaved(Budget newOrUpdatedBudget, bool isEditing) {
    setState(() {
      if (isEditing) {
        final index = _mockBudgets.indexWhere((b) => b.id == newOrUpdatedBudget.id);
        if (index != -1) {
          _mockBudgets[index] = newOrUpdatedBudget;
        }
      } else {
        // Assign a simple mock ID for editing purposes
        final budgetWithId = Budget(
          id: 'mock_${DateTime.now().millisecondsSinceEpoch}', 
          category: newOrUpdatedBudget.category,
          limit: newOrUpdatedBudget.limit,
          month: newOrUpdatedBudget.month,
          currentSpending: newOrUpdatedBudget.currentSpending // Keep spending if provided
        );
        _mockBudgets.add(budgetWithId);
      }
       // Re-filter for the current month if necessary (though dialog likely uses current month)
       _mockBudgets = _mockBudgets.where((b) => b.month == _currentMonth).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Removed Provider Consumer
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestão de Orçamentos (Screens Only)'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        tooltip: 'Adicionar Orçamento',
        onPressed: () => showDialog(
          context: context,
          // Pass the callback to the dialog
          builder: (_) => AddBudgetDialog(onSave: _handleBudgetSaved), 
        ),
      ),
      body: _mockBudgets.isEmpty
          ? const Center(child: Text('Nenhum orçamento definido para este mês. Crie um!'))
          : ListView.builder(
              padding: const EdgeInsets.only(bottom: 80), // Avoid overlap with FAB
              itemCount: _mockBudgets.length,
              itemBuilder: (context, index) {
                final budget = _mockBudgets[index];
                // Calculate progress locally
                final progress = budget.limit > 0 ? (budget.currentSpending / budget.limit).clamp(0.0, 1.0) : 0.0;
                final progressColor = progress > 0.8 ? Colors.red : (progress > 0.5 ? Colors.orange : Theme.of(context).primaryColor);

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(budget.category, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Limite: Mt ${budget.limit.toStringAsFixed(2)}'),
                        Text('Gasto: Mt ${budget.currentSpending.toStringAsFixed(2)}'),
                        const SizedBox(height: 6),
                        LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.grey[300],
                          color: progressColor,
                          minHeight: 8,
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit, color: Colors.grey),
                      tooltip: 'Editar Orçamento',
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => AddBudgetDialog(
                            budgetToEdit: budget, // Pass the budget to edit
                            onSave: _handleBudgetSaved, // Pass the callback
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}

// --- Add/Edit Budget Dialog (Simplified) --- //

class AddBudgetDialog extends StatefulWidget {
  final Budget? budgetToEdit;
  final Function(Budget, bool) onSave; // Callback to notify parent screen

  const AddBudgetDialog({super.key, this.budgetToEdit, required this.onSave});

  @override
  State<AddBudgetDialog> createState() => _AddBudgetDialogState();
}

class _AddBudgetDialogState extends State<AddBudgetDialog> {
  final _formKey = GlobalKey<FormState>();
  String _category = '';
  double _limit = 0.0;
  late String _month; 
  bool _isLoading = false;

  bool get _isEditing => widget.budgetToEdit != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _category = widget.budgetToEdit!.category;
      _limit = widget.budgetToEdit!.limit;
      _month = widget.budgetToEdit!.month;
    } else {
      _category = 'Alimentação'; // Default category for new
      _month = DateFormat('yyyy-MM').format(DateTime.now());
    }
  }

  Future<void> _saveBudget() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() { _isLoading = true; });

      // Simulate save delay
      await Future.delayed(const Duration(milliseconds: 300));

      final budgetData = Budget(
        id: _isEditing ? widget.budgetToEdit!.id : null, 
        category: _category,
        limit: _limit,
        month: _month,
        // Keep existing spending if editing, otherwise default to 0
        currentSpending: _isEditing ? widget.budgetToEdit!.currentSpending : 0.0, 
      );

      // Call the callback to update the parent screen's mock data
      widget.onSave(budgetData, _isEditing);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Orçamento ${_isEditing ? "atualizado" : "adicionado"} (mock)!'),
            backgroundColor: Colors.green,
          ),
        );
      }
      // No need to set isLoading back to false as the dialog is popped
    }
  }

  @override
  Widget build(BuildContext context) {
    // Removed Provider access
    return AlertDialog(
      title: Text(_isEditing ? 'Editar Orçamento' : 'Novo Orçamento'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              initialValue: _category,
              decoration: const InputDecoration(labelText: 'Categoria'),
              validator: (value) =>
                  value!.isEmpty ? 'Informe a categoria' : null,
              onSaved: (value) => _category = value!,
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: _limit > 0 ? _limit.toStringAsFixed(2) : '',
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Limite Mensal', prefixText: 'Mt '),
              validator: (value) {
                 if (value == null || value.isEmpty) {
                    return 'Informe um limite';
                  }
                  final parsedValue = double.tryParse(value.replaceAll(',', '.'));
                  if (parsedValue == null || parsedValue <= 0) {
                    return 'Limite inválido';
                  }
                  return null;
              },
              onSaved: (value) =>
                  _limit = double.parse(value!.replaceAll(',', '.')), 
            ),
             const SizedBox(height: 16),
             Text('Mês: $_month'), // Display month, not editable in this simple mock
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancelar'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _saveBudget,
          child: _isLoading
              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              : const Text('Salvar'),
        ),
      ],
    );
  }
}

