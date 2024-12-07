import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/widgets/vocabulary_card.dart';
import 'detail_screen.dart';

class DictionaryScreen extends StatefulWidget {
  const DictionaryScreen({Key? key}) : super(key: key);

  @override
  State<DictionaryScreen> createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends State<DictionaryScreen> {
  List<Map<String, String>> _vocabularyList = [];

  @override
  void initState() {
    super.initState();
    _loadVocabularyData();
  }

  Future<void> _loadVocabularyData() async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/vocabulary_card.json');
      final List<dynamic> jsonData = json.decode(jsonString);
      setState(() {
        _vocabularyList = jsonData
            .cast<Map<String, dynamic>>() // Cast elemen ke Map<String, dynamic>
            .map((item) => {
                  "title": item["title"] as String,
                  "description": item["description"] as String,
                  "imagePath": item["imagePath"] as String,
                })
            .toList();
      });
    } catch (e) {
      debugPrint('Error loading vocabulary data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Hai, ingin belajar kosakata apa hari ini?',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: 'Bahasa Isyarat Indonesia',
            items: const [
              DropdownMenuItem(
                value: 'Bahasa Isyarat Indonesia',
                child: Text('Bahasa Isyarat Indonesia'),
              ),
            ],
            onChanged: (value) {},
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: _vocabularyList.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: _vocabularyList.length,
                    itemBuilder: (context, index) {
                      final item = _vocabularyList[index];
                      return VocabularyCard(
                        title: item['title']!,
                        description: item['description']!,
                        imagePath: item['imagePath']!,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailScreen(
                                title: item['title']!,
                                description: item['description']!,
                                imagePath: item['imagePath']!,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
