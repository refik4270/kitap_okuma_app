import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ParentDashboardScreen extends StatefulWidget {
  const ParentDashboardScreen({super.key});

  @override
  State<ParentDashboardScreen> createState() => _ParentDashboardScreenState();
}

class _ParentDashboardScreenState extends State<ParentDashboardScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _saveStudent() async {
    String name = _nameController.text.trim();
    String age = _ageController.text.trim();
    String password = _passwordController.text.trim();

    if (name.isEmpty || age.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tüm alanları doldurun')),
      );
      return;
    }

    try {
      await _firestore.collection('students').add({
        'name': name,
        'age': age,
        'password': password,
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Öğrenci başarıyla kaydedildi')),
      );

      _nameController.clear();
      _ageController.clear();
      _passwordController.clear();
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hata oluştu: $e')),
      );
    }
  }

  void _showAddStudentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Öğrenci Ekle'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Öğrenci Adı'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _ageController,
                decoration: const InputDecoration(labelText: 'Yaş'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Şifre'),
                obscureText: true,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: _saveStudent,
            child: const Text('Ekle'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Veli Paneli'),
        backgroundColor: Colors.blue[700],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.family_restroom, size: 100, color: Colors.blue),
            const SizedBox(height: 20),
            const Text(
              'Hoş geldiniz, Sayın Veli!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Buradan çocuğunuzun okuma durumunu takip edebilirsiniz.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: _showAddStudentDialog,
              icon: const Icon(Icons.person_add),
              label: const Text('Öğrenci Ekle'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
