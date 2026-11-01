/// Image quality selector for card images.
enum ImageQuality {
  high('high'),
  low('low');

  final String value;
  const ImageQuality(this.value);

  @override
  String toString() => value;
}

/// Shorthand alias for ImageQuality.
typedef Quality = ImageQuality;
