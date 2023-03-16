// ignore_for_file: prefer_const_constructors
import 'dart:io';

import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './models/transaction.dart';

import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import './widgets/chart.dart';

void main() {
  /* WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]); */
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal expenses',
      theme: ThemeData(
        primarySwatch: Colors.green,
        accentColor: Colors.orange[700],
        errorColor: Colors.red,
        fontFamily: 'Quicksand',
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [
    /* Transaction(
      id: 1,
      amount: 900,
      title: 'MacBook Pro 14',
      date: DateTime.now(),
    ),
    Transaction(
      id: 2,
      amount: 250,
      title: 'AirPods Pro',
      date: DateTime.now(),
    ), */
  ];

  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTransaction(String txTitle, double txAmount, DateTime txDate) {
    final newTx = Transaction(
      amount: txAmount,
      title: txTitle,
      date: txDate,
      id: Random().nextInt(100),
    );

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _deleteTransaction(int id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: NewTransaction(_addNewTransaction),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandascape = mediaQuery.orientation == Orientation.landscape;
    final appBar = AppBar(
      title: Text(
        'Personal expenses',
        style: Theme.of(context).appBarTheme.titleTextStyle,
      ),
      actions: [
        IconButton(
          onPressed: () => _startAddNewTransaction(context),
          icon: Icon(Icons.add),
        )
      ],
    );

    final txListWidget = Container(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          0.7,
      child: TransactionList(_userTransactions, _deleteTransaction),
    );

    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (isLandascape)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Show chart',
                    style: Theme.of(context).appBarTheme.titleTextStyle,
                  ),
                  Switch.adaptive(
                      activeColor: Theme.of(context).accentColor,
                      value: _showChart,
                      onChanged: (val) {
                        setState(() {
                          _showChart = val;
                        });
                      }),
                ],
              ),
            if (!isLandascape)
              Container(
                height: (mediaQuery.size.height -
                        appBar.preferredSize.height -
                        mediaQuery.padding.top) *
                    0.3,
                child: Chart(_recentTransactions),
              ),
            if (!isLandascape) txListWidget,
            if (isLandascape)
              _showChart
                  ? Container(
                      height: (mediaQuery.size.height -
                              appBar.preferredSize.height -
                              mediaQuery.padding.top) *
                          0.7,
                      child: Chart(_recentTransactions),
                    )
                  : txListWidget
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
            navigationBar: CupertinoNavigationBar(
              middle: Text(
                'Personal expenses',
                style: Theme.of(context).appBarTheme.titleTextStyle,
              ),
              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                GestureDetector(
                  child: Icon(CupertinoIcons.add),
                  onTap: () => _startAddNewTransaction(context),
                )
              ]),
            ),
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _startAddNewTransaction(context),
                  ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}

// 06x06 to see