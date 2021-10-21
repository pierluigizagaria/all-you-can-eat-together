import 'package:allyoucaneattogether/models/user.dart' as m;
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  m.User? _userFromFirebaseUser(User? user) =>
      user != null ? m.User(uid: user.uid, name: user.displayName ?? '') : null;

  m.User? signedUser() => _userFromFirebaseUser(_auth.currentUser);

  Stream<m.User?> get user => _auth.userChanges().map(_userFromFirebaseUser);

  Future<m.User?> signInAnonimously() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      return _userFromFirebaseUser(result.user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
