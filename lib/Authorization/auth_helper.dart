import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:package_info/package_info.dart';

class AuthHelper {
  static FirebaseAuth _auth = FirebaseAuth
      .instance; // calling of an development packgae of firebase auth

  static signInWithEmail(
      {required String email, required String password}) async {
    // EMAI AND PASSWORD METHOD USED FOR SIGN IN
    final res = await _auth.signInWithEmailAndPassword(
        // wait here until this function is finished and you will get its return value.
        email: email,
        password:
            password); // collect the email ad password and assign to the email and pass variable
    final User? user = res.user;
    return user; // returning user credentials
  }

  static signupWithEmail(
      {required String email, required String password}) async {
    // EMAI AND PASSWORD METHOD USED FOR SIGN UP
    final res = await _auth.createUserWithEmailAndPassword(
        email: email, password: password); // FIrebase auth function
    final User? user = res.user;
    return user; // if user registered succesfully
  }

  static signInWithGoogle() async {
    // GOOGLE SIGN IN METHOD
    GoogleSignIn googleSignIn =
        GoogleSignIn(); // Calling the goolge sign in package
    final acc = await googleSignIn.signIn();
    final auth = await acc!.authentication;
    final credential = GoogleAuthProvider.credential(
        accessToken: auth.accessToken, idToken: auth.idToken);
    final res = await _auth.signInWithCredential(credential);
    return res.user;
  }

  Future<void> logOut() async {
    // Log the user out of the system
    try {
      await _auth.signOut();
    } catch (e) {
      print("error logging out");
    }
  }
}

class UserHelper {
  static FirebaseFirestore _db = FirebaseFirestore.instance;

  static saveUser(User? user) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    int buildNumber = int.parse(packageInfo.buildNumber);

    Map<String, dynamic> userData = {
      "email": user!.email,
      "last_login": DateTime.now(),
      "created_at": DateTime.now(),
      "role": "user",
    };
    final userRef = _db.collection("users").doc(user.uid);
    if ((await userRef.get()).exists) {
      await userRef.update({
        "last_login": DateTime.now(),
        "build_number": buildNumber,
      });
    } else {
      await _db.collection("users").doc(user.uid).set(userData);
    }
  }
}
