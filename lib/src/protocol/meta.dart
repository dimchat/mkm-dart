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

/// Interface for immutable metadata of network entities (users/groups).
///
/// Meta data contains core, unchanging information used to validate entities
/// and generate their addresses/IDs. It implements [Mapper] for serialization
/// to/from structured formats (Map/JSON).
///
/// Serialized format (Map/JSON):
/// ```json
/// {
///   "type"        : "1",             // Algorithm version
///   "key"         : "{public key}",  // Public key: PK = secp256k1(SK)
///   "seed"        : "moKy",          // Entity name (seed for fingerprint)
///   "fingerprint" : "..."            // Signature of seed: CT = sign(seed, SK)
/// }
/// ```
///
/// Core algorithm:
/// - Fingerprint = sign(seed, private key)
/// - Used to verify the authenticity of the entity's name and public key
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

  // -----------------------------------
  //  Validation & Address Generation
  // -----------------------------------

  /// Validates the integrity of this metadata.
  ///
  /// **Important**: Must be called when receiving new metadata from the network
  /// to verify the fingerprint matches the seed and public key.
  ///
  /// Returns: true if fingerprint is valid (signature matches seed and public key),
  ///          false otherwise (invalid or tampered metadata)
  bool get isValid;

  /// Generates an [Address] from this metadata for the specified network.
  ///
  /// [network]: Target network identifier (type)
  ///
  /// Returns: New [Address] instance derived from this metadata
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

/// Factory interface for creating and parsing [Meta] instances.
///
/// Provides methods to create metadata from raw components, generate valid
/// metadata (with proper fingerprint), and parse serialized metadata.
abstract interface class MetaFactory {

  /// Creates a [Meta] instance from explicit components.
  ///
  /// [pKey]: Public key for the entity
  ///
  /// [seed]: Optional seed/entity name (used for fingerprint)
  ///
  /// [fingerprint]: Optional pre-generated fingerprint (signature of seed)
  ///
  /// Returns: New [Meta] instance (validation via [Meta.isValid] recommended)
  Meta createMeta(VerifyKey pKey, {String? seed, TransportableData? fingerprint});

  /// Generates a valid [Meta] instance with a proper fingerprint.
  ///
  /// Automatically creates a valid fingerprint by signing the seed with the
  /// private key, ensuring [Meta.isValid] returns true.
  ///
  /// [sKey]: Private key to sign the seed (generates fingerprint)
  ///
  /// [seed]: Optional seed/entity name (default: random or algorithm-specific)
  ///
  /// Returns: Valid [Meta] instance with verified fingerprint
  Meta generateMeta(SignKey sKey, {String? seed});

  /// Parses a serialized Map into a [Meta] instance.
  ///
  /// [meta]: Serialized metadata in the Map format defined in [Meta]
  ///
  /// Returns: [Meta] instance if parsing succeeds, null otherwise
  Meta? parseMeta(Map meta);
}
