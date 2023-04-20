import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth, User;

class AuthService {
  FirebaseAuth auth;

  AuthService({required this.auth});

  Future<User?> login(String email, String password) {
    return auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((result) {
      return result.user;
    }).onError((error, stackTrace) {
      print(error);
      return Future.error("Usuario não encontrado");
    });
  }

  Future<void> logout() async {
    auth.signOut();
  }

  User? getCurrentUser() => auth.currentUser;
}
