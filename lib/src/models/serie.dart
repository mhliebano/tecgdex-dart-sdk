import 'dart:typed_data';
import '../enums/image_extension.dart';
import '../tcgdex.dart';
import 'model.dart';
import 'set_resume.dart';

/// Full Pokémon TCG series model containing its sets.
class Serie extends TcgModel {
  final String id;
  final String name;
  final String? logo;
  final List<SetResume> sets;

  Serie({
    required this.id,
    required this.name,
    this.logo,
    required this.sets,
    super.sdk,
  });

  factory Serie.fromJson(Map<String, dynamic> json, [TcgDex? sdk]) {
    final setsList = (json['sets'] as List<dynamic>?)
            ?.map((e) => SetResume.fromJson(e as Map<String, dynamic>, sdk))
            .toList() ??
        [];
    return Serie(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      logo: json['logo'] as String?,
      sets: setsList,
      sdk: sdk,
    );
  }

  @override
  void attachSdk(TcgDex sdk) {
    super.attachSdk(sdk);
    for (final s in sets) {
      s.attachSdk(sdk);
    }
  }

  /// Computes the full logo URL with the specified [extension].
  String? getLogoUrl([ImageExtension extension = ImageExtension.png]) {
    if (logo == null || logo!.isEmpty) return null;
    return '$logo.${extension.value}';
  }

  /// Downloads the series logo bytes.
  Future<Uint8List?> getLogo([ImageExtension extension = ImageExtension.png]) {
    return downloadBytes(getLogoUrl(extension));
  }
}
