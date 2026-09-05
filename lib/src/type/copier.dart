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
import 'mapper.dart';
import 'mapping.dart';


/// Data Copy Utilities
final class Copier {
  Copier._();

  /// Shallow copy any object.
  static dynamic copy(Object? object) =>
      copier.copy(object);

  /// Deep copy any object.
  static dynamic deepCopy(Object? object) =>
      copier.deepCopy(object);

  /// Shallow copy the map.
  static Map<K, V> copyMap<K, V>(Mapping dict) =>
      copier.copyMap(dict);

  /// Deep copy the map.
  static Map<K, V> deepCopyMap<K, V>(Mapping dict) =>
      copier.deepCopyMap(dict);

  /// Shallow copy the list.
  static List<T> copyList<T>(List array) =>
      copier.copyList(array);

  /// Deep copy the list.
  static List<T> deepCopyList<T>(List array) =>
      copier.deepCopyList(array);

  static DataCopier copier = BaseCopier();

}

abstract interface class DataCopier {

  dynamic copy(Object? object);
  List<T> copyList<T>(List array);
  Map<K, V> copyMap<K, V>(Mapping dict);

  dynamic deepCopy(Object? object);
  List<T> deepCopyList<T>(List array);
  Map<K, V> deepCopyMap<K, V>(Mapping dict);

}

/// Default implementation of [DataCopier].
class BaseCopier implements DataCopier {

  @override
  dynamic copy(Object? object) {
    if (object == null) {
      return null;
    } else if (object is Mapper) {
      return copyMap(object.toMap());
    } else if (object is Map) {
      return copyMap(object.asMapping());
    } else if (object is List) {
      return copyList(object);
    } else {
      return object;
    }
  }

  @override
  List<T> copyList<T>(List array) {
    List<T> clone = [];
    for (final item in array) {
      clone.add(item);
    }
    return clone;
  }

  @override
  Map<K, V> copyMap<K, V>(Mapping dict) {
    Map<K, V> clone = {};
    dict.forEach((key, value) {
      clone[key] = value;
    });
    return clone;
  }

  @override
  dynamic deepCopy(Object? object) {
    if (object == null) {
      return null;
    } else if (object is Mapper) {
      return deepCopyMap(object.toMap());
    } else if (object is Map) {
      return deepCopyMap(object.asMapping());
    } else if (object is List) {
      return deepCopyList(object);
    } else {
      return object;
    }
  }

  @override
  List<T> deepCopyList<T>(List array) {
    List<T> clone = [];
    for (final item in array) {
      clone.add(deepCopy(item));
    }
    return clone;
  }

  @override
  Map<K, V> deepCopyMap<K, V>(Mapping dict) {
    Map<K, V> clone = {};
    dict.forEach((key, value) {
      clone[key] = deepCopy(value);
    });
    return clone;
  }

}
