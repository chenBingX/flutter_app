import 'package:flutter_test/flutter_test.dart';

void main() {
  test('', () async {
    SortedCollection coll = new SortedCollection(sort);
    assert(coll.compare is Function);
    assert(coll.compare is Compare);
  });

//  a.func();
}

typedef int Compare(Object a, Object b);

class SortedCollection {
  Compare compare;

  SortedCollection(this.compare);
}

// Initial, broken implementation.
int sort(Object a, Object b) => 0;