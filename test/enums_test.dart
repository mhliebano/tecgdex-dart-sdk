import 'package:test/test.dart';
import 'package:tcgdex_dart_sdk/src/enums/language.dart';
import 'package:tcgdex_dart_sdk/src/enums/image_quality.dart';
import 'package:tcgdex_dart_sdk/src/enums/image_extension.dart';

void main() {
  group('Enums', () {
    test('Language serialization and lookup', () {
      expect(Language.en.code, 'en');
      expect(Language.esMx.code, 'es-mx');
      expect(Language.fromCode('en'), Language.en);
      expect(Language.fromCode('es-mx'), Language.esMx);
      expect(Language.fromCode('ES_MX'), Language.esMx);
      expect(Language.tryFromCode('unknown'), isNull);
      expect(() => Language.fromCode('invalid'), throwsArgumentError);
    });

    test('ImageQuality values', () {
      expect(ImageQuality.high.value, 'high');
      expect(ImageQuality.low.value, 'low');
      expect(Quality.high, ImageQuality.high);
    });

    test('ImageExtension values', () {
      expect(ImageExtension.png.value, 'png');
      expect(ImageExtension.jpg.value, 'jpg');
      expect(ImageExtension.webp.value, 'webp');
    });
  });
}
