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

///  Object Coder
///  ~~~~~~~~~~~~
///  JsON, XML, ...
///
///  1. encode object to string;
///  2. decode string to object.
abstract class ObjectCoder<T> {

  ///  Encode Map/List object to String
  ///
  /// @param object - Map or List
  /// @return serialized string
  String encode(T object);

  ///  Decode String to Map/List object
  ///
  /// @param string - serialized string
  /// @return Map or List
  T? decode(String string);
}

class JSON {

  static String encode(dynamic container) {
    return coder!.encode(container);
  }

  static dynamic decode(String json) {
    return coder!.decode(json);
  }

  static ObjectCoder<dynamic>? coder;
}

/// coder for json <=> map
class MapCoder implements ObjectCoder<Map> {

  @override
  String encode(Map object) {
    return JSON.encode(object);
  }

  @override
  Map? decode(String string) {
    return JSON.decode(string);
  }
}

/// coder for json <=> list
class ListCoder implements ObjectCoder<List> {

  @override
  String encode(List object) {
    return JSON.encode(object);
  }

  @override
  List? decode(String string) {
    return JSON.decode(string);
  }
}

class JSONMap {

  static String encode(Map container) {
    return coder.encode(container);
  }

  static Map? decode(String json) {
    return coder.decode(json);
  }

  static ObjectCoder<Map> coder = MapCoder();
}

class JSONList {

  static String encode(List container) {
    return coder.encode(container);
  }

  static List? decode(String json) {
    return coder.decode(json);
  }

  static ObjectCoder<List> coder = ListCoder();
}
