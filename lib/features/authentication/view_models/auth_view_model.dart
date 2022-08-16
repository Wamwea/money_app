// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:money_app/features/authentication/services/auth_service.dart';

class AuthState {
  bool isLoading;
  AuthenticationState authenticationState;
  AuthMixin? authMixin;
  AuthErrorMixin? errorMixin;
  bool showPassword;

  AuthState(
      {this.isLoading = false,
      this.showPassword = false,
      this.authenticationState = AuthenticationState.signing_in,
      this.authMixin,
      this.errorMixin});

  AuthState copyWith({
    bool? isLoading,
    bool? showPassword,
    AuthenticationState? authenticationState,
    bool? success,
    AuthMixin? authMixin,
    AuthErrorMixin? errorMixin,
  }) {
    return AuthState(
        isLoading: isLoading ?? this.isLoading,
        authenticationState: authenticationState ?? this.authenticationState,
        authMixin: authMixin ?? this.authMixin,
        showPassword: showPassword ?? this.showPassword,
        errorMixin: errorMixin ?? this.errorMixin);
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService = AuthService(FirebaseAuth.instance);

  AuthNotifier() : super(AuthState());

  connect({AuthMixin? authMixin, AuthErrorMixin? errorMixin}) =>
      state = state.copyWith(authMixin: authMixin, errorMixin: errorMixin);

  goToSignUp() => state =
      state.copyWith(authenticationState: AuthenticationState.signing_up);

  goToSignIn() => state =
      state.copyWith(authenticationState: AuthenticationState.signing_in);

  showPassword() => state = state.copyWith(showPassword: !state.showPassword);

  goToForgotPassword() {
    state = state.copyWith(
        authenticationState: AuthenticationState.forgot_password);
    log(state.authenticationState.toString());
  }

  Future<void> signIn(String email, String password) async {
    _execute(() async {
      final result = await _authService.signInWithEmailAndPassword(
          email: email, password: password);
      if (result != null) {
        state.authMixin!.onAuthenticated(result.user!);
      }
    });
  }

  Future<void> signUp(String email, String password) async {
    _execute(() async {
      final result = await _authService.signUpWithEmailAndPassWord(
          email: email, password: password);
      if (result != null) {
        state.authMixin!.onAuthenticated(result.user!);
      }
    });
  }

  Future<void> signOut() async {
    _execute(() async {
      await _authService.signOut();
    });
  }

  _execute(AsyncCallback function) async {
    try {
      state = state.copyWith(isLoading: true);
      await function.call();
    } on FirebaseAuthException catch (exception) {
      state.errorMixin!.onError(exception);
    } catch (exception) {
      state.errorMixin!.onError(FirebaseAuthException(code: 'unknown'));
    }
    state = state.copyWith(isLoading: false);
  }

  static String exceptionToMessage([dynamic exception]) {
    if (exception is FirebaseAuthException) {
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

    return 'An error occurred. Please try again.';
  }
}

enum AuthenticationState { signing_in, signing_up, forgot_password }

final authStateProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) => AuthNotifier());

mixin AuthMixin {
  void onAuthenticated(User user);
}

mixin AuthErrorMixin {
  void onError(FirebaseAuthException exception);
}
