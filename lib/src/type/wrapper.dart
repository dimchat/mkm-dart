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
import 'stringer.dart';


/// Data Wrap Utilities
final class Wrapper {
  Wrapper._();

  /// Shallow unwrap string value.
  static String? getString(Object? str) =>
      wrapper.getString(str);

  /// Shallow unwrap dict value.
  static Map? getMap(Object? dict) =>
      wrapper.getMap(dict);

  /// Deep unwrap value.
  static dynamic unwrap(Object? object) =>
      wrapper.unwrap(object);

  /// Deep unwrap dict value.
  static Map<K, V> unwrapMap<K, V>(Mapping dict) =>
      wrapper.unwrapMap(dict);

  /// Deep unwrap List value.
  static List<T> unwrapList<T>(List array) =>
      wrapper.unwrapList(array);

  static DataWrapper wrapper = BaseWrapper();

}

abstract interface class DataWrapper {

  String? getString(Object? str);

  Map? getMap(Object? dict);

  dynamic unwrap(Object? object);

  Map<K, V> unwrapMap<K, V>(Mapping dict);

  List<T> unwrapList<T>(List array);

}

/// Default implementation of [DataWrapper].
class BaseWrapper implements DataWrapper {

  @override
  String? getString(Object? str) {
    if (str == null) {
      return null;
    } else if (str is Stringer) {
      return str.toString();
    } else if (str is String) {
      return str;
    } else {
      assert(false, 'string error: $str');
      return str.toString();
    }
  }

  @override
  Map? getMap(Object? dict) {
    if (dict == null) {
      return null;
    } else if (dict is Mapper) {
      return dict.toMap().asMap();
    } else if (dict is Map) {
      return dict;
    } else {
      assert(false, 'map error: $dict');
      return null;
    }
  }

  @override
  dynamic unwrap(Object? object) {
    if (object == null) {
      return null;
    } else if (object is Mapper) {
      return unwrapMap(object.toMap());
    } else if (object is Map) {
      return unwrapMap(object.asMapping());
    } else if (object is List) {
      return unwrapList(object);
    } else if (object is Stringer) {
      return object.toString();
    } else {
      return object;
    }
  }

  @override
  Map<K, V> unwrapMap<K, V>(Mapping dict) {
    // if (dict is Mapper) {
    //   dict = dict.toMap();
    // }
    Map<K, V> result = {};
    dict.forEach((key, value) {
      result[key] = unwrap(value);
    });
    return result;
  }

  @override
  List<T> unwrapList<T>(List array) {
    List<T> result = [];
    for (final item in array) {
      result.add(unwrap(item));
    }
    return result;
  }

}
