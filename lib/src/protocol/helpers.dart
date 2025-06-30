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
import '../format/encode.dart';

import 'address.dart';
import 'document.dart';
import 'identifier.dart';
import 'meta.dart';

///  General Helpers
///  ~~~~~~~~~~~~~~~

abstract interface class AddressHelper {

  void setAddressFactory(AddressFactory factory);
  AddressFactory? getAddressFactory();

  Address? parseAddress(Object? address);

  Address generateAddress(Meta meta, int? network);

}

abstract interface class IdentifierHelper {

  void setIdentifierFactory(IDFactory factory);
  IDFactory? getIdentifierFactory();

  ID? parseIdentifier(Object? identifier);

  ID createIdentifier({String? name, required Address address, String? terminal});

  ID generateIdentifier(Meta meta, int? network, {String? terminal});

}

abstract interface class MetaHelper {

  void setMetaFactory(String type, MetaFactory factory);
  MetaFactory? getMetaFactory(String type);

  Meta createMeta(String type, VerifyKey pKey,
      {String? seed, TransportableData? fingerprint});

  Meta generateMeta(String type, SignKey sKey, {String? seed});

  Meta? parseMeta(Object? meta);

}

abstract interface class DocumentHelper {

  void setDocumentFactory(String docType, DocumentFactory factory);
  DocumentFactory? getDocumentFactory(String docType);

  Document createDocument(String docType, ID identifier,
      {String? data, TransportableData? signature});

  Document? parseDocument(Object? doc);

}


/// Account FactoryManager
/// ~~~~~~~~~~~~~~~~~~~~~~
// protected
class AccountExtensions {
  factory AccountExtensions() => _instance;
  static final AccountExtensions _instance = AccountExtensions._internal();
  AccountExtensions._internal();

  AddressHelper? addressHelper;
  IdentifierHelper? idHelper;

  MetaHelper? metaHelper;
  DocumentHelper? docHelper;

}
