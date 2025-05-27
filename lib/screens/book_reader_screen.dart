import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookReaderScreen extends StatefulWidget {
  final String title;

  const BookReaderScreen({super.key, required this.title});

  @override
  State<BookReaderScreen> createState() => _BookReaderScreenState();
}

class _BookReaderScreenState extends State<BookReaderScreen> {
  bool _isLoading = false;
  String? _message;
  Color _messageColor = Colors.green;

  // Kitap kelime sayıları (dilersen kitaplara göre burayı genişlet)
  final Map<String, int> _bookWordCounts = {
    'Kırmızı Başlıklı Kız': 140,
    'Pamuk Prenses': 180,
    'Hansel ve Gretel': 200,
  };

  Future<void> _markBookAsRead() async {
    setState(() {
      _isLoading = true;
      _message = null;
    });

    final firestore = FirebaseFirestore.instance;
    final String studentName = 'aras'; // 🔁 Şimdilik sabit, ileride oturumdan alınacak

    try {
      final studentQuery = await firestore
          .collection('students')
          .where('name', isEqualTo: studentName)
          .get();

      if (studentQuery.docs.isNotEmpty) {
        final studentDoc = studentQuery.docs.first;
        final data = studentDoc.data();
        final docRef = firestore.collection('students').doc(studentDoc.id);

        final currentPoints = data.containsKey('points') ? data['points'] : 0;
        final List<dynamic> readBooks =
            data.containsKey('readBooks') ? List.from(data['readBooks']) : [];
        final List<dynamic> readingLogs =
            data.containsKey('readingLogs') ? List.from(data['readingLogs']) : [];

        if (!readBooks.contains(widget.title)) {
          // 🔢 Kelime sayısı ve süreyi al
          final wordCount = _bookWordCounts[widget.title] ?? 100;
          final readMinutes = (wordCount / 25).round(); // Tahmini okuma süresi

          // 📅 Bugünün tarihi (YIL-AY-GÜN formatında)
          final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

          // 🔖 Yeni okuma kaydı oluştur
          final newLog = {
            'date': today,
            'book': widget.title,
            'words': wordCount,
            'minutes': readMinutes,
          };

          await docRef.update({
            'points': currentPoints + 10,
            'readBooks': [...readBooks, widget.title],
            'readingLogs': [...readingLogs, newLog],
          });

          setState(() {
            _message = '✅ Kitap okundu! 10 puan kazandın.';
            _messageColor = Colors.green;
          });
        } else {
          setState(() {
            _message = '⚠️ Bu kitabı zaten okudun!';
            _messageColor = Colors.orange;
          });
        }
      } else {
        setState(() {
          _message = '⚠️ Öğrenci bulunamadı!';
          _messageColor = Colors.red;
        });
      }
    } catch (e) {
      setState(() {
        _message = '❌ Hata oluştu: $e';
        _messageColor = Colors.red;
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.green[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  'Bu sayfada "${widget.title}" kitabının içeriği gösterilecek.\n\n'
                  'Şimdilik örnek metin yer alıyor. Sonraki aşamada gerçek içerikler eklenecek.',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
            if (_message != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Text(
                  _message!,
                  style: TextStyle(color: _messageColor, fontSize: 16),
                ),
              ),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _markBookAsRead,
              icon: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : const Icon(Icons.check),
              label: Text(_isLoading ? 'Kaydediliyor...' : 'Kitabı Bitirdim'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
