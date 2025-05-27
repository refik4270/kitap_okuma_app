import 'package:flutter/material.dart';
import 'package:kitap_okuma_app/screens/book_reader_screen.dart';

class StudentDashboardScreen extends StatelessWidget {
  const StudentDashboardScreen({super.key});

  final List<Map<String, String>> books = const [
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Öğrenci Paneli'),
        backgroundColor: Colors.green[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: books.length,
          itemBuilder: (context, index) {
            final book = books[index];
            return Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                leading: Image.asset(book['image']!, width: 50, height: 50),
                title: Text(book['title']!, style: const TextStyle(fontSize: 18)),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          BookReaderScreen(title: book['title']!),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
