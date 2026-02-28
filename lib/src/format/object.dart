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

/// Generic interface for serializing/deserializing objects to/from string formats.
///
/// Supported serialization formats include (but are not limited to):
/// - JSON
/// - XML
///
/// Core functionality:
/// 1. Encode a structured object (typically [Map] or [List]) to a string
/// 2. Decode a string back to the original structured object
///
/// [T]: Type of the object to encode/decode (usually [Map], [List] or custom model)
abstract interface class ObjectCoder<T> {

  /// Encodes a structured object to a serialized string.
  ///
  /// [object]: The object to serialize (typically [Map] or [List])
  ///
  /// Returns: Serialized string in the specific format (JSON/XML etc.)
  String encode(T object);

  /// Decodes a serialized string back to a structured object.
  ///
  /// [string]: The serialized string to deserialize
  ///
  /// Returns: Deserialized object of type [T], or null if decoding fails
  T? decode(String string);
}

class JSON {

  static String encode(Object container) {
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
    return JSON.coder!.encode(object);
  }

  @override
  Map? decode(String string) {
    return JSON.coder!.decode(string);
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
