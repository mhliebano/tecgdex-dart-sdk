import 'dart:typed_data';
import '../enums/image_extension.dart';
import '../enums/image_quality.dart';
import '../tcgdex.dart';
import 'card.dart';
import 'model.dart';

/// Lightweight summary of a Pokémon TCG card.
class CardResume extends TcgModel {
  /// Globally unique card ID based on set ID and card number.
  final String id;

  /// Indexing ID within its set (usually its card number).
  final String localId;

  /// Card name.
  final String name;

  /// Card image base URL (without quality or extension).
  final String? image;

  CardResume({
    required this.id,
    required this.localId,
    required this.name,
    this.image,
    super.sdk,
  });

  factory CardResume.fromJson(Map<String, dynamic> json, [TcgDex? sdk]) {
    final resume = CardResume(
      id: json['id'] as String? ?? '',
      localId: (json['localId'] ?? json['local_id'] ?? '').toString(),
      name: json['name'] as String? ?? '',
      image: json['image'] as String?,
      sdk: sdk,
    );
    return resume;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'localId': localId,
    'name': name,
    if (image != null) 'image': image,
  };

  /// Computes the full image URL with the desired [quality] and [extension].
  String? getImageUrl({
    ImageQuality quality = ImageQuality.high,
    ImageExtension extension = ImageExtension.png,
  }) {
    if (image == null || image!.isEmpty) return null;
    return '$image/${quality.value}.${extension.value}';
  }

  /// Downloads the card image bytes with the specified [quality] and [extension].
  Future<Uint8List?> getImage({
    ImageQuality quality = ImageQuality.high,
    ImageExtension extension = ImageExtension.png,
  }) {
    final url = getImageUrl(quality: quality, extension: extension);
    return downloadBytes(url);
  }

  /// Fetches the full detailed [Card] model using the active SDK instance.
  Future<Card?> getFullCard() async {
    if (sdk == null) {
      throw StateError('Cannot fetch full card without an attached TcgDex instance.');
    }
    return sdk!.card.get(id);
  }
}
