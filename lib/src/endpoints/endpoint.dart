import 'package:dio/dio.dart';
import '../models/model.dart';
import '../query/query.dart';
import '../tcgdex.dart';

/// Function signature for parsing a single detailed item from JSON.
typedef ItemParser<T> = T Function(Map<String, dynamic> json, [TcgDex? sdk]);

/// Function signature for parsing a list item from dynamic JSON (can be primitive or model).
typedef ListParser<T> = T Function(dynamic json, [TcgDex? sdk]);

/// Generic API endpoint handler for TCGdex resources.
class Endpoint<TItem, TList> {
  final TcgDex sdk;
  final String path;
  final ItemParser<TItem> itemParser;
  final ListParser<TList> listParser;

  Endpoint({
    required this.sdk,
    required this.path,
    required this.itemParser,
    required this.listParser,
  });

  /// Constructs the path URL for single item retrieval.
  String _itemUrl(Object id) {
    final cleanId = id.toString().trim().replaceAll(' ', '%20');
    return '${sdk.getEndpoint()}/${sdk.language.code}/$path/$cleanId';
  }

  /// Constructs the path URL for listing items.
  String _listUrl([Query? query]) {
    final base = '${sdk.getEndpoint()}/${sdk.language.code}/$path';
    if (query != null) {
      return '$base${query.build()}';
    }
    return base;
  }

  /// Fetches a single item by its [id].
  /// Returns `null` if the item is not found (404).
  Future<TItem?> get(Object id) async {
    final url = _itemUrl(id);
    try {
      final response = await sdk.dio.get<dynamic>(url);
      if (response.data == null) return null;
      if (response.data is Map<String, dynamic>) {
        final item = itemParser(response.data as Map<String, dynamic>, sdk);
        if (item is TcgModel) {
          (item as TcgModel).attachSdk(sdk);
        }
        return item;
      }
      return null;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return null;
      }
      rethrow;
    }
  }

  /// Lists items matching the optional [query] filter.
  Future<List<TList>> list([Query? query]) async {
    final url = _listUrl(query);
    final response = await sdk.dio.get<dynamic>(url);
    if (response.data == null || response.data is! List) {
      return <TList>[];
    }

    final rawList = response.data as List<dynamic>;
    return rawList.map((item) {
      final parsed = listParser(item, sdk);
      if (parsed is TcgModel) {
        (parsed as TcgModel).attachSdk(sdk);
      }
      return parsed;
    }).toList();
  }
}
