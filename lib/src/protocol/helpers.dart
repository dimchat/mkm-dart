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
import '../format/ted.dart';

import 'address.dart';
import 'document.dart';
import 'identifier.dart';
import 'meta.dart';

// -----------------------------------------------------------------------------
//  Account Helpers
// -----------------------------------------------------------------------------

/// Helper interface for address management in the account system.
///
/// Manages address factories and provides core functionality for:
/// - Parsing raw address data into strongly-typed [Address] instances
/// - Generating valid addresses from entity metadata ([Meta])
///
/// Addresses are unique identifiers for entities(user/group) in the network.
abstract interface class AddressHelper {

  void setAddressFactory(AddressFactory factory);
  AddressFactory? getAddressFactory();

  /// Parses a raw object into a strongly-typed [Address] instance.
  ///
  /// Converts arbitrary raw address data (string) into a valid
  /// Address object for consistent account identification.
  ///
  /// @param address - Raw address data to parse
  ///
  /// @return Parsed Address instance (null if parsing fails)
  Address? parseAddress(Object? address);

  /// Generates a valid [Address] from entity metadata and network identifier.
  ///
  /// Creates a cryptographically derived address based on the entity's metadata
  /// and target network (e.g., mainnet/testnet).
  ///
  /// @param meta - Entity metadata used to generate the address
  ///
  /// @param network - Optional network identifier (null for default network)
  ///
  /// @return Generated valid Address instance
  Address generateAddress(Meta meta, int? network);

}

/// Helper interface for ID management in the account system.
///
/// Manages ID factories and provides core functionality for:
/// - Parsing raw ID data into strongly-typed [ID] instances
/// - Creating/generating unique IDs for accounts/entities
///
/// IDs combine an address with optional name/terminal information to uniquely
/// identify users/devices in the network.
abstract interface class IDHelper {

  void setIDFactory(IDFactory factory);
  IDFactory? getIDFactory();

  /// Parses a raw object into a strongly-typed [ID] instance.
  ///
  /// Converts arbitrary raw ID data (string) into a valid
  /// ID object for consistent account identification.
  ///
  /// @param identifier - Raw ID data to parse
  ///
  /// @return Parsed ID instance (null if parsing fails)
  ID? parseID(Object? identifier);

  /// Creates a custom [ID] with specified parameters.
  ///
  /// Builds an ID from explicit components (name, address, terminal) rather than
  /// generating it from metadata.
  ///
  /// @param name - Optional display name for the ID
  ///
  /// @param address - Mandatory address component (core unique identifier)
  ///
  /// @param terminal - Optional terminal identifier (for device-specific IDs)
  ///
  /// @return Custom ID instance
  ID createID({
    String? name,
    required Address address, String? terminal
  });

  /// Generates a unique [ID] from entity metadata and network parameters.
  ///
  /// Creates a cryptographically derived ID based on the entity's metadata,
  /// network identifier, and optional terminal information (for device-specific IDs).
  ///
  /// @param meta - Entity metadata used to generate the ID
  ///
  /// @param network - Optional network identifier (null for default network)
  ///
  /// @param terminal - Optional terminal identifier (for device-specific IDs)
  ///
  /// @return Generated unique ID instance
  ID generateID(Meta meta, int? network, {String? terminal});

}

/// Helper interface for metadata (Meta) management in the account system.
///
/// Manages Meta factories (by type) and provides core functionality for:
/// - Creating/generating entity metadata (core account information)
/// - Parsing raw metadata data into strongly-typed [Meta] instances
///
/// Meta contains the core cryptographic identity of an entity (public key, type, etc.).
abstract interface class MetaHelper {

  void setMetaFactory(String type, MetaFactory factory);
  MetaFactory? getMetaFactory(String type);

  /// Creates custom entity metadata with specified parameters.
  ///
  /// Builds Meta from explicit components (type, public key, seed, fingerprint)
  /// rather than generating it from a private key.
  ///
  /// @param type - Metadata type (e.g., "user", "group")
  ///
  /// @param pKey - Public verification key (core cryptographic identity)
  ///
  /// @param seed - Optional seed value used to generate the fingerprint
  ///
  /// @param fingerprint - Optional cryptographic fingerprint of the metadata
  ///
  /// @return Custom Meta instance
  Meta createMeta(String type, VerifyKey pKey, {
    String? seed,
    TransportableData? fingerprint
  });

