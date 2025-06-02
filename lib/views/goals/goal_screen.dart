import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Removed Provider imports
import '../../models/goal_model.dart'; // Import the simplified model

class GoalScreen extends StatefulWidget {
  const GoalScreen({super.key});

  @override
  State<GoalScreen> createState() => _GoalScreenState();
}

class _GoalScreenState extends State<GoalScreen> {
  // --- Mock Data --- 
  List<Goal> _mockGoals = [];

  @override
  void initState() {
    super.initState();
    _loadMockData();
  }

  void _loadMockData() {
    _mockGoals = Goal.getMockGoals();
    // Trigger rebuild if needed
    // setState(() {}); 
  }

  // Callback for saving/updating goals from the dialog
  void _handleGoalSaved(Goal newOrUpdatedGoal, bool isEditing) {
    setState(() {
      if (isEditing) {
        final index = _mockGoals.indexWhere((g) => g.id == newOrUpdatedGoal.id);
        if (index != -1) {
          _mockGoals[index] = newOrUpdatedGoal;
        }
      } else {
        // Assign a simple mock ID
        final goalWithId = Goal(
          id: 'mock_goal_${DateTime.now().millisecondsSinceEpoch}',
          name: newOrUpdatedGoal.name,
          targetAmount: newOrUpdatedGoal.targetAmount,
          currentAmount: newOrUpdatedGoal.currentAmount,
          deadline: newOrUpdatedGoal.deadline,
        );
        _mockGoals.add(goalWithId);
      }
    });
  }

  // Callback for adding contribution
  void _handleContributionAdded(String goalId, double amount) {
     setState(() {
        final index = _mockGoals.indexWhere((g) => g.id == goalId);
        if (index != -1) {
          final goal = _mockGoals[index];
          // Create a new goal object with updated amount
          _mockGoals[index] = Goal(
            id: goal.id,
            name: goal.name,
            targetAmount: goal.targetAmount,
            currentAmount: (goal.currentAmount + amount).clamp(0.0, goal.targetAmount), // Update and clamp
            deadline: goal.deadline,
          );
        }
     });
  }

  @override
  Widget build(BuildContext context) {
    // Removed Provider Consumer
    return Scaffold(
      appBar: AppBar(
        title: const Text('Metas de Economia (Screens Only)'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        tooltip: 'Adicionar Meta',
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => AddGoalDialog(onSave: _handleGoalSaved), // Pass callback
          );
        },
      ),
      body: _mockGoals.isEmpty
          ? const Center(child: Text('Nenhuma meta definida. Crie uma!'))
          : ListView.builder(
              padding: const EdgeInsets.only(bottom: 80),
              itemCount: _mockGoals.length,
              itemBuilder: (context, index) {
                final goal = _mockGoals[index];
                // Calculate progress locally
                final progress = goal.progress; // Use getter from model
                final progressColor = goal.currentAmount >= goal.targetAmount
                    ? Colors.green
                    : (progress > 0.7 ? Colors.blue : Theme.of(context).primaryColor);
                final daysRemaining = goal.deadline.difference(DateTime.now()).inDays;
                final deadlineText = daysRemaining < 0
                    ? 'Prazo Expirado'
                    : 'Prazo: ${DateFormat('dd/MM/yyyy').format(goal.deadline)} ($daysRemaining dias restantes)';

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(goal.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Progresso: Mt ${goal.currentAmount.toStringAsFixed(2)} de Mt ${goal.targetAmount.toStringAsFixed(2)}'),
                        const SizedBox(height: 6),
                        LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.grey[300],
                          color: progressColor,
                          minHeight: 8,
                        ),
                        const SizedBox(height: 6),
                        Text(deadlineText, style: TextStyle(color: daysRemaining < 0 ? Colors.red : Colors.grey[600])),
                      ],
                    ),
                    trailing: Row(
                       mainAxisSize: MainAxisSize.min,
                       children: [
                         IconButton(
                           icon: const Icon(Icons.add_card, color: Colors.green),
                           tooltip: 'Adicionar Contribuição',
                           onPressed: () {
                              _showAddContributionDialog(context, goal, _handleContributionAdded);
                           },
                         ),
                         IconButton(
                           icon: const Icon(Icons.edit, color: Colors.grey),
                           tooltip: 'Editar Meta',
                           onPressed: () {
                             showDialog(
                               context: context,
                               builder: (_) => AddGoalDialog(goalToEdit: goal, onSave: _handleGoalSaved), // Pass callback
                             );
                           },
                         ),
                       ],
                    )
                  ),
                );
              },
            ),
    );
  }

  // Helper to show contribution dialog (simplified)
  void _showAddContributionDialog(BuildContext context, Goal goal, Function(String, double) onContribute) {
    final amountController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder( // Use StatefulBuilder for dialog's own state
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Adicionar Contribuição a "${goal.name}"'),
              content: Form(
                key: formKey,
                child: TextFormField(
                  controller: amountController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'Valor da Contribuição', prefixText: 'Mt '),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe um valor';
                    }
                    final amount = double.tryParse(value.replaceAll(',', '.'));
                    if (amount == null || amount <= 0) {
                      return 'Valor inválido';
                    }
                    return null;
                  },
                ),
              ),
              actions: [
                TextButton(
                  child: const Text('Cancelar'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                ElevatedButton(
                  onPressed: isLoading ? null : () async {
                    if (formKey.currentState!.validate()) {
                      setDialogState(() { isLoading = true; });
                      final amount = double.parse(amountController.text.replaceAll(',', '.'));
                      
                      // Simulate delay
                      await Future.delayed(const Duration(milliseconds: 300));
                      
                      // Call the callback to update the main screen's state
                      onContribute(goal.id!, amount);
                      
                      if (context.mounted) {
                        Navigator.of(context).pop(); // Close dialog
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Contribuição adicionada (mock)!'), backgroundColor: Colors.green),
                        );
                      }
                    }
                  },
                  child: isLoading
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text('Adicionar'),
                ),
              ],
            );
          }
        );
      },
    );
  }
}

