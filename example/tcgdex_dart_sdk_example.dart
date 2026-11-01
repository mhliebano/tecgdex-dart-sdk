import 'package:tcgdex_dart_sdk/tcgdex_dart_sdk.dart';

void main() async {
  final tcgdex = TcgDex(Language.en);

  print('--- Fetching Card swsh4.5-17 ---');
  final card = await tcgdex.card.get('swsh4.5-17');
  if (card != null) {
    print('Found: ${card.name} (${card.localId}/${card.set?.cardCount.total})');
    print('Rarity: ${card.rarity}');
    print('Image URL: ${card.getImageUrl(quality: ImageQuality.high)}');
  }

  print('\n--- Listing cards with name "Reshiram" ---');
  final reshiramCards = await tcgdex.card.list(
    Query().equal('name', 'Reshiram'),
  );
  for (final c in reshiramCards) {
    print('- [${c.id}] ${c.name} (#${c.localId})');
  }

  print('\n--- Fetching Set "swsh1" ---');
  final set = await tcgdex.set.get('swsh1');
  if (set != null) {
    print('Set: ${set.name} (${set.cardCount.total} cards)');
    print('Symbol URL: ${set.getSymbolUrl(ImageExtension.png)}');
  }

  print('\n--- Changing language to Spanish and fetching card ---');
  tcgdex.setLanguage(Language.es);
  final spanishCard = await tcgdex.card.get('swsh4.5-17');
  if (spanishCard != null) {
    print('Nombre en español: ${spanishCard.name}');
  }
}