  /// Generates entity metadata from a private signing key.
  ///
  /// Creates cryptographically valid Meta by deriving the public key from the
  /// private signing key, with optional seed for reproducibility.
  ///
  /// @param type - Metadata type (e.g., "user", "group")
  ///
  /// @param sKey - Private signing key to derive the public key from
  ///
  /// @param seed - Optional seed value for generating the fingerprint
  ///
  /// @return Generated Meta instance
  Meta generateMeta(String type, SignKey sKey, {String? seed});

  /// Parses raw metadata data into a strongly-typed [Meta] instance.
  ///
  /// Converts arbitrary raw metadata data (map) into a valid
  /// Meta object for consistent entity identity management.
  ///
  /// @param meta - Raw metadata data to parse
  ///
  /// @return Parsed Meta instance (null if parsing fails)
  Meta? parseMeta(Object? meta);

}

/// Helper interface for document management in the account system.
///
/// Manages Document factories (by type) and provides core functionality for:
/// - Creating entity documents (extended account information)
/// - Parsing raw document data into strongly-typed [Document] instances
///
/// Documents (e.g., Visa, Bulletin) contain extended information about an entity
/// beyond core metadata (profile, group info, etc.).
abstract interface class DocumentHelper {

  void setDocumentFactory(String docType, DocumentFactory factory);
  DocumentFactory? getDocumentFactory(String docType);

  /// Creates a custom entity document with specified parameters.
  ///
  /// Builds a Document from explicit components (type, data, signature) for
  /// extended entity information.
  ///
  /// @param docType - Document type (e.g., "visa", "bulletin")
  ///
  /// @param data - Optional raw data content of the document
  ///
  /// @param signature - Optional cryptographic signature for document verification
  ///
  /// @return Custom Document instance
  Document createDocument(String docType, {
    String? data,
    TransportableData? signature
  });

  /// Parses raw document data into a strongly-typed [Document] instance.
  ///
  /// Converts arbitrary raw document data (map) into a valid
  /// Document object for consistent extended entity information management.
  ///
  /// @param doc - Raw document data to parse
  ///
  /// @return Parsed Document instance (null if parsing fails)
  Document? parseDocument(Object? doc);

}

// -----------------------------------------------------------------------------
//  Account Extension Manager
// -----------------------------------------------------------------------------

/// Core extension manager for account system operations.
///
/// Singleton class that centralizes access to account-related helpers (Address/ID/Meta/Document)
/// using Dart extensions for clean, modular access across the application.
final sharedAccountExtensions = AccountExtensions();

/// Singleton extension class for account system operations.
///
/// Provides a unified entry point for accessing all account-related helpers,
/// ensuring consistent management of account components (Address/ID/Meta/Document).
class AccountExtensions {
  factory AccountExtensions() => _instance;
  static final AccountExtensions _instance = AccountExtensions._internal();
  AccountExtensions._internal();

  //...
}

/// Address extension
AddressHelper? _addressHelper;

extension AddressExtension on AccountExtensions {

  AddressHelper? get addressHelper => _addressHelper;
  set addressHelper(AddressHelper? ext) => _addressHelper = ext;

}

/// ID extension
IDHelper? _idHelper;

extension IDExtension on AccountExtensions {

  IDHelper? get idHelper => _idHelper;
  set idHelper(IDHelper? ext) => _idHelper = ext;

}

/// Meta extension
MetaHelper? _metaHelper;

extension MetaExtension on AccountExtensions {

  MetaHelper? get metaHelper => _metaHelper;
  set metaHelper(MetaHelper? ext) => _metaHelper = ext;

}

/// Document extension
DocumentHelper? _docHelper;

extension DocumentExtension on AccountExtensions {

  DocumentHelper? get docHelper => _docHelper;
  set docHelper(DocumentHelper? ext) => _docHelper = ext;

}
