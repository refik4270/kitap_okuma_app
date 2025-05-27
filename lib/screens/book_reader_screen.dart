import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/book.dart';

class BookReaderScreen extends StatefulWidget {
  final Book book;

  const BookReaderScreen({super.key, required this.book});

  @override
  State<BookReaderScreen> createState() => _BookReaderScreenState();
}

class _BookReaderScreenState extends State<BookReaderScreen> {
  int currentPageIndex = 0;
  final FlutterTts flutterTts = FlutterTts();

  String? imageUrl;
  bool isLoadingImage = false;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    setState(() {
      isLoadingImage = true;
    });
    try {
      final storageRef = FirebaseStorage.instance.ref();
      // Firebase Storage'da kitap sayfa resimleri şu yapıda olsun diyelim:
      // books/{bookId}/pages/{pageIndex}.jpg
      final path = 'books/${widget.book.id}/pages/$currentPageIndex.jpg';
      final url = await storageRef.child(path).getDownloadURL();
      setState(() {
        imageUrl = url;
      });
    } catch (e) {
      setState(() {
        imageUrl = null;
      });
    }
    setState(() {
      isLoadingImage = false;
    });
  }

  void _speakWord(String word) async {
    await flutterTts.setLanguage('tr-TR');
    await flutterTts.speak(word);
  }

  void _nextPage() {
    if (currentPageIndex < widget.book.pages.length - 1) {
      setState(() {
        currentPageIndex++;
        imageUrl = null;
      });
      _loadImage();
    }
  }

  void _previousPage() {
    if (currentPageIndex > 0) {
      setState(() {
        currentPageIndex--;
        imageUrl = null;
      });
      _loadImage();
    }
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pageText = widget.book.pages[currentPageIndex];

    // Kelimeleri ayır ve her kelimeyi tıklanabilir yap
    final words = pageText.split(' ');

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.book.title} - Sayfa ${currentPageIndex + 1}'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          // Resim alanı
          Expanded(
            flex: 4,
            child: isLoadingImage
                ? const Center(child: CircularProgressIndicator())
                : imageUrl != null
                    ? Image.network(imageUrl!, fit: BoxFit.contain)
                    : const Center(child: Text('Resim bulunamadı')),
          ),

          const Divider(),

          // Metin alanı, kelimeler tıklanabilir
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Wrap(
                spacing: 6,
                runSpacing: 10,
                children: words.map((word) {
                  return GestureDetector(
                    onTap: () => _speakWord(word),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple[100],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        word,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Sayfa değiştirme butonları
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: currentPageIndex > 0 ? _previousPage : null,
                  child: const Text('Önceki Sayfa'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                ),
                ElevatedButton(
                  onPressed: currentPageIndex < widget.book.pages.length - 1 ? _nextPage : null,
                  child: const Text('Sonraki Sayfa'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
