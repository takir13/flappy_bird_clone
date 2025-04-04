
//importing the library for firebasee authentication
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
//function to be called on game start, we are using an anonymous sign in, so that it does not prompt for google account
Future<User?> signInAnonymously() async {
  try {
    //creating a user credential when the game first starts
    UserCredential userCredential = await FirebaseAuth.instance.signInAnonymously();
    return userCredential.user;
  } catch (error) {
    //giving an error if unable
    debugPrint('Error signing in: $error');
    return null;
   }
}