import 'dart:typed_data';
import '../enums/image_extension.dart';
import '../enums/image_quality.dart';
import '../tcgdex.dart';
import 'model.dart';
import 'set_resume.dart';
import 'subs.dart';

/// Full Pokémon TCG card data model.
class Card extends TcgModel {
  final String id;
  final String localId;
  final String name;
  final String? image;
  final String? category;
  final String? illustrator;
  final String? rarity;
  final CardVariants? variants;
  final SetResume? set;
  final List<int>? dexId;
  final int? hp;
  final List<String>? types;
  final String? evolveFrom;
  final String? description;
  final String? level;
  final String? stage;
  final String? suffix;
  final CardItem? item;
  final List<CardAbility>? abilities;
  final List<CardAttack>? attacks;
  final List<CardWeakRes>? weaknesses;
  final List<CardWeakRes>? resistances;
  final int? retreat;
  final String? effect;
  final String? trainerType;
  final String? energyType;
  final String? regulationMark;
  final Legal? legal;
  final List<Booster>? boosters;

  Card({
    required this.id,
    required this.localId,
    required this.name,
    this.image,
    this.category,
    this.illustrator,
    this.rarity,
    this.variants,
    this.set,
    this.dexId,
    this.hp,
    this.types,
    this.evolveFrom,
    this.description,
    this.level,
    this.stage,
    this.suffix,
    this.item,
    this.abilities,
    this.attacks,
    this.weaknesses,
    this.resistances,
    this.retreat,
    this.effect,
    this.trainerType,
    this.energyType,
    this.regulationMark,
    this.legal,
    this.boosters,
    super.sdk,
  });

  factory Card.fromJson(Map<String, dynamic> json, [TcgDex? sdk]) {
    final card = Card(
      id: json['id'] as String? ?? '',
      localId: (json['localId'] ?? json['local_id'] ?? '').toString(),
      name: json['name'] as String? ?? '',
      image: json['image'] as String?,
      category: json['category'] as String?,
      illustrator: json['illustrator'] as String?,
      rarity: json['rarity'] as String?,
      variants: json['variants'] != null && json['variants'] is Map<String, dynamic>
          ? CardVariants.fromJson(json['variants'] as Map<String, dynamic>)
          : null,
      set: json['set'] != null && json['set'] is Map<String, dynamic>
          ? SetResume.fromJson(json['set'] as Map<String, dynamic>, sdk)
          : null,
      dexId: (json['dexId'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      hp: (json['hp'] as num?)?.toInt(),
      types: (json['types'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      evolveFrom: json['evolveFrom'] as String?,
      description: json['description'] as String?,
      level: json['level']?.toString(),
      stage: json['stage'] as String?,
      suffix: json['suffix'] as String?,
      item: json['item'] != null && json['item'] is Map<String, dynamic>
          ? CardItem.fromJson(json['item'] as Map<String, dynamic>)
          : null,
      abilities: (json['abilities'] as List<dynamic>?)
          ?.map((e) => CardAbility.fromJson(e as Map<String, dynamic>))
          .toList(),
      attacks: (json['attacks'] as List<dynamic>?)
          ?.map((e) => CardAttack.fromJson(e as Map<String, dynamic>))
          .toList(),
      weaknesses: (json['weaknesses'] as List<dynamic>?)
          ?.map((e) => CardWeakRes.fromJson(e as Map<String, dynamic>))
          .toList(),
      resistances: (json['resistances'] as List<dynamic>?)
          ?.map((e) => CardWeakRes.fromJson(e as Map<String, dynamic>))
          .toList(),
      retreat: (json['retreat'] as num?)?.toInt(),
      effect: json['effect'] as String?,
      trainerType: (json['trainerType'] ?? json['trainer_type']) as String?,
      energyType: (json['energyType'] ?? json['energy_type']) as String?,
      regulationMark: (json['regulationMark'] ?? json['regulation_mark']) as String?,
      legal: json['legal'] != null && json['legal'] is Map<String, dynamic>
          ? Legal.fromJson(json['legal'] as Map<String, dynamic>)
          : null,
      boosters: (json['boosters'] as List<dynamic>?)
          ?.map((e) => Booster.fromJson(e as Map<String, dynamic>))
          .toList(),
      sdk: sdk,
    );
    return card;
  }

  @override
  void attachSdk(TcgDex sdk) {
    super.attachSdk(sdk);
    set?.attachSdk(sdk);
  }

  /// Computes the full image URL with the specified [quality] and [extension].
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
}
