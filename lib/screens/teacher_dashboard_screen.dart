import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class TeacherDashboardScreen extends StatefulWidget {
  const TeacherDashboardScreen({super.key});

  @override
  State<TeacherDashboardScreen> createState() => _TeacherDashboardScreenState();
}

class _TeacherDashboardScreenState extends State<TeacherDashboardScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> _getAllStudents() async {
    final snapshot = await _firestore.collection('students').get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return data;
    }).toList();
  }

  String? _getLastReadDate(Map<String, dynamic> student) {
    if (student['readingLogs'] != null && student['readingLogs'].isNotEmpty) {
      final logs = List.from(student['readingLogs']);
      logs.sort((a, b) =>
          (b['date'] ?? '').toString().compareTo((a['date'] ?? '').toString()));
      return logs.first['date'];
    }
    return null;
  }

  Widget _buildStudentCard(Map<String, dynamic> student) {
    final lastDate = _getLastReadDate(student);
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ListTile(
        leading: const Icon(Icons.school, size: 40, color: Colors.deepPurple),
        title: Text(student['name'] ?? 'İsimsiz'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Yaş: ${student['age'] ?? '-'}'),
            Text('Puan: ${student['points'] ?? 0}'),
            Text('Okunan kitap: ${student['readBooks']?.length ?? 0}'),
            Text('Son Okuma: ${lastDate ?? "Yok"}'),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Öğretmen Paneli'),
        backgroundColor: Colors.deepPurple[700],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _getAllStudents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final students = snapshot.data ?? [];

          return ListView(
            children: [
              const SizedBox(height: 16),
              Center(
                child: Text(
                  'Toplam Öğrenci: ${students.length}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),
              ...students.map((student) => _buildStudentCard(student)).toList(),
            ],
          );
        },
      ),
    );
  }
}
