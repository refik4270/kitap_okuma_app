import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/book.dart';

class BookListScreen extends StatefulWidget {
  const BookListScreen({super.key});

  @override
  State<BookListScreen> createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  late Future<List<Book>> _booksFuture;

  @override
  void initState() {
    super.initState();
    _booksFuture = _fetchBooks();
  }

  Future<List<Book>> _fetchBooks() async {
    final snapshot = await FirebaseFirestore.instance.collection('books').get();
    return snapshot.docs.map((doc) {
      return Book.fromMap(doc.data(), id: doc.id);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kitaplar'),
        backgroundColor: Colors.deepPurple,
      ),
      body: FutureBuilder<List<Book>>(
        future: _booksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Kitap bulunamadı.'));
          }

          final books = snapshot.data!;

          return ListView.builder(
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                child: ListTile(
                  title: Text(book.title),
                  subtitle: Text('Yazar: ${book.author}'),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () {
                    // Burada kitabın detay sayfasına geçiş yapılabilir
                    // Örneğin:
                    // Navigator.push(context, MaterialPageRoute(builder: (_) => BookReaderScreen(book: book)));
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
