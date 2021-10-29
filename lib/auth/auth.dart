import 'package:firebase_auth/firebase_auth.dart';
import 'package:tekmob/services/userRepo.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserRepo? _userFromFirebaseUser(User user) {
    return user != null ? UserRepo(uid: user.uid) : null;
  }

  Stream<UserRepo?> get user {
    print("masuk get user");
    return _auth
        .authStateChanges()
        .map((User? user) => _userFromFirebaseUser(user!));
  }

  // register email & pass
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user!);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign in email & pass
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user!);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
  // register gmail

  // sign in gmail

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
