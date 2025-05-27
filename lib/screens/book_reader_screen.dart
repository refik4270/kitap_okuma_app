import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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

  Future<void> _markBookAsRead() async {
    setState(() {
      _isLoading = true;
      _message = null;
    });

    final firestore = FirebaseFirestore.instance;

    try {
      final studentQuery = await firestore
          .collection('students')
          .where('name', isEqualTo: 'aras') // 👈 ÖĞRENCİ ADI (şu an sabit)
          .get();

      if (studentQuery.docs.isNotEmpty) {
        final studentDoc = studentQuery.docs.first;
        final data = studentDoc.data();
        final currentPoints = data.containsKey('points') ? data['points'] : 0;
        final List<dynamic> readBooks =
            data.containsKey('readBooks') ? List.from(data['readBooks']) : [];

        if (!readBooks.contains(widget.title)) {
          await firestore.collection('students').doc(studentDoc.id).update({
            'points': currentPoints + 10,
            'readBooks': [...readBooks, widget.title],
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
