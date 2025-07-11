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
import 'comparator.dart';
import 'converter.dart';
import 'copier.dart';
import 'stringer.dart';

abstract interface class Mapper implements Map<String, dynamic> {

  String? getString(String key, [String? defaultValue]);
  bool?     getBool(String key, [bool?   defaultValue]);
  int?       getInt(String key, [int?    defaultValue]);
  double? getDouble(String key, [double? defaultValue]);

  DateTime? getDateTime(String key, [DateTime? defaultValue]);
  void setDateTime(String key, DateTime? time);

  void setString(String key, Stringer? stringer);
  void setMap(String key, Mapper? mapper);

  ///  Get inner map
  ///
  /// @return Map
  Map toMap();

  ///  Copy inner map
  ///
  /// @param deepCopy - deep copy
  /// @return Map
  Map copyMap(bool deepCopy);
}

class Dictionary implements Mapper {

  final Map _map;

  Dictionary(Map? dict)
      : _map = dict == null ? {}
      : dict is Mapper ? dict.toMap()
      : dict;

  @override
  String? getString(String key, [String? defaultValue]) =>
      Converter.getString(_map[key], defaultValue);

  @override
  bool? getBool(String key, [bool? defaultValue]) =>
      Converter.getBool(_map[key], defaultValue);

  @override
  int? getInt(String key, [int? defaultValue]) =>
      Converter.getInt(_map[key], defaultValue);

  @override
  double? getDouble(String key, [double? defaultValue]) =>
      Converter.getDouble(_map[key], defaultValue);

  @override
  DateTime? getDateTime(String key, [DateTime? defaultValue]) =>
      Converter.getDateTime(_map[key], defaultValue);

  @override
  void setDateTime(String key, DateTime? time) {
    if (time == null) {
      _map.remove(key);
    } else {
      _map[key] = time.millisecondsSinceEpoch / 1000.0;
    }
  }

  @override
  void setString(String key, Stringer? stringer) {
    if (stringer == null) {
      _map.remove(key);
    } else {
      _map[key] = stringer.toString();
    }
  }

  @override
  void setMap(String key, Mapper? mapper) {
    if (mapper == null) {
      _map.remove(key);
    } else {
      _map[key] = mapper.toMap();
    }
  }

  @override
  Map toMap() => _map;

  @override
  Map copyMap(bool deepCopy) {
    if (deepCopy) {
      return Copier.deepCopyMap(_map);
    } else {
      return Copier.copyMap(_map);
    }
  }

  @override
  String toString() => _map.toString();

  @override
  bool operator ==(Object other) {
    if (other is Mapper) {
      if (identical(this, other)) {
        // same object
        return true;
      }
      // compare with inner map
      other = other.toMap();
    }
    return other is Map && Comparator.mapEquals(other, _map);
  }

  @override
  int get hashCode => _map.hashCode;

  ///
  ///   Map<String, dynamic>
  ///

  @override
  Map<RK, RV> cast<RK, RV>() => _map.cast();

  @override
  bool containsValue(dynamic value) => _map.containsValue(value);

  @override
  bool containsKey(Object? key) => _map.containsKey(key);

  @override
  dynamic operator [](Object? key) => _map[key];

  @override
  void operator []=(String key, dynamic value) => _map[key] = value;

  @override
  Iterable<MapEntry<String, dynamic>> get entries => _map.entries.cast();

  @override
  Map<K2, V2> map<K2, V2>
      (MapEntry<K2, V2> Function(String key, dynamic value) convert) =>
      _map.map((key, value) => convert(key, value));

  @override
  void addEntries(Iterable<MapEntry<String, dynamic>> newEntries) =>
      _map.addEntries(newEntries);

  @override
  dynamic update(String key, Function(dynamic value) update,
      {Function()? ifAbsent}) =>
      _map.update(key, update, ifAbsent: ifAbsent);

  @override
  void updateAll(Function(String key, dynamic value) update) =>
      _map.updateAll((key, value) => update(key, value));

  @override
  void removeWhere(bool Function(String key, dynamic value) test) =>
      _map.removeWhere((key, value) => test(key, value));

  @override
  dynamic putIfAbsent(String key, Function() ifAbsent) =>
      _map.putIfAbsent(key, ifAbsent);

  @override
  void addAll(Map other) => _map.addAll(other);

  @override
  dynamic remove(Object? key) => _map.remove(key);

  @override
  void clear() => _map.clear();

  @override
  void forEach(void Function(String key, dynamic value) action) =>
      _map.forEach((key, value) => action);

  @override
  Iterable<String> get keys => _map.keys.cast();

  @override
  Iterable get values => _map.values;

  @override
  int get length => _map.length;

  @override
  bool get isEmpty => _map.isEmpty;

  @override
  bool get isNotEmpty => _map.isNotEmpty;
}
