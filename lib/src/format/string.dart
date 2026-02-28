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

/// Interface for encoding/decoding strings to/from binary data (byte arrays).
///
/// Supported character encodings include (but are not limited to):
/// - UTF-8 (default for most applications)
/// - UTF-16
/// - GBK
/// - GB2312
///
/// Core functionality:
/// 1. Encode a human-readable string to binary data ([Uint8List])
/// 2. Decode binary data ([Uint8List]) back to a human-readable string
abstract interface class StringCoder {

  /// Encodes a string to binary data using the specified character encoding.
  ///
  /// [string]: The string to encode
  ///
  /// Returns: Binary representation of the string as [Uint8List]
  Uint8List encode(String string);

  /// Decodes binary data back to a string using the specified character encoding.
  ///
  /// [data]: The binary data to decode (Uint8List)
  ///
  /// Returns: Decoded string, or null if decoding fails
  String? decode(Uint8List data);
}

class UTF8 {

  static Uint8List encode(String string) {
    return coder!.encode(string);
  }

  static String? decode(Uint8List utf8) {
    return coder!.decode(utf8);
  }

  static StringCoder? coder;
}
