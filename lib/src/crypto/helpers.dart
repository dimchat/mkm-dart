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

///  General Helpers
///  ~~~~~~~~~~~~~~~

abstract interface class SymmetricKeyHelper {

  void setSymmetricKeyFactory(String algorithm, SymmetricKeyFactory factory);
  SymmetricKeyFactory? getSymmetricKeyFactory(String algorithm);

  SymmetricKey? generateSymmetricKey(String algorithm);

  SymmetricKey? parseSymmetricKey(Object? key);

}

abstract interface class PublicKeyHelper {

  void setPublicKeyFactory(String algorithm, PublicKeyFactory factory);
  PublicKeyFactory? getPublicKeyFactory(String algorithm);

  PublicKey? parsePublicKey(Object? key);

}

abstract interface class PrivateKeyHelper {

  void setPrivateKeyFactory(String algorithm, PrivateKeyFactory factory);
  PrivateKeyFactory? getPrivateKeyFactory(String algorithm);

  PrivateKey? generatePrivateKey(String algorithm);

  PrivateKey? parsePrivateKey(Object? key);

}

/// CryptographyKey FactoryManager
/// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// protected
class CryptoExtensions {
  factory CryptoExtensions() => _instance;
  static final CryptoExtensions _instance = CryptoExtensions._internal();
  CryptoExtensions._internal();

  SymmetricKeyHelper? symmetricHelper;

  PrivateKeyHelper? privateHelper;
  PublicKeyHelper? publicHelper;

}
