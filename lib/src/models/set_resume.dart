import 'dart:typed_data';
import '../enums/image_extension.dart';
import '../tcgdex.dart';
import 'model.dart';
import 'set.dart';
import 'subs.dart';

/// Lightweight summary of a Pokémon TCG set.
class SetResume extends TcgModel {
  final String id;
  final String name;
  final String? logo;
  final String? symbol;
  final SetCardCountResume cardCount;

  SetResume({
    required this.id,
    required this.name,
    this.logo,
    this.symbol,
    required this.cardCount,
    super.sdk,
  });

  factory SetResume.fromJson(Map<String, dynamic> json, [TcgDex? sdk]) {
    final countJson = json['cardCount'] ?? json['card_count'] ?? <String, dynamic>{};
    return SetResume(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      logo: json['logo'] as String?,
      symbol: json['symbol'] as String?,
      cardCount: SetCardCountResume.fromJson(
        countJson is Map<String, dynamic> ? countJson : <String, dynamic>{},
      ),
      sdk: sdk,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    if (logo != null) 'logo': logo,
    if (symbol != null) 'symbol': symbol,
    'cardCount': cardCount.toJson(),
  };

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

  /// Fetches the full detailed [SetModel] from the active SDK.
  Future<SetModel?> getFullSet() async {
    if (sdk == null) {
      throw StateError('Cannot fetch full set without an attached TcgDex instance.');
    }
    return sdk!.set.get(id);
  }
}
