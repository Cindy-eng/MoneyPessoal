import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Removed Provider imports
import '../../models/reminder_model.dart'; // Import the simplified model

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  // --- Mock Data --- 
  List<Reminder> _mockReminders = [];

  @override
  void initState() {
    super.initState();
    _loadMockData();
  }

  void _loadMockData() {
    _mockReminders = Reminder.getMockReminders();
    // Sort reminders, e.g., by due date
    _mockReminders.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    // setState(() {}); // Not needed for initial load
  }

  // Callback for saving/updating reminders from the dialog
  void _handleReminderSaved(Reminder newOrUpdatedReminder, bool isEditing) {
    setState(() {
      if (isEditing) {
        final index = _mockReminders.indexWhere((r) => r.id == newOrUpdatedReminder.id);
        if (index != -1) {
          _mockReminders[index] = newOrUpdatedReminder;
        }
      } else {
        // Assign a simple mock ID
        final reminderWithId = Reminder(
          id: 'mock_rem_${DateTime.now().millisecondsSinceEpoch}',
          title: newOrUpdatedReminder.title,
          amount: newOrUpdatedReminder.amount,
          dueDate: newOrUpdatedReminder.dueDate,
          isPaid: newOrUpdatedReminder.isPaid,
        );
        _mockReminders.add(reminderWithId);
      }
      // Re-sort after adding/editing
      _mockReminders.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    });
  }

  // Callback for toggling paid status
  void _handleTogglePaidStatus(String reminderId, bool isPaid) {
    setState(() {
      final index = _mockReminders.indexWhere((r) => r.id == reminderId);
      if (index != -1) {
        final reminder = _mockReminders[index];
        _mockReminders[index] = Reminder(
          id: reminder.id,
          title: reminder.title,
          amount: reminder.amount,
          dueDate: reminder.dueDate,
          isPaid: isPaid, // Update paid status
        );
        // Optionally re-sort if paid status affects order
        // _mockReminders.sort((a, b) => a.dueDate.compareTo(b.dueDate));
      }
    });
     ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(
         content: Text('Lembrete marcado como ${isPaid ? "pago" : "pendente"} (mock)!'),
         backgroundColor: Colors.blueGrey,
         duration: const Duration(seconds: 1),
       ),
     );
  }

  @override
  Widget build(BuildContext context) {
    // Removed Provider Consumer
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lembretes (Screens Only)'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add_alert),
        tooltip: 'Adicionar Lembrete',
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => AddReminderDialog(onSave: _handleReminderSaved), // Pass callback
          );
        },
      ),
      body: _mockReminders.isEmpty
          ? const Center(child: Text('Nenhum lembrete encontrado.'))
          : ListView.builder(
              padding: const EdgeInsets.only(bottom: 80),
              itemCount: _mockReminders.length,
              itemBuilder: (context, index) {
                final reminder = _mockReminders[index];
                final isPastDue = !reminder.isPaid && reminder.dueDate.isBefore(DateTime.now());

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: reminder.isPaid ? Colors.grey[200] : (isPastDue ? Colors.red[50] : Colors.white),
                  child: ListTile(
                    title: Text(
                      reminder.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: reminder.isPaid ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    subtitle: Text(
                      'Vencimento: ${DateFormat('dd/MM/yyyy').format(reminder.dueDate)} - Mt ${reminder.amount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: isPastDue ? Colors.red : Colors.grey[600],
                      ),
                    ),
                    trailing: Checkbox(
                      value: reminder.isPaid,
                      onChanged: (bool? value) {
                        if (value != null) {
                          // Call callback to update state
                          _handleTogglePaidStatus(reminder.id!, value);
                        }
                      },
                      activeColor: Theme.of(context).primaryColor,
                    ),
                    onTap: () { // Allow editing on tap
                      showDialog(
                        context: context,
                        builder: (_) => AddReminderDialog(
                          reminderToEdit: reminder,
                          onSave: _handleReminderSaved, // Pass callback
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}

// --- Add/Edit Reminder Dialog (Simplified) --- //

class AddReminderDialog extends StatefulWidget {
  final Reminder? reminderToEdit;
  final Function(Reminder, bool) onSave; // Callback

  const AddReminderDialog({super.key, this.reminderToEdit, required this.onSave});

  @override
  State<AddReminderDialog> createState() => _AddReminderDialogState();
}

class _AddReminderDialogState extends State<AddReminderDialog> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  late String _title;
  late double _amount;
  late DateTime _dueDate;
  late bool _isPaid; // Keep track of paid status for editing

  bool get _isEditing => widget.reminderToEdit != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _title = widget.reminderToEdit!.title;
      _amount = widget.reminderToEdit!.amount;
      _dueDate = widget.reminderToEdit!.dueDate;
      _isPaid = widget.reminderToEdit!.isPaid;
    } else {
      _title = '';
      _amount = 0.0;
      _dueDate = DateTime.now().add(const Duration(days: 7));
      _isPaid = false;
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
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
    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  Future<void> _saveReminder() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() { _isLoading = true; });

      // Simulate save delay
      await Future.delayed(const Duration(milliseconds: 300));

      final reminderData = Reminder(
        id: _isEditing ? widget.reminderToEdit!.id : null,
        title: _title,
        amount: _amount,
        dueDate: _dueDate,
        isPaid: _isPaid, // Use the state's isPaid value
      );

      // Call callback to update parent screen
      widget.onSave(reminderData, _isEditing);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lembrete ${_isEditing ? "atualizado" : "adicionado"} (mock)!'),
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
      title: Text(_isEditing ? 'Editar Lembrete' : 'Novo Lembrete'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(labelText: 'Título do Lembrete'),
                validator: (value) =>
                    value!.isEmpty ? 'Informe um título' : null,
                onSaved: (value) => _title = value!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _amount > 0 ? _amount.toStringAsFixed(2) : '',
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Valor (Opcional)', prefixText: 'Mt '),
                onSaved: (value) =>
                    _amount = double.tryParse(value?.replaceAll(',', '.') ?? '0.0') ?? 0.0,
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Data de Vencimento'),
                subtitle: Text(DateFormat('dd/MM/yyyy').format(_dueDate)),
                trailing: const Icon(Icons.calendar_today),
                onTap: _selectDate,
              ),
              // Only show paid toggle when editing
              if (_isEditing)
                CheckboxListTile(
                  title: const Text("Marcar como Pago"),
                  value: _isPaid,
                  onChanged: (newValue) {
                    setState(() {
                      _isPaid = newValue ?? false;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
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
          onPressed: _isLoading ? null : _saveReminder,
          child: _isLoading
              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              : const Text('Salvar'),
        ),
      ],
    );
  }
}

