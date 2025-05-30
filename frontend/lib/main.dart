import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'ui/screen/onboarding_screen.dart';
import 'ui/screen/form.dart.dart'

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());

}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Onboarding Screen',
      home: LoginScreen(),
      debugShowCheckedModeBanner: false,

    );
  }
}
