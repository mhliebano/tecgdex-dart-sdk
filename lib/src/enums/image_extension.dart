/// Supported image formats / extensions.
enum ImageExtension {
  png('png'),
  jpg('jpg'),
  webp('webp');

  final String value;
  const ImageExtension(this.value);

  @override
  String toString() => value;
}
