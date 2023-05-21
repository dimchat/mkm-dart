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

import 'crypto/format.dart';
import 'crypto/keys.dart';
import 'protocol/address.dart';
import 'protocol/document.dart';
import 'protocol/entity.dart';
import 'protocol/identifier.dart';
import 'protocol/meta.dart';
import 'type/wrapper.dart';

class AccountFactoryManager {
  factory AccountFactoryManager() => _instance;
  static final AccountFactoryManager _instance = AccountFactoryManager._internal();
  AccountFactoryManager._internal();

  AccountGeneralFactory generalFactory = AccountGeneralFactory();
}

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

  void setIDFactory(IDFactory factory) {
    _idFactory = factory;
  }
  IDFactory? getIDFactory() {
    return _idFactory;
  }

  ID? parseID(Object? identifier) {
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
    IDFactory? factory = getIDFactory();
    assert(factory != null, 'ID factory not ready');
    return factory?.parseID(str);
  }

  ID createID({String? name, required Address address, String? terminal}) {
    IDFactory? factory = getIDFactory();
    assert(factory != null, 'ID factory not ready');
    return factory!.createID(name: name, address: address, terminal: terminal);
  }

  ID generateID(Meta meta, int? network, {String? terminal}) {
    IDFactory? factory = getIDFactory();
    assert(factory != null, 'ID factory not ready');
    return factory!.generateID(meta, network, terminal: terminal);
  }

  List<ID> convertIdentifiers(List members) {
    List<ID> array = [];
    ID? id;
    for (var item in members) {
      id = parseID(item);
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

  int? getMetaType(Map meta) {
    return meta['type'];
  }

  Meta? createMeta(int version, VerifyKey pKey,
      {String? seed, Uint8List? fingerprint}) {
    MetaFactory? factory = getMetaFactory(version);
    assert(factory != null, 'meta type not supported: $version');
    return factory?.createMeta(pKey, seed: seed, fingerprint: fingerprint);
  }

  Meta? generateMeta(int version, SignKey sKey, {String? seed}) {
    MetaFactory? factory = getMetaFactory(version);
    assert(factory != null, 'meta type not supported: $version');
    return factory?.generateMeta(sKey, seed: seed);
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
    int? version = getMetaType(info);
    version ??= 0;
    MetaFactory? factory = getMetaFactory(version);
    if (factory == null && version != 0) {
      factory = getMetaFactory(0);  // unknown
    }
    assert(factory != null, 'cannot parse meta: $meta');
    return factory?.parseMeta(info);
  }

  bool checkMeta(Meta meta) {
    VerifyKey key = meta.key;
    // assert(key != null, 'meta.key should not be empty: $meta');
    if (!MetaType.hasSeed(meta.type)) {
      // this meta has no seed, so no signature too
      return true;
    }
    // check seed with signature
    String? seed = meta.seed;
    Uint8List? fingerprint = meta.fingerprint;
    if (seed == null || fingerprint == null) {
      // seed and fingerprint should not be empty
      return false;
    }
    // verify fingerprint
    return key.verify(UTF8.encode(seed), fingerprint);
  }

  bool matchID(ID identifier, Meta meta) {
    // check ID.name
    String? seed = meta.seed;
    String? name = identifier.name;
    if (name == null || name.isEmpty) {
      if (seed != null && seed.isNotEmpty) {
        return false;
      }
    } else if (name != seed) {
      return false;
    }
    // check ID.address
    Address old = identifier.address;
    Address? gen = Address.generate(meta, old.type);
    return old == gen;
  }
  bool matchKey(VerifyKey pKey, Meta meta) {
    // check whether the public key equals to meta.key
    if (pKey == meta.key) {
      return true;
    }
    // check with seed & fingerprint
    if (MetaType.hasSeed(meta.type)) {
      // check whether keys equal by verifying signature
      String? seed = meta.seed;
      Uint8List? fingerprint = meta.fingerprint;
      return pKey.verify(UTF8.encode(seed!), fingerprint!);
    } else {
      // NOTICE: ID with BTC/ETH address has no username, so
      //         just compare the key.data to check matching
      return false;
    }
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

  String? getDocumentType(Map doc) {
    return doc['type'];
  }

  Document? createDocument(String docType, ID identifier,
      {String? data, String? signature}) {
    DocumentFactory? factory = getDocumentFactory(docType);
    assert(factory != null, 'document type not supported: $docType');
    return factory?.createDocument(identifier, data: data, signature: signature);
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
    String? docType = getDocumentType(info);
    docType ??= '*';
    DocumentFactory? factory = getDocumentFactory(docType);
    if (factory == null && docType != '*') {
      factory = getDocumentFactory('*');  // unknown
    }
    assert(factory != null, 'cannot parse document: $doc');
    return factory?.parseDocument(info);
  }
}
