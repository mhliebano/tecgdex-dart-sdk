/// Describes a single ability of a Pokémon.
class CardAbility {
  final String type;
  final String? name;
  final String? effect;

  CardAbility({
    required this.type,
    this.name,
    this.effect,
  });

  factory CardAbility.fromJson(Map<String, dynamic> json) {
    return CardAbility(
      type: json['type'] as String? ?? '',
      name: json['name'] as String?,
      effect: json['effect'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'type': type,
    if (name != null) 'name': name,
    if (effect != null) 'effect': effect,
  };
}

/// Describes a single attack of a Pokémon.
class CardAttack {
  final String? name;
  final List<String>? cost;
  final String? effect;
  final dynamic damage;

  CardAttack({
    this.name,
    this.cost,
    this.effect,
    this.damage,
  });

  factory CardAttack.fromJson(Map<String, dynamic> json) {
    return CardAttack(
      name: json['name'] as String?,
      cost: (json['cost'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
      effect: json['effect'] as String?,
      damage: json['damage'],
    );
  }

  Map<String, dynamic> toJson() => {
    if (name != null) 'name': name,
    if (cost != null) 'cost': cost,
    if (effect != null) 'effect': effect,
    if (damage != null) 'damage': damage,
  };
}

/// Card Item held by a Pokémon.
class CardItem {
  final String? name;
  final String? effect;

  CardItem({this.name, this.effect});

  factory CardItem.fromJson(Map<String, dynamic> json) {
    return CardItem(
      name: json['name'] as String?,
      effect: json['effect'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    if (name != null) 'name': name,
    if (effect != null) 'effect': effect,
  };
}

/// Card variant availability (foil, holo, etc.).
class CardVariants {
  final bool normal;
  final bool reverse;
  final bool holo;
  final bool firstEdition;
  final bool wPromo;

  CardVariants({
    required this.normal,
    required this.reverse,
    required this.holo,
    required this.firstEdition,
    required this.wPromo,
  });

  factory CardVariants.fromJson(Map<String, dynamic> json) {
    return CardVariants(
      normal: json['normal'] as bool? ?? false,
      reverse: json['reverse'] as bool? ?? false,
      holo: json['holo'] as bool? ?? false,
      firstEdition: json['firstEdition'] as bool? ?? false,
      wPromo: json['wPromo'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'normal': normal,
    'reverse': reverse,
    'holo': holo,
    'firstEdition': firstEdition,
    'wPromo': wPromo,
  };
}

/// Describes weaknesses or resistances of a Pokémon.
class CardWeakRes {
  final String type;
  final String? value;

  CardWeakRes({required this.type, this.value});

  factory CardWeakRes.fromJson(Map<String, dynamic> json) {
    return CardWeakRes(
      type: json['type'] as String? ?? '',
      value: json['value']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'type': type,
    if (value != null) 'value': value,
  };
}

/// Tournament legality for a card or set.
class Legal {
  final bool standard;
  final bool expanded;

  Legal({required this.standard, required this.expanded});

  factory Legal.fromJson(Map<String, dynamic> json) {
    return Legal(
      standard: json['standard'] as bool? ?? false,
      expanded: json['expanded'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'standard': standard,
    'expanded': expanded,
  };
}

/// Set card counts detailed.
class SetCardCount {
  final int total;
  final int official;
  final int? normal;
  final int? reverse;
  final int? holo;
  final int? firstEd;

  SetCardCount({
    required this.total,
    required this.official,
    this.normal,
    this.reverse,
    this.holo,
    this.firstEd,
  });

  factory SetCardCount.fromJson(Map<String, dynamic> json) {
    return SetCardCount(
      total: (json['total'] as num?)?.toInt() ?? 0,
      official: (json['official'] as num?)?.toInt() ?? 0,
      normal: (json['normal'] as num?)?.toInt(),
      reverse: (json['reverse'] as num?)?.toInt(),
      holo: (json['holo'] as num?)?.toInt(),
      firstEd: (json['firstEd'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() => {
    'total': total,
    'official': official,
    if (normal != null) 'normal': normal,
    if (reverse != null) 'reverse': reverse,
    if (holo != null) 'holo': holo,
    if (firstEd != null) 'firstEd': firstEd,
  };
}

/// Set card count summary (as seen in SetResume).
class SetCardCountResume {
  final int total;
  final int official;

  SetCardCountResume({
    required this.total,
    required this.official,
  });

  factory SetCardCountResume.fromJson(Map<String, dynamic> json) {
    return SetCardCountResume(
      total: (json['total'] as num?)?.toInt() ?? 0,
      official: (json['official'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'total': total,
    'official': official,
  };
}

/// Booster pack information.
class Booster {
  final String id;
  final String name;
  final String? logo;
  final String? artworkFront;
  final String? artworkBack;

  Booster({
    required this.id,
    required this.name,
    this.logo,
    this.artworkFront,
    this.artworkBack,
  });

  factory Booster.fromJson(Map<String, dynamic> json) {
    return Booster(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      logo: json['logo'] as String?,
      artworkFront: (json['artwork_front'] ?? json['artworkFront']) as String?,
      artworkBack: (json['artwork_back'] ?? json['artworkBack']) as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    if (logo != null) 'logo': logo,
    if (artworkFront != null) 'artwork_front': artworkFront,
    if (artworkBack != null) 'artwork_back': artworkBack,
  };
}

/// Set abbreviations acronyms in various languages.
class SetAbbreviations {
  final String? official;
  final String? fr;
  final String? es;
  final String? esMx;
  final String? it;
  final String? pt;
  final String? ptBr;
  final String? ptPt;
  final String? de;
  final String? nl;
  final String? pl;
  final String? ru;
  final String? ja;
  final String? ko;
  final String? zhTw;
  final String? id;
  final String? th;
  final String? zhCn;

  SetAbbreviations({
    this.official,
    this.fr,
    this.es,
    this.esMx,
    this.it,
    this.pt,
    this.ptBr,
    this.ptPt,
    this.de,
    this.nl,
    this.pl,
    this.ru,
    this.ja,
    this.ko,
    this.zhTw,
    this.id,
    this.th,
    this.zhCn,
  });

  factory SetAbbreviations.fromJson(Map<String, dynamic> json) {
    return SetAbbreviations(
      official: json['official'] as String?,
      fr: json['fr'] as String?,
      es: json['es'] as String?,
      esMx: (json['es_mx'] ?? json['es-mx']) as String?,
      it: json['it'] as String?,
      pt: json['pt'] as String?,
      ptBr: (json['pt_br'] ?? json['pt-br']) as String?,
      ptPt: (json['pt_pt'] ?? json['pt-pt']) as String?,
      de: json['de'] as String?,
      nl: json['nl'] as String?,
      pl: json['pl'] as String?,
      ru: json['ru'] as String?,
      ja: json['ja'] as String?,
      ko: json['ko'] as String?,
      zhTw: (json['zh_tw'] ?? json['zh-tw']) as String?,
      id: json['id'] as String?,
      th: json['th'] as String?,
      zhCn: (json['zh_cn'] ?? json['zh-cn']) as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    if (official != null) 'official': official,
    if (fr != null) 'fr': fr,
    if (es != null) 'es': es,
    if (esMx != null) 'es_mx': esMx,
    if (it != null) 'it': it,
    if (pt != null) 'pt': pt,
    if (ptBr != null) 'pt_br': ptBr,
    if (ptPt != null) 'pt_pt': ptPt,
    if (de != null) 'de': de,
    if (nl != null) 'nl': nl,
    if (pl != null) 'pl': pl,
    if (ru != null) 'ru': ru,
    if (ja != null) 'ja': ja,
    if (ko != null) 'ko': ko,
    if (zhTw != null) 'zh_tw': zhTw,
    if (id != null) 'id': id,
    if (th != null) 'th': th,
    if (zhCn != null) 'zh_cn': zhCn,
  };
}
