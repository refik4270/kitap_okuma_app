import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _errorMessage = "Şifreler uyuşmuyor.";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Firebase Authentication ile kullanıcı oluştur
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim());

      // Firestore’a ekstra kullanıcı bilgilerini kaydet
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'email': _emailController.text.trim(),
        'name': _nameController.text.trim(),
        'city': _cityController.text.trim(),
        'district': _districtController.text.trim(),
        'phone': _phoneController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Kayıt başarılı ise giriş sayfasına dön veya başka bir sayfaya yönlendir
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message;
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Bir hata oluştu, lütfen tekrar deneyin.";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _cityController.dispose();
    _districtController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kayıt Ol')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                if (_errorMessage != null)
                  Container(
                    color: Colors.red[100],
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        const Icon(Icons.error, color: Colors.red),
                        const SizedBox(width: 10),
                        Expanded(
                            child: Text(_errorMessage ?? '',
                                style: const TextStyle(color: Colors.red))),
                      ],
                    ),
                  ),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'E-posta'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'E-posta boş olamaz';
                    if (!value.contains('@')) return 'Geçerli bir e-posta giriniz';
                    return null;
                  },
                ),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Ad Soyad'),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Ad Soyad boş olamaz';
                    return null;
                  },
                ),
                TextFormField(
                  controller: _cityController,
                  decoration: const InputDecoration(labelText: 'İl'),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'İl boş olamaz';
                    return null;
                  },
                ),
                TextFormField(
                  controller: _districtController,
                  decoration: const InputDecoration(labelText: 'İlçe'),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'İlçe boş olamaz';
                    return null;
                  },
                ),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Telefon'),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Telefon boş olamaz';
                    if (!RegExp(r'^\+?[0-9]{7,15}$').hasMatch(value)) return 'Geçerli bir telefon numarası giriniz';
                    return null;
                  },
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Şifre'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Şifre boş olamaz';
                    if (value.length < 6) return 'Şifre en az 6 karakter olmalı';
                    return null;
                  },
                ),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: const InputDecoration(labelText: 'Şifre Tekrar'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Şifre tekrar boş olamaz';
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _register,
                        child: const Text('Kayıt Ol'),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
