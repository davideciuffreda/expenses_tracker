// ignore_for_file: prefer_const_constructors, sort_child_properties_last
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import './adaptive_flat_button.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;

  NewTransaction(this.addTx);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _amountController = TextEditingController();
  final _titleController = TextEditingController();
  DateTime? _selectedDate;

  void _submitData() {
    if (_amountController.text.isEmpty) return;

    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      print(
          'Error: before to press "Add transaction" you have to insert correctly all required parameters!');
      return;
    }

    widget.addTx(enteredTitle, enteredAmount, _selectedDate);

    Navigator.of(context).pop();
  }

  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1970),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) return;
      setState(() {
        _selectedDate = pickedDate;
      });
    });
    print('...');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: 'Title'),
                controller: _titleController,
                onSubmitted: (_) =>
                    _submitData(), // _ significa che io accetto un parametro come input della funzione anonima ma che non mi interessa cosa sia
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Amount'),
                controller: _amountController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) =>
                    _submitData(), // _ significa che io accetto un parametro come input della funzione anonima ma che non mi interessa cosa sia
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedDate == null
                          ? 'No date chosen!'
                          : 'Date: ${DateFormat.yMd().format(_selectedDate!)}',
                    ),
                  ),
                  AdaptiveFlatButton('Choose date', _showDatePicker),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              ElevatedButton(
                child: Text(
                  'Add transaction',
                ),
                onPressed: _submitData,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
