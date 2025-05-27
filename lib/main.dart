import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:kitap_okuma_app/screens/student_dashboard_screen.dart';
import 'package:kitap_okuma_app/screens/login_screen.dart';
import 'package:kitap_okuma_app/screens/email_verification_screen.dart';
import 'package:kitap_okuma_app/screens/guest_screen.dart';
import 'package:kitap_okuma_app/screens/parent_dashboard_screen.dart';
import 'package:kitap_okuma_app/screens/teacher_dashboard_screen.dart';
import 'package:kitap_okuma_app/screens/student_login_screen.dart';
import 'package:kitap_okuma_app/screens/register_screen.dart';  // <-- Burası eklendi

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
        '/student_login': (context) => const StudentLoginScreen(),
        '/register': (context) => const RegisterScreen(),  // <-- Burası eklendi
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/student_dashboard') {
          final args = settings.arguments;
          if (args is! Map<String, dynamic>) {
            return MaterialPageRoute(
              builder: (context) => const Scaffold(
                body: Center(child: Text('Hata: Parametreler eksik veya yanlış türde!')),
              ),
            );
          }
          final studentId = args['studentId'];
          if (studentId == null || studentId is! String) {
            return MaterialPageRoute(
              builder: (context) => const Scaffold(
                body: Center(child: Text('Hata: studentId parametresi eksik veya geçersiz!')),
              ),
            );
          }
          return MaterialPageRoute(
            builder: (context) => StudentDashboardScreen(studentId: studentId),
          );
        }
        return null;
      },
    );
  }
}
