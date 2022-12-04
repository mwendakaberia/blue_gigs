import 'package:easy_rent/providers/control_providers.dart';
import 'package:easy_rent/screens/login.dart';
import 'package:easy_rent/utils/themes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ProviderScope(child: MyApp(),),);
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder:(context, ref, child) {
        final value=ref.watch(theme).state;
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Easy Rent',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: value,
          home: LoginPage(),
        );
      });
      }
}
