import 'package:kitap_okuma_app/screens/book_reader_screen.dart';
import 'package:kitap_okuma_app/screens/student_dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:kitap_okuma_app/screens/login_screen.dart';
import 'package:kitap_okuma_app/screens/email_verification_screen.dart';
import 'package:kitap_okuma_app/screens/guest_screen.dart';
import 'package:kitap_okuma_app/screens/parent_dashboard_screen.dart';
import 'package:kitap_okuma_app/screens/teacher_dashboard_screen.dart';
import 'package:kitap_okuma_app/screens/student_login_screen.dart'; // 👈 yeni eklendi

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const KitapOkumaApp());
}

class KitapOkumaApp extends StatelessWidget {
  const KitapOkumaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kitap Okuma Uygulaması',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'ComicNeue',
      ),
      home: const LoginScreen(),
      routes: {
        '/email_verification': (context) => const EmailVerificationScreen(),
        '/guest': (context) => const GuestScreen(),
        '/parent_dashboard': (context) => const ParentDashboardScreen(),
        '/teacher_dashboard': (context) => const TeacherDashboardScreen(),
        '/student_login': (context) => const StudentLoginScreen(), // 👈 öğrenci girişi
        '/student_dashboard': (context) => const StudentDashboardScreen(),
        // Book ekranı yönlendirmesi için (parametreli geçişte gerekmez ama future-proof)
      },
    );
  }
}
