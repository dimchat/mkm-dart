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
import 'keys.dart';
import 'manager.dart';

///  Asymmetric Cryptography Public Key
///  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
///
///  key data format: {
///      algorithm : "RSA", // "ECC", ...
///      data      : "{BASE64_ENCODE}",
///      ...
///  }
abstract class PublicKey implements VerifyKey {

  //
  //  Factory methods
  //

  static PublicKey? parse(Object? key) {
    CryptographyKeyFactoryManager man = CryptographyKeyFactoryManager();
    return man.generalFactory.parsePublicKey(key);
  }

  PublicKeyFactory? getFactory(String algorithm) {
    CryptographyKeyFactoryManager man = CryptographyKeyFactoryManager();
    return man.generalFactory.getPublicKeyFactory(algorithm);
  }
  void setFactory(String algorithm, PublicKeyFactory? factory) {
    CryptographyKeyFactoryManager man = CryptographyKeyFactoryManager();
    man.generalFactory.setPublicKeyFactory(algorithm, factory);
  }
}

///  Key Factory
///  ~~~~~~~~~~~
abstract class PublicKeyFactory {

  ///  Parse map object to key
  ///
  /// @param key - key info
  /// @return PublicKey
  PublicKey parsePublicKey(Map key);
}
