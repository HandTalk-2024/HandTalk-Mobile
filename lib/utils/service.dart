import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/widgets/vocabulary_card.dart';

class DictionaryScreen extends StatefulWidget {
  const DictionaryScreen({Key? key}) : super(key: key);

  @override
  State<DictionaryScreen> createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends State<DictionaryScreen> {
  List<Map<String, String>> vocabularyData = [];

  @override
  void initState() {
    super.initState();
    loadVocabularyData();
  }

  Future<void> loadVocabularyData() async {
    final String jsonString =
        await rootBundle.loadString('assets/vocabulary_card.json');
    final List<dynamic> jsonData = json.decode(jsonString);

    setState(() {
      vocabularyData =
          jsonData.map((item) => Map<String, String>.from(item)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return vocabularyData.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.8,
              ),
              itemCount: vocabularyData.length,
              itemBuilder: (context, index) {
                final vocab = vocabularyData[index];
                return VocabularyCard(
                  title: vocab['title']!,
                  imagePath: vocab['imageUrl']!,
                  description: vocab['details']!,
                  onTap: () {
                    // Lakukan sesuatu saat item diklik
                  },
                );
              },
            ),
          );
  }
}
