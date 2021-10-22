import 'package:allyoucaneattogether/models/user.dart' as app;
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  app.User? _userFromFirebaseUser(User? user) => user != null
      ? app.User(uid: user.uid, name: user.displayName ?? '')
      : null;

  app.User? get user => _userFromFirebaseUser(_auth.currentUser);

  Stream<app.User?> get stream =>
      _auth.userChanges().map(_userFromFirebaseUser);

  Future<app.User?> signInAnonimously() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      return _userFromFirebaseUser(result.user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
