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
import 'stringer.dart';

abstract class Wrapper {

  ///  Get inner String
  ///  ~~~~~~~~~~~~~~~~
  ///  Remove first wrapper
  static String? getString(Object? str) {
    if (str == null) {
      return null;
    } else if (str is Stringer) {
      return str.toString();
    } else if (str is String) {
      return str;
    } else {
      return null;
    }
  }

  ///  Get inner Map
  ///  ~~~~~~~~~~~~~
  ///  Remove first wrapper
  static Map? getMap(Object? dict) {
    if (dict == null) {
      return null;
    } else if (dict is Mapper) {
      return dict.toMap();
    } else if (dict is Map) {
      return dict;
    } else {
      return null;
    }
  }

  ///  Unwrap recursively
  ///  ~~~~~~~~~~~~~~~~~~
  ///  Remove all wrappers
  static dynamic unwrap(Object? object) {
    if (object == null) {
      return null;
    } else if (object is Stringer) {
      return object.toString();
    } else if (object is Mapper) {
      return unwrapMap(object.toMap());
    } else if (object is Map) {
      return unwrapMap(object);
    } else if (object is List) {
      return unwrapList(object);
    } else {
      return object;
    }
  }

  /// Unwrap values for keys in map
  static Map unwrapMap(Map dict) {
    if (dict is Mapper) {
      dict = dict.toMap();
    }
    Map result = {};
    dict.forEach((key, value) {
      result[key] = unwrap(value);
    });
    return result;
  }

  /// Unwrap values in the array
  static List unwrapList(dynamic array) {
    List result = [];
    for (var item in array) {
      result.add(unwrap(item));
    }
    return result;
  }

  ///
  /// Comparison (Shallow)
  ///

  static bool mapEquals(Map map1, Map map2) {
    if (identical(map1, map2)) {
      // same object
      return true;
    } else if (map2.length != map1.length) {
      // different lengths
      return false;
    }
    for (var k in map1.keys) {
      if (!objectEquals(map1[k], map2[k])) {
        return false;
      }
    }
    return true;
  }

  static bool listEquals(List arr1, List arr2) {
    if (identical(arr1, arr2)) {
      // same object
      return true;
    } else if (arr1.length != arr2.length) {
      // different lengths
      return false;
    }
    for (int i = 0; i < arr1.length; ++i) {
      if (!objectEquals(arr1[i], arr2[i])) {
        return false;
      }
    }
    return true;
  }

  static bool objectEquals(Object? obj1, Object? obj2) {
    if (obj1 == null) {
      return obj2 == null;
    } else if (obj2 == null) {
      return false;
    } else {
      return obj1 == obj2;
    }
  }

  ///
  /// Comparison (Deep)
  ///

  static bool mapDeepEquals(Map map1, Map map2) {
    if (identical(map1, map2)) {
      // same object
      return true;
    } else if (map2.length != map1.length) {
      // different lengths
      return false;
    }
    for (var k in map1.keys) {
      if (!objectDeepEquals(map1[k], map2[k])) {
        return false;
      }
    }
    return true;
  }

  static bool listDeepEquals(List arr1, List arr2) {
    if (identical(arr1, arr2)) {
      // same object
      return true;
    } else if (arr1.length != arr2.length) {
      // different lengths
      return false;
    }
    for (int i = 0; i < arr1.length; ++i) {
      if (!objectDeepEquals(arr1[i], arr2[i])) {
        return false;
      }
    }
    return true;
  }

  static bool objectDeepEquals(Object? obj1, Object? obj2) {
    if (obj1 == null) {
      return obj2 == null;
    } else if (obj2 == null) {
      return false;
    }
    if (obj1 is Map) {
      if (obj2 is Map) {
        return mapDeepEquals(obj1, obj2);
      }
    } else if (obj1 is List) {
      if (obj2 is List) {
        return listDeepEquals(obj1, obj2);
      }
    }
    return obj1 == obj2;
  }
}
