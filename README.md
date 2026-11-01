# TCGdex Dart SDK

A fast, type-safe Dart SDK for the [TCGdex API](https://www.tcgdex.net) powered by [Dio](https://pub.dev/packages/dio). Easily query Pokémon Trading Card Game data in Dart & Flutter applications. 🚀

## ⚡️ Installation

Add `tcgdex_dart_sdk` to your `pubspec.yaml`:

```yaml
dependencies:
  tcgdex_dart_sdk:
    path: ../tcgdex_dart_sdk # or git / pub.dev
```

Or via command line:

```bash
dart pub add tcgdex_dart_sdk
```

## 🚀 Features

- **Type-Safe**: Full typing support for cards, sets, series, variants, abilities, legalities, and filters.
- **Powered by Dio**: Robust HTTP networking with support for timeouts, custom interceptors, and binary downloading.
- **Direct Image Download**: Retrieve image bytes (`Uint8List`) for cards, logos, and symbols directly through the SDK models.
- **Fluent Query Builder**: Easy filtering, sorting, and pagination.
- **Multi-Language**: Support for English, French, Spanish, German, Japanese, and [more](https://tcgdex.dev).
- **Navigation Shortcuts**: Lazy-load full models directly from resume objects (`cardResume.getFullCard()`, `setResume.getFullSet()`).

---

## 🎯 Quick Examples

### Initialize SDK

```dart
import 'package:tcgdex_dart_sdk/tcgdex_dart_sdk.dart';

final tcgdex = TcgDex(Language.en);

// Or with string language code:
final tcgdexEs = TcgDex('es');

// Change language at runtime:
tcgdex.setLanguage(Language.fr);
```

### Fetch a Card by ID

```dart
final card = await tcgdex.card.get('swsh3-136');
if (card != null) {
  print('Found: ${card.name} (${card.localId}/${card.set?.cardCount.total})');
  print('High-res Image: ${card.getImageUrl(quality: ImageQuality.high)}');
  
  // Download bytes directly:
  final Uint8List? imageBytes = await card.getImage();
}
```

### Search and Filter Cards (Query Builder)

```dart
// Find cards named Furret
final cards = await tcgdex.card.list(
  Query().equal('name', 'Furret'),
);

// Advanced filters with pagination & sorting
final query = Query()
    .gte('hp', 100)
    .sort('name', 'ASC')
    .paginate(1, 20);

final results = await tcgdex.card.list(query);

// Lazy-load the full card from a resume item:
final fullCard = await results.first.getFullCard();
```

### Sets and Series

```dart
// Fetch Set details
final set = await tcgdex.set.get('swsh1');
if (set != null) {
  print('Set: ${set.name} (${set.cards.length} cards)');
  print('Logo URL: ${set.getLogoUrl(ImageExtension.png)}');
}

// Fetch Series details
final serie = await tcgdex.serie.get('swsh');
if (serie != null) {
  print('Serie: ${serie.name} with ${serie.sets.length} sets');
}
```

### Categorization Endpoints

```dart
// Pokémon types
final types = await tcgdex.type.list();
final grassCards = await tcgdex.type.get('Grass');

// Illustrators
final illustrators = await tcgdex.illustrator.list();
final artistCards = await tcgdex.illustrator.get('5ban Graphics');

// Pokédex IDs
final dexIds = await tcgdex.dexId.list();
final bulbasaurCards = await tcgdex.dexId.get(1);

// HP and Retreat
final hpValues = await tcgdex.hp.list();
final retreats = await tcgdex.retreat.list();
```

---

## 🛠 Available Endpoints

| Endpoint | Type | Description |
|---|---|---|
| `tcgdex.card` | `Endpoint<Card, CardResume>` | Card information |
| `tcgdex.set` | `Endpoint<SetModel, SetResume>` | Set collections |
| `tcgdex.serie` | `Endpoint<Serie, SerieResume>` | Series collections |
| `tcgdex.type` | `Endpoint<StringEndpoint, String>` | Pokémon energy & types |
| `tcgdex.rarity` | `Endpoint<StringEndpoint, String>` | Card rarities |
| `tcgdex.illustrator` | `Endpoint<StringEndpoint, String>` | Illustrators / Artists |
| `tcgdex.hp` | `Endpoint<StringEndpoint, int>` | HP values |
| `tcgdex.retreat` | `Endpoint<StringEndpoint, int>` | Retreat costs |
| `tcgdex.dexId` | `Endpoint<StringEndpoint, int>` | National Pokédex IDs |
| `tcgdex.category` | `Endpoint<StringEndpoint, String>` | Categories (Pokemon, Trainer, Energy) |
| `tcgdex.stage` | `Endpoint<StringEndpoint, String>` | Evolution stages |
| `tcgdex.suffix` | `Endpoint<StringEndpoint, String>` | Card suffixes |
| `tcgdex.variant` | `Endpoint<StringEndpoint, String>` | Card variants |
| `tcgdex.regulationMark` | `Endpoint<StringEndpoint, String>` | Regulation marks |
| `tcgdex.energyType` | `Endpoint<StringEndpoint, String>` | Energy types |
| `tcgdex.trainerType` | `Endpoint<StringEndpoint, String>` | Trainer card types |

---

## ⚙️ Custom Dio Configuration

You can supply your own configured `Dio` instance (with custom interceptors, logging, or caching):

```dart
final customDio = Dio(
  BaseOptions(
    connectTimeout: Duration(seconds: 30),
  ),
);

customDio.interceptors.add(LogInterceptor());

final tcgdex = TcgDex(Language.en, customDio);
```

---

## 📜 License

MIT © [TCGdex](https://github.com/tcgdex)
