import 'package:contact_app2/core/routes/app_rouet.dart';
import 'package:contact_app2/feature/view/screens/home_screen.dart';
import 'package:contact_app2/feature/view/screens/new_contact.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ContactApp());
}

class ContactApp extends StatelessWidget {
  const ContactApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: AppRouet.home,
      routes: {
        AppRouet.home: (context) => HomeScreen(),
        AppRouet.newContact: (context) => NewContact(),
      },
    );
  }
}
