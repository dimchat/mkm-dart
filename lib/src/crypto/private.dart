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
import 'public.dart';

///  Asymmetric Cryptography Private Key
///  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
///  This class is used to decrypt symmetric key or sign message data
///
///  key data format: {
///      algorithm : "RSA", // "ECC", ...
///      data      : "{BASE64_ENCODE}",
///      ...
///  }
abstract interface class PrivateKey implements SignKey {

  ///  Get public key from private key
  ///
  /// @return public key paired to this private key
  PublicKey get publicKey;

  //
  //  Factory methods
  //

  static PrivateKey? generate(String algorithm) {
    var ext = CryptoExtensions();
    return ext.privateHelper!.generatePrivateKey(algorithm);
  }

  static PrivateKey? parse(Object? key) {
    var ext = CryptoExtensions();
    return ext.privateHelper!.parsePrivateKey(key);
  }

  static PrivateKeyFactory? getFactory(String algorithm) {
    var ext = CryptoExtensions();
    return ext.privateHelper!.getPrivateKeyFactory(algorithm);
  }
  static void setFactory(String algorithm, PrivateKeyFactory factory) {
    var ext = CryptoExtensions();
    ext.privateHelper!.setPrivateKeyFactory(algorithm, factory);
  }
}

///  Key Factory
///  ~~~~~~~~~~~
abstract interface class PrivateKeyFactory {

  ///  Generate key
  ///
  /// @return PrivateKey
  PrivateKey generatePrivateKey();

  ///  Parse map object to key
  ///
  /// @param key - key info
  /// @return PrivateKey
  PrivateKey? parsePrivateKey(Map key);
}
