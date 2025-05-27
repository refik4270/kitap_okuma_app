import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReadingLogsScreen extends StatefulWidget {
  final String studentId;

  const ReadingLogsScreen({super.key, required this.studentId});

  @override
  State<ReadingLogsScreen> createState() => _ReadingLogsScreenState();
}

class _ReadingLogsScreenState extends State<ReadingLogsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> _fetchReadingLogs() async {
    final doc = await _firestore.collection('students').doc(widget.studentId).get();
    if (!doc.exists) return [];

    final data = doc.data();
    if (data == null || data['readingLogs'] == null) return [];

    final List<dynamic> logsDynamic = data['readingLogs'];
    return logsDynamic.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Okuma Kayıtları'),
        backgroundColor: Colors.deepPurple[700],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchReadingLogs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final logs = snapshot.data ?? [];

          if (logs.isEmpty) {
            return const Center(child: Text('Okuma kaydı bulunamadı.'));
          }

          return ListView.builder(
            itemCount: logs.length,
            itemBuilder: (context, index) {
              final log = logs[index];
              final date = log['date'] ?? 'Bilinmeyen Tarih';
              final bookTitle = log['bookTitle'] ?? 'Bilinmeyen Kitap';
              final duration = log['durationMinutes']?.toString() ?? '0';

              return ListTile(
                leading: const Icon(Icons.book),
                title: Text(bookTitle),
                subtitle: Text('Okuma Süresi: $duration dakika\nTarih: $date'),
              );
            },
          );
        },
      ),
    );
  }
}
