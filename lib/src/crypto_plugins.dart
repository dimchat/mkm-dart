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

/// CryptographyKey GeneralFactory
/// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
abstract interface class GeneralCryptoHelper /*
    implements SymmetricKeyHelper, PrivateKeyHelper, PublicKeyHelper */{

  /// sample data for checking keys
  // ignore: non_constant_identifier_names
  static final Uint8List PROMISE = Uint8List.fromList(
      'Moky loves May Lee forever!'.codeUnits
  );

  /// Compare asymmetric keys
  static bool matchAsymmetricKeys(SignKey sKey, VerifyKey pKey) {
    // verify with signature
    Uint8List signature = sKey.sign(PROMISE);
    return pKey.verify(PROMISE, signature);
  }

  /// Compare symmetric keys
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

  String? getKeyAlgorithm(Map key, String? defaultValue);

}

/// CryptographyKey FactoryManager
/// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
class SharedCryptoExtensions {
  factory SharedCryptoExtensions() => _instance;
  static final SharedCryptoExtensions _instance = SharedCryptoExtensions._internal();
  SharedCryptoExtensions._internal();

  /// Symmetric Key
  SymmetricKeyHelper? get symmetricHelper =>
      CryptoExtensions().symmetricHelper;

  set symmetricHelper(SymmetricKeyHelper? helper) =>
      CryptoExtensions().symmetricHelper = helper;

  /// Private Key
  PrivateKeyHelper? get privateHelper =>
      CryptoExtensions().privateHelper;

  set privateHelper(PrivateKeyHelper? helper) =>
      CryptoExtensions().privateHelper = helper;

  /// Public Key
  PublicKeyHelper? get publicHelper =>
      CryptoExtensions().publicHelper;

  set publicHelper(PublicKeyHelper? helper) =>
      CryptoExtensions().publicHelper = helper;

  /// General Helper
  GeneralCryptoHelper? helper;

}
