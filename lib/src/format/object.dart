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
import '../type/mapping.dart';


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
/// [T] is the type of the object to encode/decode (usually [Map], [List] or custom model).
abstract interface class ObjectCoder<T> {

  /// Encodes a structured object to a serialized string.
  ///
  /// [object] is the object to serialize (typically [Map] or [List]).
  ///
  /// Returns the serialized string in the specific format (JSON/XML etc.).
  String encode(T object);

  /// Decodes a serialized string back to a structured object.
  ///
  /// [string] is the serialized string to deserialize.
  ///
  /// Returns the deserialized object of type [T], or null if decoding fails.
  T? decode(String string);
}


/// JSON encoding utility (facade for [ObjectCoder]).
///
/// Converts structured objects (Map/List) to/from JSON strings.
final class JSON {
  JSON._();

  /// Encodes a structured object to a JSON string.
  ///
  /// [container] is the object to serialize (typically [Map] or [List]).
  ///
  /// Returns the JSON-encoded string.
  static String encode(Object container) {
    return coder!.encode(container);
  }

  /// Decodes a JSON string back to a structured object.
  ///
  /// [json] is the JSON string to deserialize.
  ///
  /// Returns the decoded object (typically [Map] or [List]).
  static dynamic decode(String json) {
    return coder!.decode(json);
  }

  /// The [ObjectCoder] implementation (null before set).
  static ObjectCoder<dynamic>? coder;
}

/// coder for json <=> map
class MapCoder implements ObjectCoder<Mapping> {

  @override
  String encode(Mapping object) {
    return JSON.coder!.encode(object);
  }

  @override
  Mapping? decode(String string) {
    return JSON.coder!.decode(string);
  }
}


/// JSON Map encoding utility (facade for [MapCoder]).
///
/// Converts [Mapping] objects to/from JSON strings.
final class JSONMap {
  JSONMap._();

  /// Encodes a map to a JSON string.
  ///
  /// [container] is the map to serialize.
  ///
  /// Returns the JSON-encoded string.
  static String encode(Mapping container) {
    return coder.encode(container);
  }

  /// Decodes a JSON string back to a map.
  ///
  /// [json] is the JSON string to deserialize.
  ///
  /// Returns the decoded map, or null if decoding fails.
  static Map? decode(String json) {
    final info = coder.decode(json);
    assert(info is Map, 'json error: "$json"');
    return info?.asMap();
  }

  /// The [ObjectCoder] implementation for map encoding (default: [MapCoder]).
  static ObjectCoder<Mapping> coder = MapCoder();
}
