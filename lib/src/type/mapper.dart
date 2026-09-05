/* license: https://mit-license.org
 * =============================================================================
 * The MIT License (MIT)
 *
 * Copyright (c) 2023 Albert Moky
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
import 'mapping.dart';
import 'stringer.dart';


/// Mutable Map Wrapper
///
/// A map wrapper with typed getters (getString/getBool/getInt/...) and
/// [MutableMapping] support.
abstract interface class Mapper<K, V> implements MutableMapping<K, V> {

  /// Get string value for key, if value is None, return the default value.
  String?     getString(K key, [String? defaultValue]);
  bool?         getBool(K key, [bool?   defaultValue]);
  int?           getInt(K key, [int?    defaultValue]);
  double?     getDouble(K key, [double? defaultValue]);

  DateTime? getDateTime(K key, [DateTime? defaultValue]);
  void      setDateTime(K key, DateTime? time);

  void        setString(K key, Stringer? stringer);
  void           setMap(K key, Mapper? mapper);

  /// Get inner map.
  MutableMapping toMap();

  /// Copy inner map.
  Map<K, V> copyMap([bool deepCopy = false]);

}
