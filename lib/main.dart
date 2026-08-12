import 'package:disneyapp/screens/app_shell.dart';
import 'package:disneyapp/screens/auth/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:disneyapp/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:disneyapp/services/auth_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    return MaterialApp(
      home: StreamBuilder(
        stream: authService.user,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return AppShell();
          } else {
            return AuthScreen();
          }
        },
      ),
      theme: AppTheme.light,
    );
  }
}
