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
import 'private.dart';
import 'public.dart';
import 'symmetric.dart';

// -----------------------------------------------------------------------------
//  Cryptographic Key Helpers
// -----------------------------------------------------------------------------

/// Helper interface for symmetric key management.
///
/// Manages symmetric key factories (by algorithm) and provides methods to
/// generate new symmetric keys and parse raw key data into [SymmetricKey] instances.
///
/// Symmetric keys are used for encrypting/decrypting message content (AES, DES, etc.).
abstract interface class SymmetricKeyHelper {

  void setSymmetricKeyFactory(String algorithm, SymmetricKeyFactory factory);
  SymmetricKeyFactory? getSymmetricKeyFactory(String algorithm);

  /// Generates a new symmetric key for the specified algorithm.
  ///
  /// Creates a cryptographically secure random key for the given algorithm.
  ///
  /// @param algorithm - Name of the symmetric algorithm (e.g., "AES")
  ///
  /// @return New symmetric key (null if algorithm is unsupported)
  SymmetricKey? generateSymmetricKey(String algorithm);

  /// Parses raw key data into a [SymmetricKey] instance.
  ///
  /// Converts raw key representations (map) into a strongly-typed
  /// symmetric key object for encryption/decryption operations.
  ///
  /// @param key - Raw key data to parse
  ///
  /// @return Parsed symmetric key (null if parsing fails)
  SymmetricKey? parseSymmetricKey(Object? key);

}

/// Helper interface for public key management.
///
/// Manages public key factories (by algorithm) and provides methods to
/// parse raw public key data into [PublicKey] instances.
///
/// Public keys are used for verifying signatures or encrypting data for a specific recipient.
abstract interface class PublicKeyHelper {

  void setPublicKeyFactory(String algorithm, PublicKeyFactory factory);
  PublicKeyFactory? getPublicKeyFactory(String algorithm);

  /// Parses raw public key data into a [PublicKey] instance.
  ///
  /// Converts raw public key representations (map) into a strongly-typed
  /// public key object for verification/encryption operations.
  ///
  /// @param key - Raw public key data to parse
  ///
  /// @return Parsed public key (null if parsing fails)
  PublicKey? parsePublicKey(Object? key);

}

/// Helper interface for private key management.
///
/// Manages private key factories (by algorithm) and provides methods to
/// generate new private keys and parse raw private key data into [PrivateKey] instances.
///
/// Private keys are used for signing data or decrypting data encrypted with the public key.
abstract interface class PrivateKeyHelper {

  void setPrivateKeyFactory(String algorithm, PrivateKeyFactory factory);
  PrivateKeyFactory? getPrivateKeyFactory(String algorithm);

  /// Generates a new private key for the specified algorithm.
  ///
  /// Creates a cryptographically secure random private key for the given algorithm.
  ///
  /// @param algorithm - Name of the asymmetric algorithm (e.g., "RSA", "ECC")
  ///
  /// @return New private key (null if algorithm is unsupported)
  PrivateKey? generatePrivateKey(String algorithm);

  /// Parses raw private key data into a [PrivateKey] instance.
  ///
  /// Converts raw private key representations (map) into a strongly-typed
  /// private key object for signing/decryption operations.
  ///
  /// @param key - Raw private key data to parse
  ///
  /// @return Parsed private key (null if parsing fails)
  PrivateKey? parsePrivateKey(Object? key);

}

// -----------------------------------------------------------------------------
//  Cryptography Extension Manager
// -----------------------------------------------------------------------------

/// Core extension manager for cryptographic key operations.
///
/// Singleton class that manages crypto-related extensions (symmetric/private/public keys)
/// to provide consistent key management across the application.
final sharedCryptoExtensions = CryptoExtensions();

/// Singleton extension class for cryptographic key operations.
///
/// Centralizes access to crypto helpers (symmetric/private/public key helpers)
/// using Dart extensions for clean, modular access.
class CryptoExtensions {
  factory CryptoExtensions() => _instance;
  static final CryptoExtensions _instance = CryptoExtensions._internal();
  CryptoExtensions._internal();

  //...
}

/// SymmetricKey extension
SymmetricKeyHelper? _symmetricHelper;

extension SymmetricKeyExtension on CryptoExtensions {

  SymmetricKeyHelper? get symmetricHelper => _symmetricHelper;
  set symmetricHelper(SymmetricKeyHelper? ext) => _symmetricHelper = ext;

}

/// PrivateKey extension
PrivateKeyHelper? _privateHelper;

extension PrivateKeyExtension on CryptoExtensions {

  PrivateKeyHelper? get privateHelper => _privateHelper;
  set privateHelper(PrivateKeyHelper? ext) => _privateHelper = ext;

}

/// PublicKey extension
PublicKeyHelper? _publicHelper;

extension PublicKeyExtension on CryptoExtensions {

  PublicKeyHelper? get publicHelper => _publicHelper;
  set publicHelper(PublicKeyHelper? ext) => _publicHelper = ext;

}
