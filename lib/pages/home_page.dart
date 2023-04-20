import 'package:desafio_modulo_4/data/database.dart';
import 'package:desafio_modulo_4/despesa.dart';
import 'package:desafio_modulo_4/pages/insert_expense.dart';
import 'package:desafio_modulo_4/services/AuthService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService authService = AuthService(auth: FirebaseAuth.instance);
  final Database database = Database();
  List<Despesa> expenses = [];

  var monthController = TextEditingController();
  var yearController = TextEditingController();

  User? user;

  @override
  void initState() {
    super.initState();
    user = authService.getCurrentUser();
    // if (user != null) {
    //   database
    //       .getFinancesByDate(userId: user!.uid, year: "2021", month: "11")
    //       .onValue
    //       .listen((event) {
    //     final desp = event.snapshot.children.map((item) {
    //       return Despesa.fromJson(item.value as Map);
    //     }).toList();
    //     setState(() {
    //       expenses = desp;
    //     });
    //   });
      // final d = Despesa(descricao: "TESTe", tipo: "TESTE", valor: "550");
      // database.insertFinance(
      //     year: "2022", month: "01", userId: user!.uid, despesa: d.toJson());
    // }
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
        body: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextField(
                controller: monthController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Mês",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              TextField(
                controller: yearController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Ano",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              ElevatedButton(
                  onPressed: () {
                    String month = monthController.text;
                    String year = yearController.text;
                    if (month.isEmpty) {
                      return;
                    }
                    if (year.isEmpty) {
                      return;
                    }

                    getFinances(month: month, year: year, userId: user!.uid);
                  },
                  child: Text("Buscar")),
              expenses.isNotEmpty
                  ? Expanded(
                      child: ListView(
                      shrinkWrap: true,
                      children: [
                        ...expenses.map((despesa) {
                          return ListTile(
                            title: Text(despesa.descricao),
                            subtitle: Text(despesa.tipo),
                            trailing: Text(
                                "R\$ ${double.parse(despesa.valor).toStringAsFixed(2)}"),
                          );
                        }).toList(),
                        ListTile(
                          title: Text("Total"),
                          trailing: Text("R\$ ${result(expenses).toStringAsFixed(2)}"),
                        )
                      ],
                    ))
                  : Text("Não há despesas")
            ],
          ),
        ));
  }

  double result(List<Despesa> expense) {
    double total = 0;
    expenses.forEach((element) {
      if (element.tipo == "despesa") {
        total = total - double.parse(element.valor);
      } else {
        total = total + double.parse(element.valor);
      }
    });
    return total;
  }

  void getFinances(
      {required String month, required String year, required String userId}) {
    database
        .getFinancesByDate(userId: userId, year: year, month: month)
        .onValue
        .listen((event) {
      final desp = event.snapshot.children.map((item) {
        return Despesa.fromJson(item.value as Map);
      }).toList();
      setState(() {
        expenses = desp;
      });
    });
  }
}
