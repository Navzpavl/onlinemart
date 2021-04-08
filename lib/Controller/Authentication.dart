import 'package:onlinemart/Controller/userDB.dart';
import 'package:onlinemart/Model/User.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthService extends ChangeNotifier {
  String userId;

  //converting firebase user to local user model

  UserId _userFormFirebase(FirebaseUser user) {
    // return user != null? UserId(uid: user.uid): null;

    if (user != null) {
      return UserId(uid: user.uid);
    } else {
      return null;
    }
  }

  //auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //signup with email & password

  Future register(String email, String password, User userData) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      FirebaseUser user = result.user;

      //image uploading and get firebase storage url

      userData.imageUrl = await UserDatabaseService(uid: user.uid)
          .uploadimage(userData.imageUrl);
      print(userData.imageUrl.toString());
      await UserDatabaseService(uid: user.uid).updateUserData(userData);

      _userFormFirebase(user);
      return null;
    } catch (e) {
      print(e);
      return e.code;
    }
  }

  //strem change

  Stream<UserId> get user {
    return _auth.onAuthStateChanged.map(_userFormFirebase);
  }

  // sign in

  Future signin(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      userId = user.uid;
      _userFormFirebase(user);
      return null;
    } catch (e) {
      print(e.toString());
      return e.code;
    }
  }

  // sign out

  Future signout() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}
