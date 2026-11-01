import 'dart:typed_data';
import '../enums/image_extension.dart';
import '../tcgdex.dart';
import 'card_resume.dart';
import 'model.dart';
import 'serie_resume.dart';
import 'subs.dart';

/// Full Pokémon TCG set data model.
class SetModel extends TcgModel {
  final String id;
  final String name;
  final String? logo;
  final String? symbol;
  final SetCardCountResume cardCount;
  final SerieResume? serie;
  final String? tcgOnline;
  final String? releaseDate;
  final Legal? legal;
  final List<CardResume> cards;
  final List<Booster>? boosters;
  final SetAbbreviations? abbreviations;

  SetModel({
    required this.id,
    required this.name,
    this.logo,
    this.symbol,
    required this.cardCount,
    this.serie,
    this.tcgOnline,
    this.releaseDate,
    this.legal,
    required this.cards,
    this.boosters,
    this.abbreviations,
    super.sdk,
  });

  factory SetModel.fromJson(Map<String, dynamic> json, [TcgDex? sdk]) {
    final countJson = json['cardCount'] ?? json['card_count'] ?? <String, dynamic>{};
    final cardsList = (json['cards'] as List<dynamic>?)
            ?.map((e) => CardResume.fromJson(e as Map<String, dynamic>, sdk))
            .toList() ??
        [];
    return SetModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      logo: json['logo'] as String?,
      symbol: json['symbol'] as String?,
      cardCount: SetCardCountResume.fromJson(
        countJson is Map<String, dynamic> ? countJson : <String, dynamic>{},
      ),
      serie: json['serie'] != null && json['serie'] is Map<String, dynamic>
          ? SerieResume.fromJson(json['serie'] as Map<String, dynamic>, sdk)
          : null,
      tcgOnline: (json['tcgOnline'] ?? json['tcg_online']) as String?,
      releaseDate: (json['releaseDate'] ?? json['release_date']) as String?,
      legal: json['legal'] != null && json['legal'] is Map<String, dynamic>
          ? Legal.fromJson(json['legal'] as Map<String, dynamic>)
          : null,
      cards: cardsList,
      boosters: (json['boosters'] as List<dynamic>?)
          ?.map((e) => Booster.fromJson(e as Map<String, dynamic>))
          .toList(),
      abbreviations: json['abbreviations'] != null &&
              json['abbreviations'] is Map<String, dynamic>
          ? SetAbbreviations.fromJson(
              json['abbreviations'] as Map<String, dynamic>,
            )
          : null,
      sdk: sdk,
    );
  }

  @override
  void attachSdk(TcgDex sdk) {
    super.attachSdk(sdk);
    serie?.attachSdk(sdk);
    for (final c in cards) {
      c.attachSdk(sdk);
    }
  }

  /// Computes the full logo URL with the specified [extension].
  String? getLogoUrl([ImageExtension extension = ImageExtension.png]) {
    if (logo == null || logo!.isEmpty) return null;
    return '$logo.${extension.value}';
  }

  /// Downloads the set logo bytes.
  Future<Uint8List?> getLogo([ImageExtension extension = ImageExtension.png]) {
    return downloadBytes(getLogoUrl(extension));
  }

  /// Computes the full symbol URL with the specified [extension].
  String? getSymbolUrl([ImageExtension extension = ImageExtension.png]) {
    if (symbol == null || symbol!.isEmpty) return null;
    return '$symbol.${extension.value}';
  }

  /// Downloads the set symbol bytes.
  Future<Uint8List?> getSymbol([ImageExtension extension = ImageExtension.png]) {
    return downloadBytes(getSymbolUrl(extension));
  }
}

/// Shorthand alias for SetModel.
typedef CardSet = SetModel;
