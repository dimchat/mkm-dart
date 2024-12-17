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

///  Cryptography Key
///  ~~~~~~~~~~~~~~~~
///  Cryptography key with designated algorithm
///
///  key data format: {
///      algorithm : "RSA", // ECC, AES, ...
///      data      : "{BASE64_ENCODE}",
///      ...
///  }
abstract interface class CryptographyKey implements Mapper {

  ///  Get key algorithm name
  ///
  /// @return algorithm name
  String get algorithm;

  ///  Get key data
  ///
  /// @return key data
  Uint8List get data;
}

abstract interface class EncryptKey implements CryptographyKey {

  ///  1. Symmetric Key:
  ///     ciphertext = encrypt(plaintext, PW)
  ///  2. Asymmetric Public Key:
  ///     ciphertext = encrypt(plaintext, PK)
  ///
  /// @param plaintext - plain data
  /// @param extra     - store extra variables ('IV' for 'AES')
  /// @return ciphertext
  Uint8List encrypt(Uint8List plaintext, Map? extra);
}

abstract interface class DecryptKey implements CryptographyKey {

  ///  1. Symmetric Key:
  ///     plaintext = decrypt(ciphertext, PW);
  ///  2. Asymmetric Private Key:
  ///     plaintext = decrypt(ciphertext, SK);
  ///
  /// @param ciphertext - encrypted data
  /// @param params     - extra params ('IV' for 'AES')
  /// @return plaintext
  Uint8List? decrypt(Uint8List ciphertext, Map? params);

  ///  OK = decrypt(encrypt(data, PK), SK) == data
  ///
  /// @param pKey - encrypt (public) key
  /// @return true on encryption matched
  bool matchEncryptKey(EncryptKey pKey);
}

abstract interface class AsymmetricKey implements CryptographyKey {
  // ignore_for_file: constant_identifier_names

  static const String RSA = 'RSA';  //-- "RSA/ECB/PKCS1Padding", "SHA256withRSA"
  static const String ECC = 'ECC';

}

abstract interface class SignKey implements AsymmetricKey {

  ///  signature = sign(data, SK);
  ///
  /// @param data - data to be signed
  /// @return signature
  Uint8List sign(Uint8List data);
}

abstract interface class VerifyKey implements AsymmetricKey {

  ///  OK = verify(data, signature, PK)
  ///
  /// @param data - data
  /// @param signature - signature of data
  /// @return true on signature matched
  bool verify(Uint8List data, Uint8List signature);

  ///  OK = verify(data, sign(data, SK), PK)
  ///
  /// @param sKey - private key
  /// @return true on signature matched
  bool matchSignKey(SignKey sKey);
}
