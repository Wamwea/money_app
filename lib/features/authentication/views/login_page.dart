import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:money_app/features/authentication/view_models/auth_view_model.dart';
import 'package:money_app/features/home/pages/home_page.dart';
import 'package:money_app/gen/assets.gen.dart';

class LoginPage extends ConsumerStatefulWidget {
  static const routeName = 'login';
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> with AuthMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  Logger logger = Logger('LoginPage');

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.refresh(authStateProvider);
    });
    super.initState();
  }

  @override
  void onAuthenticated(User user) {
    logger.info('User authenticated: $user');
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomePage()));
    // TODO: implement onAuthenticated
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authStateProvider);
    final notifier = ref.read(authStateProvider.notifier);

    final appSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffe8eaf6),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                    width: appSize.width * 0.5,
                    height: appSize.height * 0.3,
                    child: Assets.svg.umbrella.svg()),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Hi!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                          ),
                        ),
                        Text(
                          state.authenticationState ==
                                  AuthenticationState.signing_up
                              ? 'Welcome to Money App'
                              : 'Sign in to continue!',
                          style: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    )),
                const SizedBox(height: 16),
                Container(
                    padding: const EdgeInsets.all(16),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.transparent.withOpacity(0.1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        LoginTextField('Email', _emailController),
                        const SizedBox(height: 16),
                        LoginTextField(
                          'Password',
                          _passwordController,
                          password: true,
                        ),
                        const SizedBox(height: 24),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () => notifier.goToForgotPassword(),
                            child: Text(
                              'Forgot your password?',
                              style: TextStyle(
                                  color: Color(0xff02c38e),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        LoginButton(
                          onTap: () => notifier.signIn(
                              _emailController.text, _passwordController.text),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Text('Dont have an account?',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(width: 4),
                            GestureDetector(
                              onTap: () => notifier.goToSignUp(),
                              child: Text(
                                'Sign up',
                                style: TextStyle(
                                    color: Color(0xff02c38e),
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LoginButton extends ConsumerWidget {
  const LoginButton({Key? key, required this.onTap}) : super(key: key);
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authStateProvider);
    return GestureDetector(
      onTap: () {
        if (state.isLoading) return;
        onTap.call();
      },
      child: Container(
        decoration: BoxDecoration(
            color: const Color(0xff02c38e),
            borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: state.isLoading
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : Text(
                  state.authenticationState == AuthenticationState.signing_up
                      ? 'Create Account'
                      : 'Login',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
        ),
      ),
    );
  }
}

class LoginTextField extends ConsumerWidget {
  const LoginTextField(this.title, this.controller,
      {Key? key, this.password = false})
      : super(key: key);

  final TextEditingController controller;
  final String title;
  final bool password;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(authStateProvider.notifier);
    final state = ref.watch(authStateProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 50,
          child: TextFormField(
            controller: controller,
            obscureText: password ? !state.showPassword : false,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 8),
                suffixIcon: password
                    ? IconButton(
                        onPressed: () => notifier.showPassword(),
                        icon: Icon(state.showPassword
                            ? Icons.visibility_off
                            : Icons.visibility))
                    : null,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                filled: true,
                fillColor: Colors.white),
            keyboardType: TextInputType.text,
          ),
        ),
      ],
    );
  }
}
