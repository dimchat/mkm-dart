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
import 'identifier.dart';

///  The Additional Information
///
///      'Meta' is the information for entity which never changed,
///          which contains the key for verify signature;
///      'TAI' is the variable part,
///          which could contain a public key for asymmetric encryption.
abstract class TAI {

  ///  Check if signature matched
  ///
  /// @return False on signature not matched
  bool get isValid;

  ///  Verify 'data' and 'signature' with public key
  ///
  /// @param publicKey - public key in meta.key
  /// @return true on signature matched
  bool verify(VerifyKey publicKey);

  ///  Encode properties to 'data' and sign it to 'signature'
  ///
  /// @param privateKey - private key match meta.key
  /// @return signature, null on error
  Uint8List sign(SignKey privateKey);

  ///  Get all properties
  ///
  /// @return properties
  Map<String, dynamic> get properties;

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
///          ID: "EntityID",   // entity ID
///          data: "{JSON}",   // data = json_encode(info)
///          signature: "..."  // signature = sign(data, SK);
///      }
abstract class Document implements TAI {

  //
  //  Document types
  //
  static const String kVisa     = 'visa';      // for login/communication
  static const String kProfile  = 'profile';   // for user info
  static const String kBulletin = 'bulletin';  // for group info

  ///  Get document type
  ///
  /// @return document type
  String? get type;

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
  //  Factory methods
  //

  static Document? create(String type, ID identifier, String? data, String? signature) {
    AccountFactoryManager man = AccountFactoryManager();
    return man.generalFactory.createDocument(type, identifier, data, signature);
  }

  static Document? parse(Object? doc) {
    AccountFactoryManager man = AccountFactoryManager();
    return man.generalFactory.parseDocument(doc);
  }

  static DocumentFactory? getFactory(String type) {
    AccountFactoryManager man = AccountFactoryManager();
    return man.generalFactory.getDocumentFactory(type);
  }
  static void setFactory(String type, DocumentFactory? factory) {
    AccountFactoryManager man = AccountFactoryManager();
    man.generalFactory.setDocumentFactory(type, factory);
  }
}

///  Document Factory
///  ~~~~~~~~~~~~~~~~
abstract class DocumentFactory {

  ///  Create document with data & signature loaded from local storage
  ///  Create a new empty document with entity ID only
  ///
  /// @param identifier - entity ID
  /// @param data       - document data (JsON)
  /// @param signature  - document signature (Base64)
  /// @return Document
  Document createDocument(ID identifier, String? data, String? signature);

  ///  Parse map object to entity document
  ///
  /// @param doc - info
  /// @return Document
  Document parseDocument(Map doc);
}
