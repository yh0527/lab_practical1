import 'package:flutter/material.dart';
import 'result_screen.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({super.key, required this.title});
  final String title;

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final _themeController = TextEditingController();
  final _durationController = TextEditingController(text: '2');
  final _budgetController = TextEditingController(text: '500');
  int _participants = 50;
  String _location = 'Hall';

  void _onGenerate() {
    // Task 1: Collect all 5 parameters
    final data = {
      'theme': _themeController.text.isEmpty ? 'General Event' : _themeController.text,
      'duration': double.tryParse(_durationController.text) ?? 2.0,
      'budget': double.tryParse(_budgetController.text) ?? 500.0,
      'participants': _participants,
      'location': _location,
    };
    Navigator.push(context, MaterialPageRoute(builder: (c) => ResultScreen(eventData: data)));
  }

  @override
  void dispose() {
    _themeController.dispose();
    _durationController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(controller: _themeController, decoration: const InputDecoration(labelText: 'Event Theme')),
          const SizedBox(height: 15),
          TextField(
            controller: _durationController,
            decoration: const InputDecoration(labelText: 'Duration (hours)'),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: _budgetController,
            decoration: const InputDecoration(labelText: 'Budget (RM)'),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 15),
          Text("Participants: $_participants "),
          CounterWidget(onChanged: (v) => setState(() => _participants = v), initial: _participants),
          const SizedBox(height: 15),
          DropdownButtonFormField(
            initialValue: _location,
            decoration: const InputDecoration(labelText: 'Location '),
            items: ['Hall', 'Classroom', 'Outdoor Area'].map((l) => DropdownMenuItem(value: l, child: Text(l))).toList(),
            onChanged: (v) => setState(() => _location = v!),
          ),
          const SizedBox(height: 30),
          ElevatedButton(onPressed: _onGenerate, child: const Text("Generate AI Event Plan")),
        ],
      ),
    );
  }
}

class CounterWidget extends StatelessWidget {
  final ValueChanged<int> onChanged;
  final int initial;
  const CounterWidget({super.key, required this.onChanged, required this.initial});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      IconButton(icon: const Icon(Icons.remove), onPressed: () => onChanged(initial - 1)),
      Text("$initial People"),
      IconButton(icon: const Icon(Icons.add), onPressed: () => onChanged(initial + 1)),
    ]);
  }
}