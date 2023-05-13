import 'package:cloud_firestore/cloud_firestore.dart';

class TranslationsManager {
  static final TranslationsManager _instance = TranslationsManager._internal();
  Map<String, dynamic>? translations;

  factory TranslationsManager() {
    return _instance;
  }

  TranslationsManager._internal();

  String getTranslation(String key) {
    if (translations == null) {
      return key;
    }
    var translation = translations?[key];

    return translation ?? key;
  }

  Future<void> init(String locale) async {
    translations = await _getTranslations(locale);
  }

  Future<Map<String, dynamic>> _getTranslations(String locale) async {
    final translationRef =
        FirebaseFirestore.instance.collection('translations');

    var translations = await translationRef.doc(locale).get().then((value) {
      if (value.exists) return value.data()!;
    });

    return translations ?? await _getDefaultTranslations(translationRef);
  }

  Future<Map<String, dynamic>> _getDefaultTranslations(
          CollectionReference<Map<String, dynamic>> translationRef) async =>
      await translationRef.doc('en-US').get().then((value) => value.data()!);
}
