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

import '../type/mapper.dart';

import 'ted.dart';


/// Base interface for cryptographic keys with algorithm identification.
///
/// Represents a cryptographic key associated with a specific algorithm,
/// supporting serialization to/from a structured format.
///
/// Key data format (Map/JSON):
/// ```json
/// {
///   "algorithm" : "RSA",  // "ECC", "AES", "DES", ...
///   "data"      : "{BASE64_ENCODE}",
///   // ...
/// }
/// ```
abstract interface class CryptographyKey implements Mapper {

  /// Name of the cryptographic algorithm associated with this key.
  ///
  /// Examples: "RSA", "ECC", "AES", "DES", ...
  String get algorithm;

  /// Encoded key material (transportable data).
  ///
  /// Key data is wrapped in [TransportableData] for standardized encoding/transmission.
  TransportableData get data;
}

/// Interface for encryption keys (symmetric or asymmetric public keys).
///
/// Used to encrypt plaintext data into ciphertext:
/// - Symmetric key: Same key used for encryption/decryption (e.g., AES)
/// - Asymmetric public key: Paired with private key for decryption (e.g., RSA public key)
abstract interface class EncryptKey implements CryptographyKey {

  //  1. Symmetric Key:
  //     ciphertext = encrypt(plaintext, PW)
  //  2. Asymmetric Public Key:
  //     ciphertext = encrypt(plaintext, PK)

  /// Encrypts plaintext data using this key.
  ///
  /// [plaintext]: Raw binary data to encrypt
  ///
  /// [extra]: Optional algorithm-specific parameters (e.g., "IV" for AES)
  ///
  /// Returns: Encrypted ciphertext as Uint8List
  Uint8List encrypt(Uint8List plaintext, [Map? extra]);
}

/// Interface for decryption keys (symmetric or asymmetric private keys).
///
/// Used to decrypt ciphertext back to plaintext:
/// - Symmetric key: Same key used for encryption/decryption (e.g., AES)
/// - Asymmetric private key: Paired with public key (e.g., RSA private key)
abstract interface class DecryptKey implements CryptographyKey {

  //  1. Symmetric Key:
  //     plaintext = decrypt(ciphertext, PW);
  //  2. Asymmetric Private Key:
  //     plaintext = decrypt(ciphertext, SK);

  /// Decrypts ciphertext data using this key.
  ///
  /// [ciphertext]: Encrypted binary data to decrypt
  ///
  /// [params]: Optional algorithm-specific parameters (e.g., "IV" for AES)
  ///
  /// Returns: Decrypted plaintext as Uint8List, or null if decryption fails
  Uint8List? decrypt(Uint8List ciphertext, [Map? params]);

  //  OK = decrypt(encrypt(data, PK), SK) == data

  /// Verifies if this decryption key matches the given encryption key.
  ///
  /// Validation logic: decrypt(encrypt(data, PK), SK) == original data
  ///
  /// [pKey]: Encryption key (public/symmetric) to verify against
  ///
  /// Returns: true if keys form a valid pair (encryption/decryption works)
  bool matchEncryptKey(EncryptKey pKey);
}

/// Base interface for asymmetric cryptographic keys (public/private key pairs).
///
/// Asymmetric keys use different keys for encryption/decryption or signing/verification.
///
/// Common asymmetric algorithms:
/// - RSA: Rivest-Shamir-Adleman (supports "RSA/ECB/PKCS1Padding", "SHA256withRSA")
/// - ECC: Elliptic Curve Cryptography
abstract interface class AsymmetricKey implements CryptographyKey {

  // static const String RSA = 'RSA';  //-- "RSA/ECB/PKCS1Padding", "SHA256withRSA"
  // static const String ECC = 'ECC';

}

/// Interface for private signing keys (asymmetric).
///
/// Used to generate digital signatures for data integrity and authenticity verification.
abstract interface class SignKey implements AsymmetricKey {

  //  signature = sign(data, SK);

  /// Generates a digital signature for the given data.
  ///
  /// [data]: Binary data to sign
  ///
  /// Returns: Digital signature as Uint8List
  Uint8List sign(Uint8List data);
}

/// Interface for public verification keys (asymmetric).
///
/// Used to verify digital signatures generated by a corresponding [SignKey].
abstract interface class VerifyKey implements AsymmetricKey {

  //  OK = verify(data, signature, PK)

  /// Verifies if a signature is valid for the given data.
  ///
  /// [data]: Original data that was signed
  ///
  /// [signature]: Digital signature to verify
  ///
  /// Returns: true if signature is valid (matches data and key)
  bool verify(Uint8List data, Uint8List signature);

  /// Verifies if this verification key matches the given signing key.
  ///
  /// Validation logic: verify(data, sign(data, SK), PK) == true
  ///
  /// [sKey]: Signing key (private) to verify against
  ///
  /// Returns: true if keys form a valid signing/verification pair
  bool matchSignKey(SignKey sKey);
}
