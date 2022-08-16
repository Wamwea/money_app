import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:money_app/core/utils/defs.dart';
import 'package:money_app/features/authentication/view_models/auth_view_model.dart';
import 'package:money_app/features/authentication/views/login_page.dart';
import 'package:money_app/features/home/pages/home_page.dart';
import 'package:money_app/gen/assets.gen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignupPage extends ConsumerStatefulWidget {
  static const routeName = 'signUp';
  const SignupPage({Key? key}) : super(key: key);
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> with AuthMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final log = Logger('SignUpPage');
  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(authStateProvider.notifier);
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffe8eaf6),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => log.info('ASASFASFAS'),
                  child: SizedBox(
                      width: context.appSize.width * 0.5,
                      height: context.appSize.height * 0.25,
                      child: Assets.svg.umbrella.svg()),
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Hey There!',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                          ),
                        ),
                        Text(
                          'Welcome to Money App!',
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
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
                        LoginTextField('Password', _passwordController,
                            password: true),
                        const SizedBox(height: 16),
                        LoginTextField(
                            'Confirm Password', _confirmPasswordController,
                            password: true),
                        const SizedBox(height: 24),
                        LoginButton(onTap: () async {
                          if (_confirmPasswordController.text ==
                              _passwordController.text) {
                            await notifier.signUp(_emailController.text,
                                _passwordController.text);
                          } else {
                            log.severe('Passwords do not match');
                            context.showErrorDialog('Passwords do not match');
                          }
                        }),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Text('Already have an account?',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(width: 4),
                            GestureDetector(
                              onTap: () => notifier.goToSignIn(),
                              child: Text(
                                'Sign In',
                                style: TextStyle(
                                    color: Color(0xff02c38e),
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void onAuthenticated(User user) {
    // TODO: implement onAuthenticated

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }
}
