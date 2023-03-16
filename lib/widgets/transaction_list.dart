// ignore_for_file: prefer_const_constructors, dead_code

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTx;

  TransactionList(this.transactions, this.deleteTx);

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(builder: (ctx, contraints) {
            return Column(
              children: <Widget>[
                Text(
                  'Ops, there are no transactions yet!',
                  style: Theme.of(context).appBarTheme.titleTextStyle,
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: contraints.maxHeight * 0.6,
                  child: Image.asset(
                    'assets/images/waiting.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            );
          })
        : ListView.builder(
            itemBuilder: (ctx, index) {
              return Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 5,
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    child: Padding(
                      padding: EdgeInsets.all(6),
                      child: FittedBox(
                        child: Text('${transactions[index].amount}€'),
                      ),
                    ),
                  ),
                  title: Text(
                    transactions[index].title,
                    style: Theme.of(context).appBarTheme.titleTextStyle,
                  ),
                  subtitle: Text(
                    DateFormat.yMMMd().format(transactions[index].date),
                  ),
                  trailing: MediaQuery.of(context).size.width > 400
                      ? TextButton.icon(
                          onPressed: () => deleteTx(transactions[index].id),
                          icon: Icon(
                            Icons.delete,
                            color: Theme.of(context).errorColor,
                          ),
                          label: Text(
                            'Delete',
                            style: TextStyle(
                              color: Theme.of(context).errorColor,
                            ),
                          ))
                      : IconButton(
                          color: Theme.of(context).errorColor,
                          icon: Icon(Icons.delete),
                          onPressed: () => deleteTx(transactions[index].id),
                        ),
                ),
              );
            },
            itemCount: transactions.length,
          );
  }
}
