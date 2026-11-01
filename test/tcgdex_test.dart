import 'package:test/test.dart';
import 'package:tcgdex_dart_sdk/tcgdex_dart_sdk.dart';

void main() {
  group('TCGdex SDK Integration & Functionality Tests', () {
    late TcgDex api;

    setUp(() {
      api = TcgDex(Language.en);
    });

    test('Endpoint and Language Configuration', () {
      expect(api.getEndpoint(), 'https://api.tcgdex.net/v2');
      expect(api.language, Language.en);

      api.setEndpoint('https://custom.endpoint.com');
      expect(api.getEndpoint(), 'https://custom.endpoint.com');

      api.setLanguage(Language.es);
      expect(api.language, Language.es);

      api.setLanguage('fr');
      expect(api.language, Language.fr);
    });

    test('Fetch Card Details and Helpers', () async {
      final tcg = TcgDex(Language.en);
      final card = await tcg.card.get('swsh3-136');
      expect(card, isNotNull);
      expect(card!.id, 'swsh3-136');
      expect(card.name, 'Furret');
      expect(card.rarity, isNotNull);
      expect(card.variants, isNotNull);
      expect(card.set, isNotNull);

      // Test image URL generator
      final highPng = card.getImageUrl(
        quality: ImageQuality.high,
        extension: ImageExtension.png,
      );
      expect(highPng, contains('/high.png'));

      // Test image downloading
      final bytes = await card.getImage(quality: ImageQuality.low, extension: ImageExtension.webp);
      expect(bytes, isNotNull);
      expect(bytes!, isNotEmpty);
    });

    test('Multi-language card fetch', () async {
      final frSdk = TcgDex(Language.fr);
      final res = await frSdk.card.get('swsh3-136');
      expect(res, isNotNull);
      expect(res!.name, 'Fouinar');

      final esSdk = TcgDex('es');
      final esRes = await esSdk.card.get('swsh3-136');
      expect(esRes, isNotNull);
      expect(esRes!.name, 'Furret');
    });

    test('Card list with Query filter', () async {
      final tcg = TcgDex(Language.en);
      final list = await tcg.card.list(Query().equal('name', 'Furret'));
      expect(list, isNotEmpty);
      for (final card in list) {
        expect(card.name, 'Furret');
      }
    });

    test('CardResume getFullCard navigation', () async {
      final tcg = TcgDex(Language.en);
      final list = await tcg.card.list(Query().equal('name', 'Furret'));
      expect(list, isNotEmpty);
      final resume = list.first;
      final fullCard = await resume.getFullCard();
      expect(fullCard, isNotNull);
      expect(fullCard!.id, resume.id);
      expect(fullCard.name, resume.name);
    });

    test('Set details and SetResume navigation', () async {
      final tcg = TcgDex(Language.en);
      final set = await tcg.set.get('swsh1');
      expect(set, isNotNull);
      expect(set!.name, contains('Sword & Shield'));
      expect(set.cards, isNotEmpty);
      expect(set.getLogoUrl(ImageExtension.png), isNotNull);
      expect(set.getSymbolUrl(ImageExtension.png), isNotNull);

      final firstCard = set.cards.first;
      final fullCard = await firstCard.getFullCard();
      expect(fullCard, isNotNull);
    });

    test('Series details and SerieResume navigation', () async {
      final tcg = TcgDex(Language.en);
      final seriesList = await tcg.serie.list();
      expect(seriesList, isNotEmpty);

      final swsh = await tcg.serie.get('swsh');
      expect(swsh, isNotNull);
      expect(swsh!.sets, isNotEmpty);
      expect(swsh.getLogoUrl(ImageExtension.png), isNotNull);

      final serieResume = seriesList.firstWhere((s) => s.id == 'swsh');
      final fullSerie = await serieResume.getFullSerie();
      expect(fullSerie, isNotNull);
      expect(fullSerie!.id, 'swsh');
    });

    test('Categorization endpoints (types, dexId, illustrator)', () async {
      final tcg = TcgDex(Language.en);

      // Types list and get
      final types = await tcg.type.list();
      expect(types, isNotEmpty);
      final typeItem = await tcg.type.get('grass');
      expect(typeItem, isNotNull);
      expect(typeItem!.name.toLowerCase(), 'grass');

      // DexId list and get
      final dexIds = await tcg.dexId.list();
      expect(dexIds, isNotEmpty);
      expect(dexIds.first, isA<int>());
      final dex1 = await tcg.dexId.get(1);
      expect(dex1, isNotNull);
      expect(dex1!.cards, isNotEmpty);

      // Illustrator list and get
      final illustrators = await tcg.illustrator.list();
      expect(illustrators, isNotEmpty);
    });

    test('Returns null on non-existing resource (404)', () async {
      final tcg = TcgDex(Language.en);
      final nonExistent = await tcg.card.get('non-existing-card-id-12345');
      expect(nonExistent, isNull);
    });
  });
}
