import 'dart:convert';

import 'package:desafio_modulo_4/data/database.dart';
import 'package:desafio_modulo_4/despesa.dart';
import 'package:desafio_modulo_4/pages/insert_expense.dart';
import 'package:desafio_modulo_4/services/AuthService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService authService = AuthService(auth: FirebaseAuth.instance);
  final Database database = Database();
  List<Despesa> despesas = [];
  User? user;

  @override
  void initState() {
    super.initState();
    user = authService.getCurrentUser();
    if (user != null) {
      database
          .getFinancesByDate(userId: user!.uid, year: "2021", month: "11")
          .onValue
          .listen((event) {
        final desp = event.snapshot.children.map((item) {
          return Despesa.fromJson(item.value as Map);
        }).toList();
        setState(() {
          despesas = desp;
        });
      });
      // final d = Despesa(descricao: "TESTe", tipo: "TESTE", valor: "550");
      // database.insertFinance(
      //     year: "2022", month: "01", userId: user!.uid, despesa: d.toJson());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Home Page"),
          actions: [
            IconButton(
                onPressed: () async {
                  authService.logout();
                },
                icon: Icon(Icons.logout))
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                settings: RouteSettings(arguments: user!.uid),
                builder: (context) => InsertExpense()));
          },
          child: Icon(Icons.add),
        ),
        body: ListView(
          children: despesas.isNotEmpty
              ? despesas.map((despesa) {
                  return ListTile(
                    title: Text(despesa.descricao),
                    subtitle: Text(despesa.tipo),
                    trailing: Text(
                        "R\$ ${double.parse(despesa.valor).toStringAsFixed(2)}"),
                  );
                }).toList()
              : [const Text("Nenhum despesa")],
        ));
  }
}