// --- Add/Edit Goal Dialog (Simplified) --- //

class AddGoalDialog extends StatefulWidget {
  final Goal? goalToEdit;
  final Function(Goal, bool) onSave; // Callback

  const AddGoalDialog({super.key, this.goalToEdit, required this.onSave});

  @override
  State<AddGoalDialog> createState() => _AddGoalDialogState();
}

class _AddGoalDialogState extends State<AddGoalDialog> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  late String _name;
  late double _targetAmount;
  late double _currentAmount;
  late DateTime _deadline;

  bool get _isEditing => widget.goalToEdit != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _name = widget.goalToEdit!.name;
      _targetAmount = widget.goalToEdit!.targetAmount;
      _currentAmount = widget.goalToEdit!.currentAmount;
      _deadline = widget.goalToEdit!.deadline;
    } else {
      _name = '';
      _targetAmount = 0.0;
      _currentAmount = 0.0;
      _deadline = DateTime.now().add(const Duration(days: 90));
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _deadline,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
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
    if (picked != null && picked != _deadline) {
      setState(() {
        _deadline = picked;
      });
    }
  }

  Future<void> _saveGoal() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

       // Basic validation: current amount cannot exceed target amount
      if (_currentAmount > _targetAmount) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Valor atual não pode ser maior que o valor alvo.'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      setState(() { _isLoading = true; });

      // Simulate save delay
      await Future.delayed(const Duration(milliseconds: 300));

      final goalData = Goal(
        id: _isEditing ? widget.goalToEdit!.id : null,
        name: _name,
        targetAmount: _targetAmount,
        currentAmount: _currentAmount,
        deadline: _deadline,
      );

      // Call callback to update parent screen
      widget.onSave(goalData, _isEditing);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Meta ${_isEditing ? "atualizada" : "adicionada"} (mock)!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Removed Provider access
    return AlertDialog(
      title: Text(_isEditing ? 'Editar Meta' : 'Nova Meta'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(labelText: 'Nome da Meta'),
                validator: (value) =>
                    value!.isEmpty ? 'Informe o nome da meta' : null,
                onSaved: (value) => _name = value!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _targetAmount > 0 ? _targetAmount.toStringAsFixed(2) : '',
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Valor Alvo', prefixText: 'Mt '),
                 validator: (value) {
                   if (value == null || value.isEmpty) {
                      return 'Informe um valor alvo';
                    }
                    final target = double.tryParse(value.replaceAll(',', '.'));
                    if (target == null || target <= 0) {
                      return 'Valor alvo inválido';
                    }
                    return null;
                },
                onSaved: (value) =>
                    _targetAmount = double.parse(value!.replaceAll(',', '.')), 
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _currentAmount >= 0 ? _currentAmount.toStringAsFixed(2) : '0.00',
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Valor Atual Economizado', prefixText: 'Mt '),
                 validator: (value) {
                   if (value == null || value.isEmpty) {
                      return 'Informe o valor atual';
                    }
                    final current = double.tryParse(value.replaceAll(',', '.'));
                    if (current == null || current < 0) {
                      return 'Valor atual inválido';
                    }
                    return null;
                },
                onSaved: (value) =>
                    _currentAmount = double.parse(value!.replaceAll(',', '.')), 
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Data Limite'),
                subtitle: Text(DateFormat('dd/MM/yyyy').format(_deadline)),
                trailing: const Icon(Icons.calendar_today),
                onTap: _selectDate,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancelar'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _saveGoal,
          child: _isLoading
              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              : const Text('Salvar'),
        ),
      ],
    );
  }
}

