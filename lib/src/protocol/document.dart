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
import '../format/encode.dart';
import '../type/mapper.dart';

import 'helpers.dart';
import 'identifier.dart';

///  The Additional Information
///
///      'Meta' is the information for entity which never changed,
///          which contains the key for verify signature;
///      'TAI' is the variable part,
///          which could contain a public key for asymmetric encryption.
abstract interface class TAI {

  ///  Check if signature matched
  ///
  /// @return false on signature not matched
  bool get isValid;

  ///  Verify 'data' and 'signature' with public key
  ///
  /// @param metaKey - public key in meta.key
  /// @return true on signature matched
  bool verify(VerifyKey metaKey);

  ///  Encode properties to 'data' and sign it to 'signature'
  ///
  /// @param sKey - private key match meta.key
  /// @return signature, null on error
  Uint8List? sign(SignKey sKey);

  //-------- properties

  ///  Get all properties
  ///
  /// @return properties, null on invalid
  Map? get properties;

  ///  Get property data with key
  ///
  /// @param name - property name
  /// @return property data
  dynamic getProperty(String name);

  ///  Update property with key and data
  ///  (this will reset 'data' and 'signature')
  ///
  /// @param name - property name
  /// @param value - property data
  void setProperty(String name, Object? value);
}

///  User/Group Profile
///  ~~~~~~~~~~~~~~~~~~
///  This class is used to generate entity profile
///
///      data format: {
///          did       : "{EntityID}",      // entity ID
///          type      : "visa",            // "bulletin", ...
///          data      : "{JSON}",          // data = json_encode(info)
///          signature : "{BASE64_ENCODE}"  // signature = sign(data, SK);
///      }
abstract interface class Document implements TAI, Mapper {

  ///  Get entity ID
  ///
  /// @return entity ID
  ID get identifier;

  ///  Get sign time
  ///
  /// @return date object or null
  DateTime? get time;

  ///  Get entity name
  ///
  /// @return name string
  String? get name;
  set name(String? value);

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
  static Document create(String type, ID identifier, {String? data, TransportableData? signature}) {
    var ext = AccountExtensions();
    return ext.docHelper!.createDocument(type, identifier, data: data, signature: signature);
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

///  Document Factory
///  ~~~~~~~~~~~~~~~~
abstract interface class DocumentFactory {

  ///  Create document with data & signature loaded from local storage
  ///  Create a new empty document with entity ID only
  ///
  /// @param identifier - entity ID
  /// @param data       - document data (JsON)
  /// @param signature  - document signature (Base64)
  /// @return Document
  Document createDocument(ID identifier, {String? data, TransportableData? signature});

  ///  Parse map object to entity document
  ///
  /// @param doc - info
  /// @return Document
  Document? parseDocument(Map doc);
}
