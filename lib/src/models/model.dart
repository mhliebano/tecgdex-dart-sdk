import 'dart:typed_data';
import '../tcgdex.dart';

/// Base class for all TCGdex data models.
/// Holds an optional reference to the [TcgDex] SDK instance to allow lazy loading
/// of full models and downloading media.
abstract class TcgModel {
  TcgDex? sdk;

  TcgModel({this.sdk});

  /// Injects the SDK instance into this model and any nested models.
  void attachSdk(TcgDex sdk) {
    this.sdk = sdk;
  }

  /// Downloads bytes from the given URL using the SDK's Dio client.
  Future<Uint8List?> downloadBytes(String? url) async {
    if (url == null) return null;
    if (sdk == null) {
      throw StateError(
        'Cannot download media without an attached TcgDex instance.',
      );
    }
    return sdk!.downloadImage(url);
  }
}
