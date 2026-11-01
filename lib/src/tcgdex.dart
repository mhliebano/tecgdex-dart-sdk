import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'endpoints/endpoint.dart';
import 'enums/language.dart';
import 'models/card.dart';
import 'models/card_resume.dart';
import 'models/serie.dart';
import 'models/serie_resume.dart';
import 'models/set.dart';
import 'models/set_resume.dart';
import 'models/string_endpoint.dart';

/// Main TCGdex SDK entrypoint.
class TcgDex {
  String _endpoint = 'https://api.tcgdex.net/v2';
  Language _language;
  final Dio dio;

  // Complex resource endpoints
  late final Endpoint<Card, CardResume> card;
  late final Endpoint<SetModel, SetResume> set;
  late final Endpoint<Serie, SerieResume> serie;

  // Categorization endpoints (Strings)
  late final Endpoint<StringEndpoint, String> variant;
  late final Endpoint<StringEndpoint, String> trainerType;
  late final Endpoint<StringEndpoint, String> suffix;
  late final Endpoint<StringEndpoint, String> stage;
  late final Endpoint<StringEndpoint, String> regulationMark;
  late final Endpoint<StringEndpoint, String> energyType;
  late final Endpoint<StringEndpoint, String> type;
  late final Endpoint<StringEndpoint, String> rarity;
  late final Endpoint<StringEndpoint, String> illustrator;
  late final Endpoint<StringEndpoint, String> category;

  // Categorization endpoints (Integers)
  late final Endpoint<StringEndpoint, int> dexId;
  late final Endpoint<StringEndpoint, int> retreat;
  late final Endpoint<StringEndpoint, int> hp;

  TcgDex([
    dynamic language = Language.en,
    Dio? customDio,
    String? customEndpoint,
  ])  : _language = _parseLanguage(language),
        dio = customDio ??
            Dio(
              BaseOptions(
                headers: const {
                  'User-Agent': '@tcgdex/dart-sdk@1.0.0',
                },
                connectTimeout: const Duration(seconds: 15),
                receiveTimeout: const Duration(seconds: 15),
              ),
            ) {
    if (customEndpoint != null && customEndpoint.isNotEmpty) {
      _endpoint = customEndpoint;
    }
    _initEndpoints();
  }

  static Language _parseLanguage(dynamic lang) {
    if (lang is Language) return lang;
    if (lang is String) {
      return Language.tryFromCode(lang) ?? Language.en;
    }
    return Language.en;
  }

  void _initEndpoints() {
    card = Endpoint<Card, CardResume>(
      sdk: this,
      path: 'cards',
      itemParser: (json, [sdk]) => Card.fromJson(json, sdk),
      listParser: (json, [sdk]) =>
          CardResume.fromJson(json as Map<String, dynamic>, sdk),
    );

    set = Endpoint<SetModel, SetResume>(
      sdk: this,
      path: 'sets',
      itemParser: (json, [sdk]) => SetModel.fromJson(json, sdk),
      listParser: (json, [sdk]) =>
          SetResume.fromJson(json as Map<String, dynamic>, sdk),
    );

    serie = Endpoint<Serie, SerieResume>(
      sdk: this,
      path: 'series',
      itemParser: (json, [sdk]) => Serie.fromJson(json, sdk),
      listParser: (json, [sdk]) =>
          SerieResume.fromJson(json as Map<String, dynamic>, sdk),
    );

    // String endpoints
    variant = _createStringEndpoint('variants');
    trainerType = _createStringEndpoint('trainer-types');
    suffix = _createStringEndpoint('suffixes');
    stage = _createStringEndpoint('stages');
    regulationMark = _createStringEndpoint('regulation-marks');
    energyType = _createStringEndpoint('energy-types');
    type = _createStringEndpoint('types');
    rarity = _createStringEndpoint('rarities');
    illustrator = _createStringEndpoint('illustrators');
    category = _createStringEndpoint('categories');

    // Integer endpoints
    dexId = _createIntListEndpoint('dex-ids');
    retreat = _createIntListEndpoint('retreats');
    hp = _createIntListEndpoint('hp');
  }

  Endpoint<StringEndpoint, String> _createStringEndpoint(String path) {
    return Endpoint<StringEndpoint, String>(
      sdk: this,
      path: path,
      itemParser: (json, [sdk]) => StringEndpoint.fromJson(json, sdk),
      listParser: (raw, [sdk]) => raw.toString(),
    );
  }

  Endpoint<StringEndpoint, int> _createIntListEndpoint(String path) {
    return Endpoint<StringEndpoint, int>(
      sdk: this,
      path: path,
      itemParser: (json, [sdk]) => StringEndpoint.fromJson(json, sdk),
      listParser: (raw, [sdk]) => (raw as num).toInt(),
    );
  }

  /// Base API endpoint URL.
  String getEndpoint() => _endpoint;

  /// Sets a new base API endpoint URL.
  TcgDex setEndpoint(String endpoint) {
    _endpoint = endpoint;
    return this;
  }

  /// Base endpoint URL getter / setter for compatibility with Python SDK.
  String get endpoint => _endpoint;
  set endpoint(String value) => setEndpoint(value);

  /// Current active language.
  Language get language => _language;

  /// Current active language getter for compatibility.
  Language getLanguage() => _language;

  /// Updates the active language (accepts [Language] or [String] code like 'en', 'es').
  TcgDex setLanguage(dynamic language) {
    _language = _parseLanguage(language);
    return this;
  }

  /// Downloads an image as raw bytes ([Uint8List]) using the configured [dio] client.
  Future<Uint8List> downloadImage(String url) async {
    final response = await dio.get<List<int>>(
      url,
      options: Options(responseType: ResponseType.bytes),
    );
    return Uint8List.fromList(response.data!);
  }
}
