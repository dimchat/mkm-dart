/* license: https://mit-license.org
 * =============================================================================
 * The MIT License (MIT)
 *
 * Copyright (c) 2026 Albert Moky
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 * =============================================================================
 */

/**
 *  Map Types Casting
 *  ~~~~~~~~~~~~~~~~~
 *  Mutable, Immutable Maps
 */

// /// Immutable Map (syntactic sugar)
// abstract interface class Mapping<K, V> {
//
//   bool containsValue(Object? value);
//   bool containsKey(Object? key);
//
//   V? operator [](Object? key);
//
//   Iterable<MapEntry<K, V>> get entries;
//   Iterable<K> get keys;
//   Iterable<V> get values;
//
//   int get length;
//   bool get isEmpty;
//   bool get isNotEmpty;
//
//   void forEach(void Function(K key, V value) action);
//
//   Map<RK, RV> cast<RK, RV>();
//   Map<K2, V2> map<K2, V2>(MapEntry<K2, V2> Function(K key, V value) convert);
//
// }
//
// /// Mutable Map (syntactic sugar)
// abstract interface class MutableMapping<K, V> implements Mapping<K, V> {
//
//   void operator []=(K key, V value);
//
//   V update(K key, V Function(V value) update, {V Function()? ifAbsent});
//   void updateAll(V Function(K key, V value) update);
//
//   void addEntries(Iterable<MapEntry<K, V>> newEntries);
//   void addAll(Map<K, V> other);
//
//   V putIfAbsent(K key, V Function() ifAbsent);
//
//   void removeWhere(bool Function(K key, V value) test);
//   V? remove(Object? key);
//   void clear();
//
// }
//
// extension MappingTypeCastExtension<K, V> on Mapping<K, V> {
//
//   Map<K, V> asMap() => this as Map<K, V>;
//
// }
//
// extension MapTypeCastExtension<K, V> on Map<K, V> {
//
//   Map<K, V> asMap() => this;
//
//   Mapping<K, V> asMapping() => this as Mapping<K, V>;
//   // Mapping<K, V> asMapping() => Map.unmodifiable(this) as Mapping<K, V>;
//
//   MutableMapping<K, V> asMutableMapping() => this as MutableMapping<K, V>;
//
// }


/// Immutable Map (type alias)
typedef Mapping<K, V> = Map<K, V>;

/// Mutable Map (type alias)
typedef MutableMapping<K, V> = Map<K, V>;

extension MapTypeCastExtension<K, V> on Map<K, V> {

  Map<K, V> asMap() => this;

  Mapping<K, V> asMapping() => this;
  // Mapping<K, V> asMapping() => Map.unmodifiable(this);

  MutableMapping<K, V> asMutableMapping() => this;

}
