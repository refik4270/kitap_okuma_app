// lib/screens/avatar_screen.dart
import 'package:flutter/material.dart';

class AvatarSelectionScreen extends StatefulWidget {
  const AvatarSelectionScreen({super.key});

  @override
  State<AvatarSelectionScreen> createState() => _AvatarSelectionScreenState();
}

class _AvatarSelectionScreenState extends State<AvatarSelectionScreen> {
  int _selectedAvatar = 0;

  final List<String> _avatars = [
    'assets/avatars/avatar1.png',
    'assets/avatars/avatar2.png',
    'assets/avatars/avatar3.png',
    'assets/avatars/avatar4.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Avatar Seçimi'),
        backgroundColor: Colors.blue[700],
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'Kendine bir avatar seç!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
              ),
              itemCount: _avatars.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => setState(() => _selectedAvatar = index),
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: _selectedAvatar == index
                          ? Border.all(color: Colors.blue, width: 3)
                          : null,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Image.asset(_avatars[index]),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: () {
                  // TODO: Avatar kaydetme işlemi
                  Navigator.pushNamed(context, '/student_register');
                },
                child: const Text('Devam Et', style: TextStyle(fontSize: 16)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}