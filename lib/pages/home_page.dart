import 'package:desafio_modulo_4/data/database.dart';
import 'package:desafio_modulo_4/despesa.dart';
import 'package:desafio_modulo_4/pages/insert_expense.dart';
import 'package:desafio_modulo_4/services/AuthService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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
  var _showFAB = true;
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
        floatingActionButton: AnimatedSlide(
          duration: Duration(milliseconds: 300),
          offset: _showFAB ? Offset.zero : Offset(0, 2),
          child: AnimatedOpacity(
            duration: Duration(milliseconds: 300),
            opacity: _showFAB ? 1 : 0,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    settings: RouteSettings(arguments: user!.uid),
                    builder: (context) => InsertExpense()));
              },
              child: Icon(Icons.add),
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: NotificationListener<UserScrollNotification>(
            onNotification: (notification) {
              ScrollDirection direction = notification.direction;
              setState(() {
                if (direction == ScrollDirection.reverse) {
                  _showFAB = false;
                } else if (direction == ScrollDirection.forward) {
                  _showFAB = true;
                }
              });
              return true;
            },
            child: ListView(
              children: [
                SizedBox(
                  height: 20,
                ),
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
                    style: ElevatedButton.styleFrom(),
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
                    child: SizedBox(
                        width: double.infinity,
                        child: Text(
                          "Buscar",
                          textAlign: TextAlign.center,
                        ))),
                expenses.isNotEmpty
                    ? Column(
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
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            tileColor: Colors.blue.shade100,
                            title: Text(
                              "Total",
                              style: TextStyle(
                                  color: Colors.blue.shade700,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            trailing: Text(
                              "R\$ ${result(expenses).toStringAsFixed(2)}",
                              style: TextStyle(
                                  color: Colors.blue.shade700,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          SizedBox(height: 10,)
                        ],
                      )
                    : Text("Não há despesas")
              ],
            ),
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
