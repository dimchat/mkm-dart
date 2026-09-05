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

  /// Set the Address factory.
  void setAddressFactory(AddressFactory factory);

  /// Get the Address factory.
  AddressFactory? getAddressFactory();

  /// Parse a raw object into a strongly-typed [Address] instance.
  ///
  /// Converts arbitrary raw address data (string) into a valid
  /// Address object for consistent account identification.
  ///
  /// [address] is the raw address data to parse.
  ///
  /// Returns an [Address] instance if parsing succeeds, null otherwise.
  Address? parseAddress(Object? address);

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

  /// Set the ID factory.
  void setIDFactory(IDFactory factory);

  /// Get the ID factory.
  IDFactory? getIDFactory();

  /// Parse a raw object into a strongly-typed [ID] instance.
  ///
  /// Converts arbitrary raw ID data (string) into a valid
  /// ID object for consistent account identification.
  ///
  /// [identifier] is the raw ID data to parse.
  ///
  /// Returns an [ID] instance if parsing succeeds, null otherwise.
  ID? parseID(Object? identifier);

  /// Create a custom [ID] with specified parameters.
  ///
  /// Builds an ID from explicit components (name, address, terminal) rather than
  /// generating it from metadata.
  ///
  /// [name] is the entity name (optional).
  /// [address] is the address component of the entity (required).
  /// [terminal] is the terminal identifier for device-specific IDs (optional).
  ///
  /// Returns a new [ID] instance with the specified components.
  ID createID({
    String? name,
    required Address address, String? terminal
  });

}

/// Helper interface for metadata (Meta) management in the account system.
///
/// Manages Meta factories (by type) and provides core functionality for:
/// - Creating/generating entity metadata (core account information)
/// - Parsing raw metadata data into strongly-typed [Meta] instances
///
/// Meta contains the core cryptographic identity of an entity (public key, type, etc.).
abstract interface class MetaHelper {

  /// Set the Meta factory for the specified type.
  void setMetaFactory(String type, MetaFactory factory);

  /// Get the Meta factory for the specified type.
  MetaFactory? getMetaFactory(String type);

  /// Create custom entity metadata with specified parameters.
  ///
  /// Builds Meta from explicit components (type, public key, seed, fingerprint)
  /// rather than generating it from a private key.
  ///
  /// [type] is the metadata type (e.g., "user", "group").
  /// [pKey] is the public verification key (core cryptographic identity).
  /// [seed] is the optional seed value used to generate the fingerprint.
  /// [fingerprint] is the optional cryptographic fingerprint of the metadata.
  ///
  /// Returns a new [Meta] instance (validation via [Meta.isValid] recommended).
  Meta createMeta(String type, VerifyKey pKey, {
    String? seed,
    TransportableData? fingerprint
  });

  /// Generate entity metadata from a private signing key.
  ///
  /// Creates cryptographically valid Meta by deriving the public key from the
  /// private signing key, with optional seed for reproducibility.
  ///
  /// [type] is the metadata type (e.g., "user", "group").
  /// [sKey] is the private signing key to derive the public key from.
  /// [seed] is the optional seed value for generating the fingerprint.
  ///
  /// Returns a new [Meta] instance with a verified fingerprint.
  Meta generateMeta(String type, SignKey sKey, {String? seed});

  /// Parse raw metadata data into a strongly-typed [Meta] instance.
  ///
  /// Converts arbitrary raw metadata data (map) into a valid
  /// Meta object for consistent entity identity management.
  ///
  /// [meta] is the raw metadata data to parse.
  ///
  /// Returns a [Meta] instance if parsing succeeds, null otherwise.
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

  /// Set the Document factory for the specified type.
  void setDocumentFactory(String docType, DocumentFactory factory);

  /// Get the Document factory for the specified type.
  DocumentFactory? getDocumentFactory(String docType);

  /// Create a custom entity document with specified parameters.
  ///
  /// Builds a Document from explicit components (type, data, signature) for
  /// extended entity information.
  ///
  /// [docType] is the document type (e.g., "visa", "bulletin").
  /// [data] is the optional raw data content of the document.
  /// [signature] is the optional cryptographic signature for document verification.
  ///
  /// Returns a new [Document] instance.
  Document createDocument(String docType, {
    String? data,
    TransportableData? signature
  });

  /// Parse raw document data into a strongly-typed [Document] instance.
  ///
  /// Converts arbitrary raw document data (map) into a valid
  /// Document object for consistent extended entity information management.
  ///
  /// [doc] is the raw document data to parse.
  ///
  /// Returns a [Document] instance if parsing succeeds, null otherwise.
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
final class AccountExtensions {
  factory AccountExtensions() => _instance;
  static final AccountExtensions _instance = AccountExtensions._internal();
  AccountExtensions._internal();

  //...
}

/// Address extension
AddressHelper? _addressHelper;

extension AddressExtension on AccountExtensions {

  /// Get the address helper (null before set).
  AddressHelper? get addressHelper => _addressHelper;

  /// Set the address helper.
  set addressHelper(AddressHelper? ext) => _addressHelper = ext;

}

/// ID extension
IDHelper? _idHelper;

extension IDExtension on AccountExtensions {

  /// Get the ID helper (null before set).
  IDHelper? get idHelper => _idHelper;

  /// Set the ID helper.
  set idHelper(IDHelper? ext) => _idHelper = ext;

}

/// Meta extension
MetaHelper? _metaHelper;

extension MetaExtension on AccountExtensions {

  /// Get the Meta helper (null before set).
  MetaHelper? get metaHelper => _metaHelper;

  /// Set the Meta helper.
  set metaHelper(MetaHelper? ext) => _metaHelper = ext;

}

/// Document extension
DocumentHelper? _docHelper;

extension DocumentExtension on AccountExtensions {

  /// Get the document helper (null before set).
  DocumentHelper? get docHelper => _docHelper;

  /// Set the document helper.
  set docHelper(DocumentHelper? ext) => _docHelper = ext;

}
