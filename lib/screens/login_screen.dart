import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Resim assets klasöründen çağrılıyor
                Image.asset(
                  'assets/images/login_logo.png',
                  height: 150,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.error, size: 150, color: Colors.red);
                  },
                ),
                const SizedBox(height: 30),
                _buildLoginButton(
                  context,
                  'ÖĞRENCİ',
                  Icons.child_care,
                  onPressed: () => Navigator.pushNamed(context, '/student_login'),
                ),
                _buildLoginButton(
                  context,
                  'VELİ',
                  Icons.family_restroom,
                  onPressed: () => Navigator.pushNamed(context, '/email_verification'),
                ),
                _buildLoginButton(
                  context,
                  'ÖĞRETMEN',
                  Icons.school,
                  onPressed: () => Navigator.pushNamed(context, '/teacher_dashboard'),
                ),
                _buildLoginButton(
                  context,
                  'MİSAFİR',
                  Icons.explore,
                  onPressed: () => Navigator.pushNamed(context, '/guest'),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: const Text(
                    'Kayıt Ol',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context, String text, IconData icon,
      {required VoidCallback onPressed}) {
    return Container(
      width: 250,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[700],
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24),
            const SizedBox(width: 10),
            Text(text, style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
