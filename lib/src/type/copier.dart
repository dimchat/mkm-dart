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

abstract class Copier {

  ///  Shallow Copy
  ///  ~~~~~~~~~~~~
  static dynamic copy(Object? object) {
    if (object == null) {
      return null;
    } else if (object is Mapper) {
      return copyMap(object.dictionary);
    } else if (object is Map) {
      return copyMap(object);
    } else if (object is List) {
      return copyList(object);
    } else {
      return object;
    }
  }

  static Map copyMap(Map dict) {
    Map clone = {};
    dict.forEach((key, value) {
      clone[key] = value;
    });
    return clone;
  }

  static List copyList(List array) {
    List list = [];
    for (var item in array) {
      list.add(item);
    }
    return list;
  }

  ///  Deep Copy
  ///  ~~~~~~~~~
  static dynamic deepCopy(Object? object) {
    if (object == null) {
      return null;
    } else if (object is Mapper) {
      return deepCopyMap(object.dictionary);
    } else if (object is Map) {
      return deepCopyMap(object);
    } else if (object is List) {
      return deepCopyList(object);
    } else {
      return object;
    }
  }

  static Map deepCopyMap(Map dict) {
    Map clone = {};
    dict.forEach((key, value) {
      clone[key] = deepCopy(value);
    });
    return clone;
  }

  static List deepCopyList(List array) {
    List list = [];
    for (var item in array) {
      list.add(deepCopy(item));
    }
    return list;
  }
}
