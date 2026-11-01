/// Available languages in TCGdex.
enum Language {
  en('en'),
  fr('fr'),
  es('es'),
  esMx('es-mx'),
  it('it'),
  ptBr('pt-br'),
  ptPt('pt-pt'),
  de('de'),
  nl('nl'),
  pl('pl'),
  ru('ru'),
  ja('ja'),
  ko('ko'),
  zhTw('zh-tw'),
  id('id'),
  th('th'),
  zhCn('zh-cn');

  final String code;
  const Language(this.code);

  /// Find a [Language] from its string code.
  static Language? tryFromCode(String code) {
    final normalized = code.toLowerCase().replaceAll('_', '-');
    for (final lang in Language.values) {
      if (lang.code == normalized) {
        return lang;
      }
    }
    return null;
  }

  /// Find a [Language] from its string code or throw [ArgumentError].
  static Language fromCode(String code) {
    final lang = tryFromCode(code);
    if (lang == null) {
      throw ArgumentError('Unsupported language code: $code');
    }
    return lang;
  }

  @override
  String toString() => code;
}
