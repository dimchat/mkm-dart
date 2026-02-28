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
import '../crypto/keys.dart';
import '../crypto/ted.dart';
import '../type/mapper.dart';

import 'address.dart';
import 'helpers.dart';

///  User/Group Meta data
///  ~~~~~~~~~~~~~~~~~~~~
///  This class is used to generate entity meta
///
///      data format: {
///          "type"        : i2s(1),         // algorithm version
///          "key"         : "{public key}", // PK = secp256k1(SK);
///          "seed"        : "moKy",         // user/group name
///          "fingerprint" : "..."           // CT = sign(seed, SK);
///      }
///
///      algorithm:
///          fingerprint = sign(seed, SK);
abstract interface class Meta implements Mapper {

  ///  Meta algorithm version
  ///
  ///      1 = MKM : username@address (default)
  ///      2 = BTC : btc_address
  ///      4 = ETH : eth_address
  ///      ...
  String get type;

  ///  Public key (used for signature)
  ///
  ///      RSA / ECC
  VerifyKey get publicKey;

  ///  Seed to generate fingerprint
  ///
  ///      Username / Group-X
  String? get seed;

  ///  Fingerprint to verify ID and public key
  ///
  ///      Build: fingerprint = sign(seed, privateKey)
  ///      Check: verify(seed, fingerprint, publicKey)
  TransportableData? get fingerprint;

  //
  //  Validation
  //

  ///  Check meta valid
  ///  (must call this when received a new meta from network)
  ///
  /// @return false on fingerprint not matched
  bool get isValid;

  ///  Generate address
  ///
  /// @param network - address type
  /// @return Address
  Address generateAddress(int? network);

  //
  //  Factory methods
  //

  /// Create from stored info
  static Meta create(String type, VerifyKey pKey, {String? seed, TransportableData? fingerprint}) {
    var ext = AccountExtensions();
    return ext.metaHelper!.createMeta(type, pKey, seed: seed, fingerprint: fingerprint);
  }

  /// Generate with private key
  static Meta generate(String type, SignKey sKey, {String? seed}) {
    var ext = AccountExtensions();
    return ext.metaHelper!.generateMeta(type, sKey, seed: seed);
  }

  static Meta? parse(Object? meta) {
    var ext = AccountExtensions();
    return ext.metaHelper!.parseMeta(meta);
  }

  static MetaFactory? getFactory(String type) {
    var ext = AccountExtensions();
    return ext.metaHelper!.getMetaFactory(type);
  }
  static void setFactory(String type, MetaFactory factory) {
    var ext = AccountExtensions();
    ext.metaHelper!.setMetaFactory(type, factory);
  }
}

///  Meta Factory
///  ~~~~~~~~~~~~
abstract interface class MetaFactory {

  ///  Create meta
  ///
  /// @param key         - public key
  /// @param seed        - ID.name
  /// @param fingerprint - sKey.sign(seed)
  /// @return Meta
  Meta createMeta(VerifyKey pKey, {String? seed, TransportableData? fingerprint});

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
