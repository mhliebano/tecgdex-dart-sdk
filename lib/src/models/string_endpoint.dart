import '../tcgdex.dart';
import 'card_resume.dart';
import 'model.dart';

/// Generic model for categorization endpoints (illustrators, types, rarities, etc.)
/// which return an identifier/name and the list of associated [CardResume].
class EndpointCards<T> extends TcgModel {
  final T name;
  final List<CardResume> cards;

  EndpointCards({
    required this.name,
    required this.cards,
    super.sdk,
  });

  factory EndpointCards.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) parseName, [
    TcgDex? sdk,
  ]) {
    final rawName = json['name'];
    final parsed = parseName(rawName);
    final cardsList = (json['cards'] as List<dynamic>?)
            ?.map((e) => CardResume.fromJson(e as Map<String, dynamic>, sdk))
            .toList() ??
        [];
    return EndpointCards<T>(
      name: parsed,
      cards: cardsList,
      sdk: sdk,
    );
  }

  @override
  void attachSdk(TcgDex sdk) {
    super.attachSdk(sdk);
    for (final c in cards) {
      c.attachSdk(sdk);
    }
  }
}

/// Category endpoint response whose name is a [String] (e.g. types, illustrators).
class StringEndpoint extends EndpointCards<String> {
  StringEndpoint({
    required super.name,
    required super.cards,
    super.sdk,
  });

  factory StringEndpoint.fromJson(Map<String, dynamic> json, [TcgDex? sdk]) {
    final base = EndpointCards<String>.fromJson(
      json,
      (v) => v?.toString() ?? '',
      sdk,
    );
    return StringEndpoint(name: base.name, cards: base.cards, sdk: sdk);
  }
}

/// Category endpoint response whose name is an [int] (e.g. dex-ids, hp, retreats).
class IntEndpoint extends EndpointCards<int> {
  IntEndpoint({
    required super.name,
    required super.cards,
    super.sdk,
  });

  factory IntEndpoint.fromJson(Map<String, dynamic> json, [TcgDex? sdk]) {
    final base = EndpointCards<int>.fromJson(
      json,
      (v) => (v as num?)?.toInt() ?? 0,
      sdk,
    );
    return IntEndpoint(name: base.name, cards: base.cards, sdk: sdk);
  }
}
