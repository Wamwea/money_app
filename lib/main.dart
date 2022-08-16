import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logging/logging.dart';
import 'package:money_app/core/utils/defs.dart';
import 'package:money_app/features/authentication/view_models/auth_view_model.dart';
import 'package:money_app/features/authentication/views/signup_page.dart';
import 'package:money_app/features/home/pages/home_page.dart';
import 'package:money_app/firebase_options.dart';

import 'features/authentication/views/login_page.dart';

void main() async {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    log('${record.loggerName} [${record.level}]: ${record.message}');
  });
  final logger = Logger('AppStart');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  logger.info('App started');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: Colors.grey.shade400,
          primarySwatch: Colors.blue,
          textTheme: GoogleFonts.numansTextTheme(),
        ),
        home: FirebaseAuth.instance.currentUser != null
            ? HomePage()
            : const AuthProvider(),
      ),
    );
  }
}

class AuthProvider extends ConsumerStatefulWidget {
  const AuthProvider({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AuthProviderState();
}

class _AuthProviderState extends ConsumerState<AuthProvider>
    with AuthMixin, AuthErrorMixin {
  @override
  void initState() {
    ref
        .read(authStateProvider.notifier)
        .connect(authMixin: this, errorMixin: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authStateProvider);

    switch (state.authenticationState) {
      case AuthenticationState.signing_in:
        return LoginPage();
      case AuthenticationState.signing_up:
        return SignupPage();
      case AuthenticationState.forgot_password:
        return HomePage();
    }
  }

  @override
  void onAuthenticated(User user) {
    log('USER IS AUTHENTICATED');
    Navigator.push(
        context, MaterialPageRoute(builder: ((context) => HomePage())));
  }

  @override
  void onError(FirebaseAuthException exception) {
    context.showErrorDialog(exception.toFormattedString);
  }
}
