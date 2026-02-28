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
import 'dart:typed_data';

/// Interface for encoding/decoding binary data to/from string representations.
///
/// Supported encoding types include (but are not limited to):
/// - Hex (hexadecimal)
/// - Base58
/// - Base64
///
/// Core functionality:
/// 1. Encode binary data ([Uint8List]) to a string
/// 2. Decode a string back to binary data ([Uint8List])
abstract interface class DataCoder {

  /// Encodes binary data to a string representation.
  ///
  /// [data]: The raw binary data to encode (Uint8List)
  ///
  /// Returns: Encoded string in the specific format (Hex/Base58/Base64 etc.)
  String encode(Uint8List data);

  /// Decodes a string back to binary data.
  ///
  /// [string]: The encoded string to decode
  ///
  /// Returns: Decoded binary data (Uint8List), or null if decoding fails
  Uint8List? decode(String string);
}

class Hex {

  static String encode(Uint8List data) {
    return coder!.encode(data);
  }

  static Uint8List? decode(String string) {
    return coder!.decode(string);
  }

  static DataCoder? coder;
}

class Base58 {

  static String encode(Uint8List data) {
    return coder!.encode(data);
  }

  static Uint8List? decode(String string) {
    return coder!.decode(string);
  }

  static DataCoder? coder;
}

class Base64 {

  static String encode(Uint8List data) {
    return coder!.encode(data);
  }

  static Uint8List? decode(String string) {
    return coder!.decode(string);
  }

  static DataCoder? coder;
}
