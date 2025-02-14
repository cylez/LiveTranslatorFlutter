import 'package:flutter_test/flutter_test.dart';
import 'package:live_translator_flutter/translator.dart'; // Falls translate() aus diesem Paket stammt
import 'translator.dart'; // Assuming your translator logic is in translator.dart

void main() {
  // Add your test cases here. Example:
  test('Translator should translate "hello" to "hola"', () {
    expect(translate("hello", "en", "es"), "hola");
  });
  test('Translator should translate "hello" to "bonjour"', () {
    expect(translate("hello", "en", "fr"), "bonjour");
  });
  test('example test', () {
    expect(1 + 1, 2);
  });
}

