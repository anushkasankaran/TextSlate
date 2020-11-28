import 'dart:convert';
import 'package:html_unescape/html_unescape.dart';
import 'package:http/http.dart' as http;
import 'package:translator/translator.dart';

///Code created by following tutorial: https://www.youtube.com/watch?v=N_UI1Wps7bI
///Uses Cloud Translate API to translate
class TranslationApi {
  static final _apiKey = 'AIzaSyA6DBt5i7BvkGpLA8DJDopHt5ZaNJzqN44';

  static Future<String> translate(String message, String toLanguageCode) async {
    final response = await http.post(
      'https://translation.googleapis.com/language/translate/v2?target=$toLanguageCode&key=$_apiKey&q=$message',
    );

    if (response.statusCode == 200) {                               //successful case
      final body = json.decode(response.body);
      final translations = body['data']['translations'] as List;
      final translation = translations.first;

      return HtmlUnescape().convert(translation['translatedText']);
    } else {                                                        //exception for unsuccessful case
      throw Exception();
    }
  }

  static Future<String> translate2(
      String message, String fromLanguageCode, String toLanguageCode) async {
    final translation = await GoogleTranslator().translate(
      message,
      from: fromLanguageCode,
      to: toLanguageCode,
    );

    return translation.text;
  }
}
