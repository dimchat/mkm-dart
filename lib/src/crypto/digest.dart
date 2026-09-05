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

/// Interface for computing cryptographic hashes (message digests) of binary data.
///
/// Supported hash algorithms include (but are not limited to):
/// - MD5
/// - SHA-1
/// - SHA-256
/// - Keccak-256
/// - RipeMD-160
///
/// A message digest is a fixed-size string of bytes derived from arbitrary-sized
/// input data, used for data integrity verification.
abstract interface class MessageDigester {

  /// Get message digest.
  ///
  /// [data] is the input binary data to hash.
  ///
  /// Returns the fixed-size digest/hash value as [Uint8List].
  Uint8List digest(Uint8List data);
}


/// SHA-256 hash utility (facade for [MessageDigester]).
///
/// Computes the SHA-256 message digest (32-byte / 256-bit hash value).
final class SHA256 {
  SHA256._();

  /// Get the SHA-256 digest of [data].
  ///
  /// [data] is the input binary data to hash.
  ///
  /// Returns the 32-byte digest value as [Uint8List].
  static Uint8List digest(Uint8List data) {
    return digester!.digest(data);
  }

  /// The [MessageDigester] implementation (null before set).
  static MessageDigester? digester;
}


/// Keccak-256 hash utility (facade for [MessageDigester]).
///
/// Computes the Keccak-256 message digest (32-byte / 256-bit hash value).
final class KECCAK256 {
  KECCAK256._();

  /// Get the Keccak-256 digest of [data].
  ///
  /// [data] is the input binary data to hash.
  ///
  /// Returns the 32-byte digest value as [Uint8List].
  static Uint8List digest(Uint8List data) {
    return digester!.digest(data);
  }

  /// The [MessageDigester] implementation (null before set).
  static MessageDigester? digester;
}


/// RipeMD-160 hash utility (facade for [MessageDigester]).
///
/// Computes the RipeMD-160 message digest (20-byte / 160-bit hash value).
final class RIPEMD160 {
  RIPEMD160._();

  /// Get the RipeMD-160 digest of [data].
  ///
  /// [data] is the input binary data to hash.
  ///
  /// Returns the 20-byte digest value as [Uint8List].
  static Uint8List digest(Uint8List data) {
    return digester!.digest(data);
  }

  /// The [MessageDigester] implementation (null before set).
  static MessageDigester? digester;
}
