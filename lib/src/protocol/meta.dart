/* license: https://mit-license.org
 *
 *  Ming-Ke-Ming : Decentralized User Identity Authentication
 *
 *                                Written in 2023 by Moky <albert.moky@gmail.com>
 *
 * ==============================================================================
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
 * ==============================================================================
 */
import 'dart:typed_data';

import '../crypto/keys.dart';
import '../factory.dart';
import '../type/mapper.dart';
import 'address.dart';
import 'identifier.dart';

///  User/Group Meta data
///  ~~~~~~~~~~~~~~~~~~~~
///  This class is used to generate entity meta
///
///      data format: {
///          type: 1,             // algorithm version
///          seed: "moKy",        // user/group name
///          key: "{public key}", // PK = secp256k1(SK);
///          fingerprint: "..."   // CT = sign(seed, SK);
///      }
///
///      algorithm:
///          fingerprint = sign(seed, SK);
abstract class Meta implements Mapper {

  ///  Meta algorithm version
  ///
  ///      0x01 - username@address
  ///      0x02 - btc_address
  ///      0x03 - username@btc_address
  ///      0x04 - eth_address
  ///      0x05 - username@eth_address
  int get type;

  ///  Public key (used for signature)
  ///
  ///      RSA / ECC
  VerifyKey get key;

  ///  Seed to generate fingerprint
  ///
  ///      Username / Group-X
  String? get seed;

  ///  Fingerprint to verify ID and public key
  ///
  ///      Build: fingerprint = sign(seed, privateKey)
  ///      Check: verify(seed, fingerprint, publicKey)
  Uint8List? get fingerprint;

  ///  Generate address
  ///
  /// @param type - address type
  /// @return Address
  Address? generateAddress(int type);

  static bool check(Meta meta) {
    AccountFactoryManager man = AccountFactoryManager();
    return man.generalFactory.checkMeta(meta);
  }

  static bool matchID(ID identifier, Meta meta) {
    AccountFactoryManager man = AccountFactoryManager();
    return man.generalFactory.matchID(identifier, meta);
  }
  static bool matchKey(VerifyKey pKey, Meta meta) {
    AccountFactoryManager man = AccountFactoryManager();
    return man.generalFactory.matchKey(pKey, meta);
  }

  //
  //  Factory methods
  //

  static Meta? create(int version, VerifyKey pKey,
      {String? seed, Uint8List? fingerprint}) {
    AccountFactoryManager man = AccountFactoryManager();
    return man.generalFactory.createMeta(version, pKey,
        seed: seed, fingerprint: fingerprint);
  }

  static Meta? generate(int version, SignKey sKey, {String? seed}) {
    AccountFactoryManager man = AccountFactoryManager();
    return man.generalFactory.generateMeta(version, sKey, seed: seed);
  }

  static Meta? parse(Object? meta) {
    AccountFactoryManager man = AccountFactoryManager();
    return man.generalFactory.parseMeta(meta);
  }

  static MetaFactory? getFactory(int version) {
    AccountFactoryManager man = AccountFactoryManager();
    return man.generalFactory.getMetaFactory(version);
  }
  static void setFactory(int version, MetaFactory? factory) {
    AccountFactoryManager man = AccountFactoryManager();
    man.generalFactory.setMetaFactory(version, factory);
  }
}

///  Meta Factory
///  ~~~~~~~~~~~~
abstract class MetaFactory {

  ///  Create meta
  ///
  /// @param key         - public key
  /// @param seed        - ID.name
  /// @param fingerprint - sKey.sign(seed)
  /// @return Meta
  Meta createMeta(VerifyKey pKey, {String? seed, Uint8List? fingerprint});

  ///  Generate meta
  ///
  /// @param sKey    - private key
  /// @param seed    - ID.name
  /// @return Meta
  Meta generateMeta(SignKey sKey, {String? seed});

  ///  Parse map object to meta
  ///
  /// @param meta - meta info
  /// @return Meta
  Meta? parseMeta(Map meta);
}
