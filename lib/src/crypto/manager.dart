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

import '../type/wrapper.dart';
import 'keys.dart';
import 'private.dart';
import 'public.dart';
import 'symmetric.dart';

// sample data for checking keys
final Uint8List _promise = Uint8List.fromList('Moky loves May Lee forever!'.codeUnits);

class CryptographyKeyFactoryManager {
  factory CryptographyKeyFactoryManager() => _instance;
  static final CryptographyKeyFactoryManager _instance = CryptographyKeyFactoryManager._internal();
  CryptographyKeyFactoryManager._internal();

  CryptographyKeyGeneralFactory generalFactory = CryptographyKeyGeneralFactory();
}

class CryptographyKeyGeneralFactory {

  final Map<String, SymmetricKeyFactory> _symmetricKeyFactories = {};
  final Map<String, PublicKeyFactory>       _publicKeyFactories = {};
  final Map<String, PrivateKeyFactory>     _privateKeyFactories = {};

  bool matchAsymmetricKeys(SignKey sKey, VerifyKey pKey) {
    // verify with signature
    Uint8List signature = sKey.sign(_promise);
    return pKey.verify(_promise, signature);
  }

  bool matchSymmetricKeys(EncryptKey pKey, DecryptKey sKey) {
    // check by encryption
    Uint8List ciphertext = pKey.encrypt(_promise);
    Uint8List? plaintext = sKey.decrypt(ciphertext);
    // check result
    return plaintext != null && Wrapper.listEquals(plaintext, _promise);
  }

  String? getAlgorithm(Map key) {
    return key['algorithm'];
  }

  ///
  ///   SymmetricKey
  ///

  void setSymmetricKeyFactory(String algorithm, SymmetricKeyFactory factory) {
    _symmetricKeyFactories[algorithm] = factory;
  }
  SymmetricKeyFactory? getSymmetricKeyFactory(String algorithm) {
    return _symmetricKeyFactories[algorithm];
  }

  SymmetricKey? generateSymmetricKey(String algorithm) {
    SymmetricKeyFactory? factory = getSymmetricKeyFactory(algorithm);
    assert(factory != null, 'key algorithm not support: $algorithm');
    return factory?.generateSymmetricKey();
  }

  SymmetricKey? parseSymmetricKey(Object? key) {
    if (key == null) {
      return null;
    } else if (key is SymmetricKey) {
      return key;
    }
    Map? info = Wrapper.getMap(key);
    if (info == null) {
      assert(false, 'key error: $key');
      return null;
    }
    String? algorithm = getAlgorithm(info);
    algorithm ??= '*';
    SymmetricKeyFactory? factory = getSymmetricKeyFactory(algorithm);
    if (factory == null && algorithm != '*') {
      factory = getSymmetricKeyFactory('*');  // unknown
    }
    assert(factory != null, 'cannot parse key: $key');
    return factory?.parseSymmetricKey(info);
  }

  ///
  ///   PublicKey
  ///

  void setPublicKeyFactory(String algorithm, PublicKeyFactory factory) {
    _publicKeyFactories[algorithm] = factory;
  }
  PublicKeyFactory? getPublicKeyFactory(String algorithm) {
    return _publicKeyFactories[algorithm];
  }

  PublicKey? parsePublicKey(Object? key) {
    if (key == null) {
      return null;
    } else if (key is PublicKey) {
      return key;
    }
    Map? info = Wrapper.getMap(key);
    if (info == null) {
      assert(false, 'key error: $key');
      return null;
    }
    String? algorithm = getAlgorithm(info);
    algorithm ??= '*';
    PublicKeyFactory? factory = getPublicKeyFactory(algorithm);
    if (factory == null && algorithm != '*') {
      factory = getPublicKeyFactory('*');  // unknown
    }
    assert(factory != null, 'cannot parse key: $key');
    return factory?.parsePublicKey(info);
  }

  ///
  ///   PrivateKey
  ///

  void setPrivateKeyFactory(String algorithm, PrivateKeyFactory factory) {
    _privateKeyFactories[algorithm] = factory;
  }
  PrivateKeyFactory? getPrivateKeyFactory(String algorithm) {
    return _privateKeyFactories[algorithm];
  }

  PrivateKey? generatePrivateKey(String algorithm) {
    PrivateKeyFactory? factory = getPrivateKeyFactory(algorithm);
    assert(factory != null, 'key algorithm not support: $algorithm');
    return factory?.generatePrivateKey();
  }

  PrivateKey? parsePrivateKey(Object? key) {
    if (key == null) {
      return null;
    } else if (key is PrivateKey) {
      return key;
    }
    Map? info = Wrapper.getMap(key);
    if (info == null) {
      assert(false, 'key error: $key');
      return null;
    }
    String? algorithm = getAlgorithm(info);
    algorithm ??= '*';
    PrivateKeyFactory? factory = getPrivateKeyFactory(algorithm);
    if (factory == null && algorithm != '*') {
      factory = getPrivateKeyFactory('*');  // unknown
    }
    assert(factory != null, 'cannot parse key: $key');
    return factory?.parsePrivateKey(info);
  }
}
