import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class StudentDashboardScreen extends StatefulWidget {
  final String studentId;

  const StudentDashboardScreen({Key? key, required this.studentId}) : super(key: key);

  @override
  State<StudentDashboardScreen> createState() => _StudentDashboardScreenState();
}

class _StudentDashboardScreenState extends State<StudentDashboardScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> _getStudentData() async {
    final doc = await _firestore.collection('students').doc(widget.studentId).get();
    if (doc.exists) {
      final data = doc.data();
      if (data != null) {
        data['id'] = doc.id;
        return data;
      }
    }
    return null;
  }

  String? _getLastReadDate(Map<String, dynamic> student) {
    if (student['readingLogs'] != null && (student['readingLogs'] as List).isNotEmpty) {
      final logs = List<Map<String, dynamic>>.from(student['readingLogs']);
      logs.sort((a, b) =>
          (b['date'] ?? '').toString().compareTo((a['date'] ?? '').toString()));
      return logs.first['date'];
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Öğrenci Paneli'),
        backgroundColor: Colors.deepPurple[700],
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _getStudentData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Öğrenci bilgisi bulunamadı.'));
          }

          final student = snapshot.data!;
          final lastDate = _getLastReadDate(student);
          final readBooks = student['readBooks'] as List? ?? [];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student['name'] ?? 'İsimsiz Öğrenci',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text('Yaş: ${student['age'] ?? '-'}'),
                Text('Puan: ${student['points'] ?? 0}'),
                Text('Okunan Kitap Sayısı: ${readBooks.length}'),
                Text('Son Okuma Tarihi: ${lastDate ?? "Yok"}'),
                const SizedBox(height: 20),
                const Text(
                  'Okuma Günlükleri:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: (student['readingLogs'] != null && (student['readingLogs'] as List).isNotEmpty)
                      ? ListView.builder(
                          itemCount: (student['readingLogs'] as List).length,
                          itemBuilder: (context, index) {
                            final log = (student['readingLogs'] as List)[index];
                            final dateStr = log['date'] ?? '';
                            final formattedDate = _formatDate(dateStr);
                            final duration = log['duration'] ?? 0;
                            final wordsRead = log['wordsRead'] ?? 0;
                            return Card(
                              child: ListTile(
                                title: Text('Tarih: $formattedDate'),
                                subtitle: Text('Okuma Süresi: $duration dakika\nKelime Sayısı: $wordsRead'),
                              ),
                            );
                          },
                        )
                      : const Text('Okuma günlüğü boş.'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd.MM.yyyy').format(date);
    } catch (e) {
      return dateStr;
    }
  }
}
