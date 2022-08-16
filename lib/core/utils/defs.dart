import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

extension BuildContextX on BuildContext {
  Size get appSize => MediaQuery.of(this).size;
  Future<bool?> showErrorDialog(String msg) => Fluttertoast.showToast(
      msg: msg, gravity: ToastGravity.TOP, backgroundColor: Colors.red);
}

extension ExceptionX on Exception {
  String get toFormattedString {
    if (this is FirebaseAuthException) {
      var exception = this as FirebaseAuthException;
      switch (exception.code) {
        case 'invalid-email':
          return 'The email you entered is invalid. Please check the email is in '
              'the proper format and try again';
        case 'wrong-password':
          return 'The password you entered is incorrect.';
        case 'user-not-found':
          return 'Sorry, we could not find an account with this email address.';
        case 'weak-password':
          return 'Your password is too weak. It should be at least 8 character, '
              'however the strongest passwords have 12 or more characters.';
        case 'email-already-in-use':
          return 'This email belongs to a current user. If that is you, please '
              'trying logging in instead.';
        case 'user-disabled':
        case 'operation-not-allowed':
        case 'account-exists-with-different-credential':
        case 'invalid-credential':
        case 'invalid-verification-code':
        case 'invalid-verification-id':
          return 'An error occurred. Please check the form and try again.';
      }
    }
    return 'unknown error';
  }
}
