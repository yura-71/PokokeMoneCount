import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PocketMoneyApp(),
    );
  }
}

class PocketMoneyApp extends StatefulWidget {
  @override
  _PocketMoneyAppState createState() => _PocketMoneyAppState();
}

class _PocketMoneyAppState extends State<PocketMoneyApp> {
  double? _totalMoney; // ポケットマネーの総額
  double _remainingMoney = 0; // 残り金額
  final List<Map<String, dynamic>> _expenses = []; // 使用履歴

  final TextEditingController _moneyController = TextEditingController();
  final TextEditingController _expenseController = TextEditingController();
  final TextEditingController _purposeController = TextEditingController();

  void _setPocketMoney() {
    setState(() {
      _totalMoney = double.tryParse(_moneyController.text) ?? 0;
      _remainingMoney = _totalMoney!;
      _moneyController.clear();
    });
  }

  void _addExpense() {
    final double expense = double.tryParse(_expenseController.text) ?? 0;
    final String purpose = _purposeController.text;

    if (expense > 0 && purpose.isNotEmpty) {
      setState(() {
        _remainingMoney -= expense;
        _expenses.add({'amount': expense, 'purpose': purpose});
        _expenseController.clear();
        _purposeController.clear();
      });
    }
  }

  void _reset() {
    setState(() {
      _totalMoney = null;
      _remainingMoney = 0;
      _expenses.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pocket Money Manager'),
      ),
      body: _totalMoney == null ? _buildSetupView() : _buildMainView(),
    );
  }

  Widget _buildSetupView() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Set your Pocket Money',
            style: TextStyle(fontSize: 20),
          ),
          TextField(
            controller: _moneyController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Enter amount'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _setPocketMoney,
            child: Text('Set'),
          ),
        ],
      ),
    );
  }

  Widget _buildMainView() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Remaining Money: \$${_remainingMoney.toStringAsFixed(2)}',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text(
            'Add Expense',
            style: TextStyle(fontSize: 20),
          ),
          TextField(
            controller: _expenseController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Enter amount'),
          ),
          TextField(
            controller: _purposeController,
            decoration: InputDecoration(labelText: 'Enter purpose'),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: _addExpense,
            child: Text('Add'),
          ),
          SizedBox(height: 20),
          Text(
            'Expense History',
            style: TextStyle(fontSize: 20),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _expenses.length,
              itemBuilder: (context, index) {
                final expense = _expenses[index];
                return ListTile(
                  title: Text('\$${expense['amount']}'),
                  subtitle: Text(expense['purpose']),
                );
              },
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: _reset,
            child: Text('Reset'),
          ),
        ],
      ),
    );
  }
}
