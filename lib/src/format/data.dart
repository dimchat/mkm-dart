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
  /// [data] is the raw binary data to encode.
  ///
  /// Returns the encoded string in the specific format (Hex/Base58/Base64 etc.).
  String encode(Uint8List data);

  /// Decodes a string back to binary data.
  ///
  /// [string] is the encoded string to decode.
  ///
  /// Returns the decoded binary data, or null if decoding fails.
  Uint8List? decode(String string);
}


/// Hex encoding utility (facade for [DataCoder]).
///
/// Converts binary data to/from hexadecimal string representation.
final class Hex {
  Hex._();

  /// Encodes binary data to a hexadecimal string.
  ///
  /// [data] is the raw binary data to encode.
  ///
  /// Returns the hex-encoded string.
  static String encode(Uint8List data) {
    return coder!.encode(data);
  }

  /// Decodes a hexadecimal string back to binary data.
  ///
  /// [string] is the hex-encoded string to decode.
  ///
  /// Returns the decoded binary data, or null if decoding fails.
  static Uint8List? decode(String string) {
    return coder!.decode(string);
  }

  /// The [DataCoder] implementation (null before set).
  static DataCoder? coder;
}


/// Base58 encoding utility (facade for [DataCoder]).
///
/// Converts binary data to/from Base58 string representation
/// (Bitcoin-style alphabet without '0', 'O', 'I', 'l').
final class Base58 {
  Base58._();

  /// Encodes binary data to a Base58 string.
  ///
  /// [data] is the raw binary data to encode.
  ///
  /// Returns the Base58-encoded string.
  static String encode(Uint8List data) {
    return coder!.encode(data);
  }

  /// Decodes a Base58 string back to binary data.
  ///
  /// [string] is the Base58-encoded string to decode.
  ///
  /// Returns the decoded binary data, or null if decoding fails.
  static Uint8List? decode(String string) {
    return coder!.decode(string);
  }

  /// The [DataCoder] implementation (null before set).
  static DataCoder? coder;
}


/// Base64 encoding utility (facade for [DataCoder]).
///
/// Converts binary data to/from Base64 string representation.
final class Base64 {
  Base64._();

  /// Encodes binary data to a Base64 string.
  ///
  /// [data] is the raw binary data to encode.
  ///
  /// Returns the Base64-encoded string.
  static String encode(Uint8List data) {
    return coder!.encode(data);
  }

  /// Decodes a Base64 string back to binary data.
  ///
  /// [string] is the Base64-encoded string to decode.
  ///
  /// Returns the decoded binary data, or null if decoding fails.
  static Uint8List? decode(String string) {
    return coder!.decode(string);
  }

  /// The [DataCoder] implementation (null before set).
  static DataCoder? coder;
}
