import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';
import 'package:money_app/features/authentication/view_models/auth_view_model.dart';

@LazySingleton()
class AuthService {
  AuthService(
    this._firebaseAuth,
  ) {
    _firebaseAuth.authStateChanges().listen((User? user) async {
      if (_authMixin != null) {
        _authMixin!.onAuthenticated(user!);
      }
    });
  }

  User? get user => _firebaseAuth.currentUser;
  //dependencies
  final FirebaseAuth _firebaseAuth;
  AuthMixin? _authMixin;
  //utils
  Logger log = Logger('Authentication Service');
  Future<UserCredential?> signUpWithEmailAndPassWord(
      {required String email, required String password}) async {
    log.info('Creating user with email');
    UserCredential? result;
    result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);

    return result;
  }

  Future<UserCredential?> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    UserCredential? result;
    log.info('Attempting to log in user');
    result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);

    return result;
  }

  Future<void> signOut() async {
    log.info('Signing out user');
    try {
      await _firebaseAuth.signOut();
    } catch (exception, stackTrace) {
      log.severe('Error logging out: $exception , $stackTrace');
    }
  }
}
