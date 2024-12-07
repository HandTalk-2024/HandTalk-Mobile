import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class TranscriptionScreen extends StatefulWidget {
  const TranscriptionScreen({Key? key}) : super(key: key);

  @override
  _TranscribeScreenState createState() => _TranscribeScreenState();
}

class _TranscribeScreenState extends State<TranscriptionScreen> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = 'Tekan tombol untuk memulai...';

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
            }
          }),
          localeId: 'id_ID', // Mengatur bahasa ke bahasa Indonesia
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Transkripsi Suara',
          style:
              TextStyle(color: Color(0xFF04364A)),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF64CCC5),
        iconTheme: const IconThemeData(color: Color(0xFF04364A)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF64CCC5),
        onPressed: _listen,
        child: Icon(
          _isListening ? Icons.mic : Icons.mic_none,
          color: const Color(0xFF04364A),
        ),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Container(
          padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 150.0),
          child: Text(
            _text,
            style: const TextStyle(
              fontSize: 20.0,
              color: const Color(0xFF64CCC5),
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
