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
import '../crypto/ted.dart';
import '../type/mapper.dart';

import 'helpers.dart';


/// Interface for The Additional Information (TAI) of network entities.
///
/// TAI contains variable, updatable information for entities (complementary to
/// immutable [Meta] data). It supports digital signatures to ensure data integrity
/// and authenticity.
///
/// Key differences from [Meta]:
/// - [Meta]: Immutable core data (public key, fingerprint)
/// - TAI: Mutable additional data (may include encryption keys, profile info)
abstract interface class TAI {

  /// Validates the integrity of this TAI data.
  ///
  /// Returns: true if the signature matches the data and entity's public key,
  ///          false if signature is missing or invalid
  bool get isValid;

  // ------------------------------
  //  Signature Operations
  // ------------------------------

  /// Verifies the TAI signature against the entity's public key.
  ///
  /// [metaKey]: Public key from the entity's [Meta] data (meta.key)
  ///
  /// Returns: true if signature is valid (data hasn't been tampered with),
  ///          false otherwise
  bool verify(VerifyKey metaKey);

  /// Signs the TAI data with the entity's private key.
  ///
  /// Encodes all properties to a data string, signs it with the private key,
  /// and stores the signature for later verification.
  ///
  /// [sKey]: Private key matching the entity's [Meta] public key
  ///
  /// Returns: Signature as Uint8List if successful, null on error
  Uint8List? sign(SignKey sKey);

  // ------------------------------
  //  Property Management
  // ------------------------------

  /// Gets all properties stored in this TAI.
  ///
  /// Returns: Map of property names to values if valid, null if TAI is invalid
  Map? get properties;

  /// Retrieves a specific property value by name.
  ///
  /// [name]: Name of the property to retrieve
  ///
  /// Returns: Value of the property (may be null if property doesn't exist)
  dynamic getProperty(String name);

  /// Updates or adds a property (resets signature).
  ///
  /// Modifying properties invalidates the existing signature (both [isValid]
  /// and the stored signature will be reset). A new signature must be generated
  /// with [sign()] after making changes.
  ///
  /// [name]: Name of the property to update/add
  ///
  /// [value]: New value for the property (may be null to remove)
  void setProperty(String name, Object? value);

}


/// Interface for entity profile documents (extends [TAI] with structured data).
///
/// Documents are specialized TAI implementations for standardized entity profiles
/// (e.g., user visas, group bulletins) with consistent serialization format.
/// Implements [TAI] for signature validation and [Mapper] for structured serialization.
///
/// Serialized format (Map/JSON):
/// ```json
/// {
///   "did"       : "{EntityID}",      // Unique identifier of the entity (ID string)
///   "type"      : "visa",            // "bulletin", ...
///   "data"      : "{JSON}",          // data = json_encode(info)
///   "signature" : "{BASE64_ENCODE}"  // signature = sign(data, SK);
/// }
/// ```
abstract interface class Document implements TAI, Mapper {

  // /// Unique identifier of the entity this document belongs to.
  // ID get identifier;

  //---- properties getter/setter

  /// Timestamp when the document was signed.
  ///
  /// Returns: [DateTime] of the signature creation, null if not signed
  DateTime? get time;

  // /// Display name of the entity (from properties).
  // String? get name;
  // set name(String? value);

  //
  //  Conveniences
  //

  static List<Document> convert(Iterable array) {
    List<Document> documents = [];
    Document? doc;
    for (var item in array) {
      doc = parse(item);
      if (doc == null) {
        continue;
      }
      documents.add(doc);
    }
    return documents;
  }

  static List<Map> revert(Iterable<Document> documents) {
    List<Map> array = [];
    for (Document doc in documents) {
      array.add(doc.toMap());
    }
    return array;
  }

  //
  //  Factory methods
  //

  /// 1. Create from stored info
  /// 2. Create new empty document
  static Document create(String type, {String? data, TransportableData? signature}) {
    var ext = AccountExtensions();
    return ext.docHelper!.createDocument(type, data: data, signature: signature);
  }

  static Document? parse(Object? doc) {
    var ext = AccountExtensions();
    return ext.docHelper!.parseDocument(doc);
  }

  static DocumentFactory? getFactory(String type) {
    var ext = AccountExtensions();
    return ext.docHelper!.getDocumentFactory(type);
  }
  static void setFactory(String type, DocumentFactory factory) {
    var ext = AccountExtensions();
    ext.docHelper!.setDocumentFactory(type, factory);
  }
}

/// Factory interface for creating and parsing [Document] instances.
///
/// Provides methods to create new documents (empty or from existing data)
/// and parse serialized documents from structured data.
abstract interface class DocumentFactory {

  /// Creates a [Document] instance from data and signature.
  ///
  /// Two common use cases:
  /// 1. Load existing document: Provide [data] and [signature] from storage
  /// 2. Create new empty document: Omit [data] and [signature]
  ///
  /// [data]: Optional encoded document data (JSON string)
  ///
  /// [signature]: Optional signature of the data (Base64-encoded as [TransportableData])
  ///
  /// Returns: New [Document] instance
  Document createDocument({String? data, TransportableData? signature});

  /// Parses a serialized Map into a [Document] instance.
  ///
  /// [doc]: Serialized document in the Map format defined in [Document]
  ///
  /// Returns: [Document] instance if parsing succeeds, null otherwise
  Document? parseDocument(Map doc);
}
