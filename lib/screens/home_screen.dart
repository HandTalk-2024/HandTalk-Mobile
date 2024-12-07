import 'package:flutter/material.dart';
import 'speech_to_text_screen.dart';
import 'dictionary_screen.dart';
import 'detection_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 1;

  final List<Widget> _pages = [
    const TranscriptionScreen(),
    const DictionaryScreen(),
    const DetectionScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HandTalk', style: TextStyle(color: const Color(0xFF04364A), fontWeight: FontWeight.bold),),
        centerTitle: true,
        backgroundColor: const Color(0xFF64CCC5),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.translate),
            label: 'Transkripsi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Kamus',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.gesture),
            label: 'Terjemah',
          ),
        ],
        backgroundColor:const Color(0xFF64CCC5),
        selectedItemColor: const Color(0xFF04364A),
        unselectedItemColor: const Color(0xFF9FE6E0),
      ),
    );
  }
}
