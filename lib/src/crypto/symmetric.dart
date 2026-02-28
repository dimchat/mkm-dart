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
import 'helpers.dart';
import 'keys.dart';

/// Interface for symmetric cryptographic keys (single key for encryption/decryption).
///
/// Symmetric keys use the same key material for both encryption and decryption,
/// making them efficient for bulk data encryption (e.g., AES, DES).
///
/// Key data format (serialized as Map/JSON):
/// ```json
/// {
///   "algorithm" : "AES",  // "DES", ...
///   "data"      : "{BASE64_ENCODE}",
///   // Additional algorithm-specific parameters
///   // (e.g., "mode": "CBC", "padding": "PKCS7Padding")
/// }
/// ```
///
/// Implements both [EncryptKey] and [DecryptKey] since symmetric keys perform both operations.
abstract interface class SymmetricKey implements EncryptKey, DecryptKey {

  // static const AES = 'AES';  //-- "AES/CBC/PKCS7Padding"
  // static const DES = 'DES';

  //
  //  Factory methods
  //

  static SymmetricKey? generate(String algorithm) {
    var ext = CryptoExtensions();
    return ext.symmetricHelper!.generateSymmetricKey(algorithm);
  }

  static SymmetricKey? parse(Object? key) {
    var ext = CryptoExtensions();
    return ext.symmetricHelper!.parseSymmetricKey(key);
  }

  static SymmetricKeyFactory? getFactory(String algorithm) {
    var ext = CryptoExtensions();
    return ext.symmetricHelper!.getSymmetricKeyFactory(algorithm);
  }
  static void setFactory(String algorithm, SymmetricKeyFactory factory) {
    var ext = CryptoExtensions();
    ext.symmetricHelper!.setSymmetricKeyFactory(algorithm, factory);
  }
}

/// Factory interface for creating and parsing [SymmetricKey] instances.
///
/// Provides methods to generate new symmetric keys and reconstruct them from serialized data.
abstract interface class SymmetricKeyFactory {

  /// Generates a new random [SymmetricKey] using the default algorithm (typically AES).
  ///
  /// Returns: New cryptographically secure [SymmetricKey] instance
  SymmetricKey generateSymmetricKey();

  /// Parses a serialized Map into a [SymmetricKey] instance.
  ///
  /// [key]: Serialized key data (matches the Map format defined in [SymmetricKey])
  ///
  /// Returns: [SymmetricKey] instance, or null if parsing/validation fails
  SymmetricKey? parseSymmetricKey(Map key);
}
