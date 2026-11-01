import 'dart:typed_data';
import '../enums/image_extension.dart';
import '../tcgdex.dart';
import 'model.dart';
import 'serie.dart';

/// Lightweight summary of a Pokémon TCG series.
class SerieResume extends TcgModel {
  final String id;
  final String name;
  final String? logo;

  SerieResume({
    required this.id,
    required this.name,
    this.logo,
    super.sdk,
  });

  factory SerieResume.fromJson(Map<String, dynamic> json, [TcgDex? sdk]) {
    return SerieResume(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      logo: json['logo'] as String?,
      sdk: sdk,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    if (logo != null) 'logo': logo,
  };

  /// Computes the full logo URL with the specified [extension].
  String? getLogoUrl([ImageExtension extension = ImageExtension.png]) {
    if (logo == null || logo!.isEmpty) return null;
    return '$logo.${extension.value}';
  }

  /// Downloads the series logo bytes.
  Future<Uint8List?> getLogo([ImageExtension extension = ImageExtension.png]) {
    return downloadBytes(getLogoUrl(extension));
  }

  /// Fetches the full detailed [Serie] model from the active SDK.
  Future<Serie?> getFullSerie() async {
    if (sdk == null) {
      throw StateError('Cannot fetch full serie without an attached TcgDex instance.');
    }
    return sdk!.serie.get(id);
  }
}
