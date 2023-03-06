import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:pdf_text/pdf_text.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // final File pdfFile = File('assets/sample.pdf');

  final FlutterTts tts = FlutterTts();

  PDFDoc? _pdfDoc;

  String _text = "";

  Future _pickPDFText() async {
    var filePickerResult = await FilePicker.platform.pickFiles();
    if (filePickerResult != null) {
      _pdfDoc = await PDFDoc.fromPath(filePickerResult.files.single.path!);
      setState(() {});
    }
  }

  Future<String> _extractTextFromPDF() async {
    var doc = _pdfDoc;
    String docText = await doc!.text;
    print('Text: ${docText.toString()}');
    StringBuffer text = StringBuffer();
    for (var page in doc.pages) {
      var pageText = await page.text;
      text.writeln(pageText);
      print(pageText);
      _text = pageText;
    }
    print('Text: ${text.toString()}}');
    return text.toString();
  }

  Future<void> _speakText() async {
    var text = await _extractTextFromPDF();
    print('Text: ${text.toString()}');
    await tts.setLanguage('ar-EG');
    await tts.setVoice({"name": "Karen", "locale": "ar-EG"});
    await tts.setSpeechRate(0.5);
    await tts.setPitch(1.0);
    await tts.setVolume(1.0);
    await tts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF to Text to Speech'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(
              onPressed: _pickPDFText,
              child: const Text('Pick PDF'),
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: _speakText,
              child: const Text('Read PDF'),
            ),
          ),
        ],
      ),
    );
  }
}
