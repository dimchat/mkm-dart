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
import 'crypto/keys.dart';
import 'format/encode.dart';
import 'protocol/address.dart';
import 'protocol/document.dart';
import 'protocol/identifier.dart';
import 'protocol/meta.dart';
import 'type/converter.dart';
import 'type/wrapper.dart';

/// Account FactoryManager
/// ~~~~~~~~~~~~~~~~~~~~~~
class AccountFactoryManager {
  factory AccountFactoryManager() => _instance;
  static final AccountFactoryManager _instance = AccountFactoryManager._internal();
  AccountFactoryManager._internal();

  AccountGeneralFactory generalFactory = AccountGeneralFactory();
}

/// Account GeneralFactory
/// ~~~~~~~~~~~~~~~~~~~~~~
class AccountGeneralFactory {
  AccountGeneralFactory() : _addressFactory = null, _idFactory = null;

  AddressFactory?                    _addressFactory;
  IDFactory?                         _idFactory;
  final Map<int, MetaFactory>        _metaFactories = {};
  final Map<String, DocumentFactory> _docFactories = {};

  ///
  ///   Address
  ///

  void setAddressFactory(AddressFactory factory) {
    _addressFactory = factory;
  }
  AddressFactory? getAddressFactory() {
    return _addressFactory;
  }

  Address? parseAddress(Object? address) {
    if (address == null) {
      return null;
    } else if (address is Address) {
      return address;
    }
    String? str = Wrapper.getString(address);
    if (str == null) {
      assert(false, 'address error: $address');
      return null;
    }
    AddressFactory? factory = getAddressFactory();
    assert(factory != null, 'address factory not ready');
    return factory?.parseAddress(str);
  }

  Address? createAddress(String address) {
    AddressFactory? factory = getAddressFactory();
    assert(factory != null, 'address factory not ready');
    return factory?.createAddress(address);
  }

  Address generateAddress(Meta meta, int? network) {
    AddressFactory? factory = getAddressFactory();
    assert(factory != null, 'address factory not ready');
    return factory!.generateAddress(meta, network);
  }

  ///
  ///   ID
  ///

  void setIdentifierFactory(IDFactory factory) {
    _idFactory = factory;
  }
  IDFactory? getIdentifierFactory() {
    return _idFactory;
  }

  ID? parseIdentifier(Object? identifier) {
    if (identifier == null) {
      return null;
    } else if (identifier is ID) {
      return identifier;
    }
    String? str = Wrapper.getString(identifier);
    if (str == null) {
      assert(false, 'ID error: $identifier');
      return null;
    }
    IDFactory? factory = getIdentifierFactory();
    assert(factory != null, 'ID factory not ready');
    return factory?.parseIdentifier(str);
  }

  ID createIdentifier({String? name, required Address address, String? terminal}) {
    IDFactory? factory = getIdentifierFactory();
    assert(factory != null, 'ID factory not ready');
    return factory!.createIdentifier(name: name, address: address, terminal: terminal);
  }

  ID generateIdentifier(Meta meta, int? network, {String? terminal}) {
    IDFactory? factory = getIdentifierFactory();
    assert(factory != null, 'ID factory not ready');
    return factory!.generateIdentifier(meta, network, terminal: terminal);
  }

  List<ID> convertIdentifiers(List members) {
    List<ID> array = [];
    ID? id;
    for (var item in members) {
      id = parseIdentifier(item);
      if (id == null) {
        continue;
      }
      array.add(id);
    }
    return array;
  }

  List<String> revertIdentifiers(List<ID> members) {
    List<String> array = [];
    for (var item in members) {
      array.add(item.toString());
    }
    return array;
  }

  ///
  ///   Meta
  ///

  void setMetaFactory(int version, MetaFactory factory) {
    _metaFactories[version] = factory;
  }
  MetaFactory? getMetaFactory(int version) {
    return _metaFactories[version];
  }

  int? getMetaType(Map meta, int? defaultValue) {
    return Converter.getInt(meta['type'], defaultValue);
  }

  Meta createMeta(int version, VerifyKey pKey, {String? seed, TransportableData? fingerprint}) {
    MetaFactory? factory = getMetaFactory(version);
    assert(factory != null, 'meta type not supported: $version');
    return factory!.createMeta(pKey, seed: seed, fingerprint: fingerprint);
  }

  Meta generateMeta(int version, SignKey sKey, {String? seed}) {
    MetaFactory? factory = getMetaFactory(version);
    assert(factory != null, 'meta type not supported: $version');
    return factory!.generateMeta(sKey, seed: seed);
  }

  Meta? parseMeta(Object? meta) {
    if (meta == null) {
      return null;
    } else if (meta is Meta) {
      return meta;
    }
    Map? info = Wrapper.getMap(meta);
    if (info == null) {
      assert(false, 'meta error: $meta');
      return null;
    }
    int version = getMetaType(info, 0)!;
    assert(version > 0, 'meta error: $meta');
    MetaFactory? factory = getMetaFactory(version);
    if (factory == null) {
      factory = getMetaFactory(0);  // unknown
      assert(factory != null, 'default meta factory not found');
    }
    return factory?.parseMeta(info);
  }

  //
  //  Document
  //

  void setDocumentFactory(String docType, DocumentFactory factory) {
    _docFactories[docType] = factory;
  }
  DocumentFactory? getDocumentFactory(String docType) {
    return _docFactories[docType];
  }

  String? getDocumentType(Map doc, String? defaultValue) {
    return Converter.getString(doc['type'], defaultValue);
  }

  Document createDocument(String docType, ID identifier, {String? data, TransportableData? signature}) {
    DocumentFactory? factory = getDocumentFactory(docType);
    assert(factory != null, 'document type not supported: $docType');
    return factory!.createDocument(identifier, data: data, signature: signature);
  }

  Document? parseDocument(Object? doc) {
    if (doc == null) {
      return null;
    } else if (doc is Document) {
      return doc;
    }
    Map? info = Wrapper.getMap(doc);
    if (info == null) {
      assert(false, 'document error: $doc');
      return null;
    }
    String docType = getDocumentType(info, '*')!;
    DocumentFactory? factory = getDocumentFactory(docType);
    if (factory == null) {
      assert(docType != '*', 'document factory not ready: $doc');
      factory = getDocumentFactory('*');  // unknown
      assert(factory != null, 'default document factory not found');
    }
    return factory?.parseDocument(info);
  }
}
