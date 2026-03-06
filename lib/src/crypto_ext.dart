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

import 'crypto/helpers.dart';
import 'crypto/keys.dart';
import 'type/comparator.dart';

// -----------------------------------------------------------------------------
//  General Cryptographic Helpers
// -----------------------------------------------------------------------------

/// General cryptographic helper interface for key validation and algorithm handling.
///
/// Combines common crypto utilities (key matching, algorithm detection) and provides
/// static methods for verifying key pairs (symmetric/asymmetric).
abstract interface class GeneralCryptoHelper /*
    implements SymmetricKeyHelper, PrivateKeyHelper, PublicKeyHelper */{

  /// sample data for checking keys
  // ignore: non_constant_identifier_names
  static final Uint8List PROMISE = Uint8List.fromList(
      'Moky loves May Lee forever!'.codeUnits
  );

  /// Verifies that an asymmetric key pair (sign/verify) are a matching pair.
  ///
  /// Tests if the private (signing) key can sign the [PROMISE] data, and the public
  /// (verification) key can successfully verify that signature.
  ///
  /// @param sKey - Private/signing key to test
  ///
  /// @param pKey - Public/verification key to test
  ///
  /// @return True if keys are a valid matching pair, false otherwise
  static bool matchAsymmetricKeys(SignKey sKey, VerifyKey pKey) {
    // verify with signature
    Uint8List signature = sKey.sign(PROMISE);
    return pKey.verify(PROMISE, signature);
  }

  /// Verifies that symmetric keys (encrypt/decrypt) are a matching pair.
  ///
  /// Tests if the encryption key can encrypt the [PROMISE] data, and the decryption
  /// key can successfully decrypt it back to the original data.
  ///
  /// @param encKey - Encryption key to test
  ///
  /// @param decKey - Decryption key to test
  ///
  /// @return True if keys are a valid matching pair, false otherwise
  static bool matchSymmetricKeys(EncryptKey encKey, DecryptKey decKey) {
    // check by encryption
    Map params = {};
    Uint8List ciphertext = encKey.encrypt(PROMISE, params);
    Uint8List? plaintext = decKey.decrypt(ciphertext, params);
    return plaintext != null && Arrays.equals(plaintext, PROMISE);
  }

  //
  //  Algorithm
  //

  /// Extracts the algorithm name from a key's metadata map.
  ///
  /// Retrieves the algorithm identifier (e.g., "AES", "RSA") from a key's raw map
  /// representation, with a fallback default value if not found.
  ///
  /// @param key - Raw key map containing algorithm metadata
  ///
  /// @param defaultValue - Fallback value if algorithm is not found
  ///
  /// @return Extracted algorithm name (or defaultValue if not present)
  String? getKeyAlgorithm(Map key, [String? defaultValue]);

}

/// General Extensions
/// ~~~~~~~~~~~~~~~~~~

GeneralCryptoHelper? _cryptoHelper;

extension GeneralCryptoExtension on CryptoExtensions {

  GeneralCryptoHelper? get helper => _cryptoHelper;
  set helper(GeneralCryptoHelper? ext) => _cryptoHelper = ext;

}
