/// A query parameter pair.
class QueryParam {
  final String key;
  final String value;

  const QueryParam(this.key, this.value);
}

/// Query builder for filtering, sorting and paginating TCGdex endpoints.
class Query {
  final List<QueryParam> params = [];

  /// Helper to encode a value for query parameters.
  static String encode(dynamic value) {
    final str = value.toString().replaceAll('?', '%3F');
    return Uri.encodeQueryComponent(str);
  }

  /// Adds a custom key-value parameter.
  Query add(String key, String value) {
    params.add(QueryParam(key, value));
    return this;
  }

  /// Exact equality match (`eq:value`).
  Query equal(String key, String value) {
    return add(key, 'eq:$value');
  }

  /// Not equal match (`neq:value`).
  Query notEqual(String key, String value) {
    return add(key, 'neq:$value');
  }

  /// Partial match / contains.
  Query contains(String key, String value) {
    return add(key, value);
  }

  /// Alias for [contains].
  Query includes(String key, String value) => contains(key, value);

  /// Alias for [contains].
  Query like(String key, String value) => contains(key, value);

  /// Negated partial match (`not:value`).
  Query notContains(String key, String value) {
    return add(key, 'not:$value');
  }

  /// Alias for [notContains].
  Query notIncludes(String key, String value) => notContains(key, value);

  /// Alias for [notContains].
  Query notLike(String key, String value) => notContains(key, value);

  /// Field must be null (`null:`).
  Query isNull(String key) {
    return add(key, 'null:');
  }

  /// Field must not be null (`notnull:`).
  Query notNull(String key) {
    return add(key, 'notnull:');
  }

  /// Greater than or equal to (`gte:value`).
  Query greaterOrEqualThan(String key, int value) {
    return add(key, 'gte:$value');
  }

  /// Alias for [greaterOrEqualThan].
  Query gte(String key, int value) => greaterOrEqualThan(key, value);

  /// Less than or equal to (`lte:value`).
  Query lesserOrEqualThan(String key, int value) {
    return add(key, 'lte:$value');
  }

  /// Alias for [lesserOrEqualThan].
  Query lte(String key, int value) => lesserOrEqualThan(key, value);

  /// Greater than (`gt:value`).
  Query greaterThan(String key, int value) {
    return add(key, 'gt:$value');
  }

  /// Alias for [greaterThan].
  Query gt(String key, int value) => greaterThan(key, value);

  /// Less than (`lt:value`).
  Query lesserThan(String key, int value) {
    return add(key, 'lt:$value');
  }

  /// Alias for [lesserThan].
  Query lt(String key, int value) => lesserThan(key, value);

  /// Sort results by [key] in [order] ('ASC' or 'DESC').
  Query sort(String key, String order) {
    add('sort:field', key);
    add('sort:order', order);
    return this;
  }

  /// Paginate results by [page] and [itemsPerPage].
  Query paginate(int page, int itemsPerPage) {
    add('pagination:page', page.toString());
    add('pagination:itemsPerPage', itemsPerPage.toString());
    return this;
  }

  /// Builds the query string starting with `?` if parameters are present,
  /// or returns an empty string if there are no parameters.
  String build() {
    if (params.isEmpty) return '';
    final queryString = params
        .map((p) => '${encode(p.key)}=${encode(p.value)}')
        .join('&');
    return '?$queryString';
  }

  /// Converts the query parameters into a map suitable for Dio or HTTP clients.
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    for (final param in params) {
      map[param.key] = param.value;
    }
    return map;
  }

  @override
  String toString() => build();
}
