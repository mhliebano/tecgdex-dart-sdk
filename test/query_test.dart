import 'package:test/test.dart';
import 'package:tcgdex_dart_sdk/src/query/query.dart';

void main() {
  group('Query Builder', () {
    test('empty query builds empty string', () {
      final q = Query();
      expect(q.build(), '');
      expect(q.toMap(), isEmpty);
    });

    test('equal filter', () {
      final q = Query().equal('name', 'Furret');
      expect(q.build(), '?name=eq%3AFurret');
    });

    test('notEqual filter', () {
      final q = Query().notEqual('name', 'Furret');
      expect(q.build(), '?name=neq%3AFurret');
    });

    test('contains, like, and includes', () {
      final q1 = Query().contains('name', 'Pikachu');
      expect(q1.build(), '?name=Pikachu');

      final q2 = Query().like('name', 'Pikachu');
      expect(q2.build(), '?name=Pikachu');

      final q3 = Query().includes('name', 'Pikachu');
      expect(q3.build(), '?name=Pikachu');
    });

    test('notContains, notLike, and notIncludes', () {
      final q = Query().notContains('name', 'Pikachu');
      expect(q.build(), '?name=not%3APikachu');

      final q2 = Query().notLike('name', 'Pikachu');
      expect(q2.build(), '?name=not%3APikachu');
    });

    test('numeric comparisons', () {
      final q = Query()
          .gte('hp', 100)
          .lte('hp', 200)
          .gt('retreat', 1)
          .lt('retreat', 4);

      expect(q.build(), '?hp=gte%3A100&hp=lte%3A200&retreat=gt%3A1&retreat=lt%3A4');
    });

    test('null checks', () {
      final q = Query().isNull('stage').notNull('illustrator');
      expect(q.build(), '?stage=null%3A&illustrator=notnull%3A');
    });

    test('sort and pagination', () {
      final q = Query().sort('name', 'ASC').paginate(2, 50);
      expect(
        q.build(),
        '?sort%3Afield=name&sort%3Aorder=ASC&pagination%3Apage=2&pagination%3AitemsPerPage=50',
      );
    });
  });
}
