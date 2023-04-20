import 'package:desafio_modulo_4/data/database.dart';
import 'package:desafio_modulo_4/despesa.dart';
import 'package:flutter/material.dart';

class InsertExpense extends StatefulWidget {
  const InsertExpense({super.key});

  @override
  State<InsertExpense> createState() => _InsertExpenseState();
}

enum Types { receita, despesa }

class _InsertExpenseState extends State<InsertExpense> {
  var descriptionController = TextEditingController();

  // var typeController = TextEditingController();
  var type = Types.receita;
  var valueController = TextEditingController();
  var monthController = TextEditingController();
  var yearController = TextEditingController();
  final database = Database();

  @override
  Widget build(BuildContext context) {
    final userId = ModalRoute.of(context)?.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: Text("Inserir despesa"),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: ListView(
          children: [
            ListTile(
              title: Text("Receita"),
              leading: Radio<Types>(
                value: Types.receita,
                groupValue: type,
                onChanged: (Types? value) {
                  setState(() {
                    if (value != null) {
                      type = value;
                    }
                  });
                },
              ),
            ),
            ListTile(
              title: Text("Despesa"),
              leading: Radio<Types>(
                value: Types.despesa,
                groupValue: type,
                onChanged: (Types? value) {
                  setState(() {
                    if (value != null) {
                      type = value;
                    }
                  });
                },
              ),
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                  labelText: "Descricao", border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
              controller: valueController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  labelText: "Valor", border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
              controller: monthController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  labelText: "Mês", border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
              controller: yearController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  labelText: "Ano", border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 15,
            ),
            ElevatedButton(
                onPressed: () {
                  final description = descriptionController.text;
                  final value = valueController.text;
                  final month = monthController.text;
                  final year = yearController.text;
                  if (description.isEmpty) {
                    return;
                  }
                  if (value.isEmpty) {
                    return;
                  }
                  if (month.isEmpty) {
                    return;
                  }
                  if (year.isEmpty || year.length < 4) {
                    return;
                  }
                  final newExpense = Despesa(
                      descricao: description,
                      tipo: type.toString(),
                      valor: value);

                  database.insertFinance(
                      year: year,
                      month: month.padLeft(2, "0"),
                      userId: userId,
                      despesa: newExpense.toJson());
                  Navigator.of(context).pop();
                },
                child: Text("Salvar"))
          ],
        ),
      ),
    );
  }
}
