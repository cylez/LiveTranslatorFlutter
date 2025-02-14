import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';

void main() {
  runApp(LiveTranslatorApp());
}

class LiveTranslatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TranslatorScreen(),
    );
  }
}

class TranslatorScreen extends StatefulWidget {
  @override
  _TranslatorScreenState createState() => _TranslatorScreenState();
}

class _TranslatorScreenState extends State<TranslatorScreen> {
  ScreenshotController screenshotController = ScreenshotController();
  String translatedText = "Hier erscheint die Übersetzung...";

  Future<void> takeScreenshotAndTranslate() async {
    screenshotController.capture().then((Uint8List? image) async {
      if (image != null) {
        String detectedText = await extractTextFromImage(image);
        String translation = await translateText(detectedText);
        setState(() {
          translatedText = translation;
        });
      }
    });
  }

  Future<String> extractTextFromImage(Uint8List image) async {
    final textRecognizer = GoogleMlKit.vision.textRecognizer();
    final InputImage inputImage = InputImage.fromBytes(
      bytes: image,
      inputImageData: InputImageData(
        size: Size(1080, 1920),
        imageRotation: InputImageRotation.rotation0deg,
        inputImageFormat: InputImageFormat.nv21,
        planeData: [],
      ),
    );
    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
    textRecognizer.close();
    return recognizedText.text;
  }

  Future<String> translateText(String text) async {
    String apiKey = "DEIN_DEEPL_API_KEY";
    String url = "https://api-free.deepl.com/v2/translate?text=$text&target_lang=DE";
    
    final response = await http.get(Uri.parse(url), headers: {
      "Authorization": "DeepL-Auth-Key $apiKey"
    });

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data["translations"][0]["text"];
    } else {
      return "Fehler bei der Übersetzung";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Live Translator")),
      floatingActionButton: FloatingActionButton(
        onPressed: takeScreenshotAndTranslate,
        child: Icon(Icons.translate),
      ),
      body: Center(
        child: Text(translatedText, style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
