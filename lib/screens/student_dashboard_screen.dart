import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kitap_okuma_app/screens/book_reader_screen.dart';

class StudentDashboardScreen extends StatefulWidget {
  const StudentDashboardScreen({super.key});

  @override
  State<StudentDashboardScreen> createState() => _StudentDashboardScreenState();
}

class _StudentDashboardScreenState extends State<StudentDashboardScreen> {
  int _points = 0;
  List<String> _readBooks = [];

  final List<Map<String, String>> _books = const [
    {
      'title': 'Kırmızı Başlıklı Kız',
      'image': 'assets/books/book1.png',
    },
    {
      'title': 'Pamuk Prenses',
      'image': 'assets/books/book2.png',
    },
    {
      'title': 'Hansel ve Gretel',
      'image': 'assets/books/book3.png',
    },
  ];

  Future<void> _loadStudentData() async {
    final firestore = FirebaseFirestore.instance;

    try {
      final studentQuery = await firestore
          .collection('students')
          .where('name', isEqualTo: 'aras') // Şu an sabit kullanıcı adı
          .get();

      if (studentQuery.docs.isNotEmpty) {
        final studentDoc = studentQuery.docs.first;
        final data = studentDoc.data();

        setState(() {
          _points = data.containsKey('points') ? data['points'] : 0;
          _readBooks = data.containsKey('readBooks')
              ? List<String>.from(data['readBooks'])
              : [];
        });
      }
    } catch (e) {
      print('Hata oluştu: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadStudentData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Öğrenci Paneli'),
        backgroundColor: Colors.green[700],
      ),
      body: RefreshIndicator(
        onRefresh: _loadStudentData,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Center(
                child: Column(
                  children: [
                    const Icon(Icons.emoji_events, size: 60, color: Colors.amber),
                    const SizedBox(height: 10),
                    Text(
                      'Toplam Puan: $_points',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    const Divider(thickness: 1),
                    const SizedBox(height: 10),
                    const Text('Kitaplar:', style: TextStyle(fontSize: 18)),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              ..._books.map((book) {
                final isRead = _readBooks.contains(book['title']);
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: Image.asset(book['image']!, width: 50, height: 50),
                    title: Text(book['title']!, style: const TextStyle(fontSize: 18)),
                    trailing: isRead
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        : const Icon(Icons.arrow_forward),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookReaderScreen(title: book['title']!),
                        ),
                      ).then((_) => _loadStudentData()); // okuma sonrası güncelleme
                    },
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
