import 'package:firebase_database/firebase_database.dart';

class Database {
  final database = FirebaseDatabase.instance;

  DatabaseReference getData(String userId) {
    return database.ref("financas").child(userId);
  }

  DatabaseReference getFinancesByDate(
      {required String userId, required String year, required String month}) {
    return database.ref("financas").child(userId).child(year).child(month);
  }

  void insertFinance(
      {required String year,
      required String month,
      required String userId,
      required Map despesa}) {
    database
        .ref("financas")
        .child(userId)
        .child(year)
        .child(month)
        .push()
        .set(despesa);
  }
}
