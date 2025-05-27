import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentLoginScreen extends StatefulWidget {
  const StudentLoginScreen({super.key});

  @override
  State<StudentLoginScreen> createState() => _StudentLoginScreenState();
}

class _StudentLoginScreenState extends State<StudentLoginScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _errorMessage = '';
  bool _isLoading = false;

  Future<void> _loginStudent() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final query = await _firestore
          .collection('students')
          .where('name', isEqualTo: _nameController.text.trim())
          .where('password', isEqualTo: _passwordController.text.trim())
          .get();

      if (query.docs.isNotEmpty) {
        // Başarılı giriş → öğrenci paneline yönlendir
        Navigator.pushReplacementNamed(context, '/student_dashboard');
      } else {
        setState(() {
          _errorMessage = 'Kullanıcı adı veya şifre yanlış.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Hata: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Öğrenci Girişi'),
        backgroundColor: Colors.blue[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text('Kullanıcı Adı', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Öğrenci Adı',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Şifre', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Şifre',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _loginStudent,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Giriş Yap'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
